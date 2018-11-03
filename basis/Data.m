classdef Data < matlab.mixin.Copyable
    % stores data to be used in Graph Nodes. Data is passed by reference,
    % i.e., no local copies are kept in Nodes. the Data class is subclass
    % of matlab.mixin.Copyable, i.e., it behaves as a handle class.    
    
    properties
        % holds the data in a value class object
        Value
        % any metadata to be attached to the Data object
        Metadata        
    end
    
    properties (Dependent = true, SetAccess = private)
        % logical, true if the Data object has any data
        HasData
    end    
    
    methods        
        function obj = Data(varargin)
            % constructor
            %
            % usage:
            %   data = Data() - creates empty Data object
            %   data = Data(value) - creates Data object with value in the
            %       Value property
            %   data = Data(_, 'metadata', metadata) - include metadata in
            %       the Metadata property
            
            p = inputParser;
            addOptional(p, 'value', [], @(x)true);
            addParameter(p, 'metadata', []);
            parse(p, varargin{:});
            
            value_ = p.Results.value;
            
            if isa(value_, 'Data')
                obj = value_;
            else            
                obj.Value = p.Results.value;
                obj.Metadata = p.Results.metadata;
            end
        end        
        
        function has_data_ = get.HasData(obj)
            % dependent method to check if the Data object has any data in
            % it. returns true if the Value property is not empty.
            %
            % inputs: none
            %
            % outputs:
            %   has_data_ (logical) - true if the Data object has a
            %       non-empty Value property.
            
            has_data_ = ~isempty(obj.Value);
        end        
        
        function is_equal = eq(data_1, data_2)
            % checks equality between two Data objects. returns true if the
            % two has equal Values.
            %
            % inputs:
            %   data_1 - the first Data object
            %   data_2 - the second Data object
            %
            % outputs:
            %   is_equal (logical) - true if the Value of the two Data
            %       objects are equal, otherwise false
            
            is_equal = data_1.HasData == data_2.HasData && ...
                are_equal(data_1.Value, data_2.Value);
        end        
        
        function set(obj, data_, varargin)
            % sets the Value or Metadata property of the Data object.
            %
            % inputs:
            %   data_ (any type) - the value to set
            %   metadata (any type) - name-value pair, this will be passed
            %       to the Metadata property. the default is [].
            %
            % outputs: none (modifies the caller object)
            
            p = inputParser;
            addParameter(p, 'metadata', []);
            parse(p, varargin{:});
            metadata_ = p.Results.metadata;
            if isa(data_, 'Data')
                obj.Value = data_.Value;
                obj.Metadata = data_.Metadata;
            else
                obj.Value = data_;
                obj.Metadata = metadata_;
            end
        end        
        
        function append(obj, data_, varargin)
            % appends data_ to the Value property of the caller Data
            % object.
            % 
            % inputs:
            %   data_ (any type) - the data to append
            %   metadata (any type) - name-value pair, this will be passed
            %       to the Metadata property. the default is [].
            %
            % outputs: none (modifies the caller object)
            
            p = inputParser;
            addParameter(p, 'metadata', []);
            parse(p, varargin{:});
            metadata_ = p.Results.metadata;
            if isa(data_, 'Data')
                data_ = data_.Value;
                if isempty(metadata_)
                    metadata_ = data_.Metadata;
                end
            end
            
            if iscell(obj.Value)
                obj.Value{end + 1} = data_;
            else
                obj.Value = {obj.Value data_};
            end
            if iscell(obj.Metadata)
                obj.Metadata{end + 1} = metadata_;
            else
                obj.Metadata = {obj.Metadata metadata_};
            end            
        end        
        
        function clear(obj)
            % clears both the Value and Metadata properties.
            %
            % inputs: none
            %
            % outputs: none (modifies the caller object)
            
            obj.Value = [];
            obj.Metadata = [];
        end              
    end
end