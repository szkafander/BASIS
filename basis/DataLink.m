classdef DataLink
    % a class that handles Stores or on-disk storage via .mat files.
    % DataLink objects behave as value class objects. copying them copies
    % handles to their Links, not the data itself!
    
    properties
        % logical, if true, storage is in-memory, i.e., in a Store that
        % appears in the main workspace
        IsInMemory
        % the name of the Store, either the Store object or the .mat file
        StoreName
        % a handle to the Store
        Link        
    end
    
    methods       
        function obj = DataLink(varargin)
            % constructor
            %
            % usage:
            %   datalink = DataLink() - creates a DataLink object that
            %       links an anonymous in-memory Store object. the Store
            %       object will not appear in the workspace, only linked
            %       via datalink.
            %   datalink = DataLink(path) - creates a DataLink object
            %       linking an on-disk storage specified as a .mat file. if
            %       no such file is found, DataLink creates it.
            %   datalink = DataLink(store) - creates a DataLink object
            %       linking an in-memory Store object. the Store object
            %       must exist in the workspace.
            
            p = inputParser;
            addOptional(p, 'store', [], @(x)ischar(x)||isa(x, 'Store'));
            parse(p, varargin{:});
            
            store_name = p.Results.store;
            
            if ischar(store_name)                
                ext_ = [];
                if ~isempty(store_name)
                    [~, ~, ext_] = fileparts(store_name);
                end                
                if strcmpi(ext_, '.mat')
                    % matfile read/write does not work fully as of 2016b
                    % Mathworks is implementing full functionality as of
                    % 2018.08 linking to disk datastores does work in
                    % DataLink, but it is inefficient.
                    obj.IsInMemory = false;
                    if ~exist(store_name, 'file')
                        info = [store_name ', created by DataLink'];
                        save(store_name, 'info', '-v7.3');
                    end
                    obj.Link = matfile(store_name, 'writable', true);
                    obj.StoreName = store_name;
                end
                
            else
                obj.IsInMemory = true;
                if isempty(store_name)
                    obj.Link = Store();
                else
                    obj.Link = store_name;
                    obj.StoreName = inputname(1);
                end
            end            
        end        
        
        function append(obj, data_, property_name)
            % appends data to the linked Store object. cells, strings, 
            % tables and numeric arrays are supported. appending chars to 
            % chars creates a cell of strings. appending tables appends 
            % rows. appending numeric arrays appends to the first dimension
            %
            % inputs:
            %   data (many types) - the data to append
            %   property_name (string) - the name of the property to which
            %       the data will be appended. if the property does not
            %       exist, it will be created.
            %
            % outputs: none (modifies caller object)
            if obj.IsInMemory
                obj.Link.append(data_, property_name);
            else
                % TODO - add proper appending here (cells, structs, etc.)
                if ismember(property_name, fieldnames(obj.Link))
                    obj.Link.(property_name) = ...
                        append_to(obj.Link.(property_name), data_);
                else
                    obj.Link.(property_name) = data_;
                end
            end            
        end
        
        
        function aggregate(obj, data_, property_name, varargin)
            % aggregates data. calls an aggregating function specified by
            % a function handle mode. the new data is mode(old data, data
            % to aggregate with).
            %
            % inputs:
            %   data (many types) - data to aggregate with
            %   property_name (string) - name of the property to aggregate
            %       with
            %   mode (function handle) - name-value pair that specifies the
            %       aggregating function. the default is @(x,y)x+y, i.e.,
            %       addition.
            %
            % outputs: none (modifies caller object)
            
            p = inputParser;
            addParameter(p, 'mode', @(x,y)x+y, ...
                @(x)isa(x, 'function_handle'));
            parse(p, varargin{:});
            
            mode_ = p.Results.mode;
            
            if obj.IsInMemory
                obj.Link.aggregate(data_, property_name, 'mode', mode_);
            else
                if ismember(property_name, fieldnames(obj.Link))
                    obj.Link.(property_name) = ...
                        aggregate_with(obj.Link.(property_name), data_, ...
                        mode_);
                else
                    obj.Link.(property_name) = data_;
                end
            end            
        end       
    end    
end