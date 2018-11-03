classdef Store < dynamicprops
    % a datastore class that has dynamic properties. appendable and
    % aggregatable. handles many data types.
    
    methods        
        function append(obj, data, property_name)
            % appends data to the Store object. cells, strings, tables and
            % numeric arrays are supported. appending chars to chars
            % creates a cell of strings. appending tables appends rows.
            % appending numeric arrays appends to the first dimension.
            %
            % inputs:
            %   data (many types) - the data to append
            %   property_name (string) - the name of the property to which
            %       the data will be appended. if the property does not
            %       exist, it will be created.
            %
            % outputs: none (modifies caller object)
            
            if ~isprop(obj, property_name)
                addprop(obj, property_name);
            end            
            obj.(property_name) = append_to(obj.(property_name), data);                       
        end        
        
        function aggregate(obj, data, property_name, varargin)
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
            
            if ~isprop(obj, property_name)
                addprop(obj, property_name);
            end            
            
            obj.(property_name) = aggregate_with(obj.(property_name), ...
                data, mode_);                      
        end        
    end   
end