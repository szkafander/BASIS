classdef Node < matlab.mixin.Copyable
    % the basic building block of Graphs. stores input and outputs data,
    % keeps track of routing, stores and runs Pipelines. Node is a subclass
    % of matlab.mixin.Copyable, therefore it behaves like a handle class.
    
    properties
        % the name of the Node
        Label
        % the type of the Node
        Type
        % type attributes, used to parametrize type behavior
        TypeAttributes
        % the stored Pipeline
        Pipeline
        % list of input Node labels in the Graph
        InputNodes
        % list of output Node labels in the Graph
        OutputNodes
        % indices of Groups of which the Node is a member of
        Group
        % input Data
        Input
        % output Data
        Output
    end
    
    properties (Hidden = true, Constant = true)
        % constant, valid types
        VALID_TYPES = {'input-output', 'accumulating', 'memory', ...
            'delay', 'once', 'skip'}
    end
    
    properties (SetAccess = ?Graph)
        % protected, true if Node is a Graph input Node
        IsInputNode = false
        % protected, true if Node is a Graph output Node
        IsOutputNode = false
        % protected, list of predecessor Node indices in the Graph
        UpstreamNodeIDs
    end
    
    properties (Hidden = true, SetAccess = ?Graph)
        % protected, list of input Node indices in the Graph
        InputNodeIDs
        % protected, list of output Node indices in the Graph
        OutputNodeIDs
    end
    
    properties (Dependent = true, SetAccess = private)
        % dependent, protected, true if the Node has been computed
        IsComputed;
    end
    
    methods
        function obj = Node(varargin)
            % constructor
            %
            % usage:
            %   node = Node() - creates an empty Node
            %   node = Node(pipeline) - creates a Node with a Pipeline
            %       pipeline
            %   node = Node(processingfunction) - creates a Node with a
            %       Pipeline that holds a single ProcessingFunction
            %       processingfunction
            %   node = Node({pf1, pf2, ...}) - creates a Node with a
            %       Pipeline from a cell of ProcessingFunctions pf1, pf2,
            %       ...
            %   node = Node(name) - creates a Node with a Pipeline that
            %       holds a single ProcessingFunction from the function
            %       name name
            %   node = Node(function_handle) - creates a Node with a
            %       Pipeline constructed from a function handle
            %   node = Node(_, name, value) - name-value pairs include:
            %       inputnodes (string, cell of strings or integer-valued
            %           numeric) - list of input Nodes in the Graph
            %       outputnodes (string, cell of strings or integer-valued
            %           numeric) - list of output Nodes in the Graph
            %       data (cell) - convenience parameter, sets the Node 
            %           Output Value
            %       label (string) - Node label
            %       type (string) - Node type. valid types are: 
            %           'input-output', 'accumulating', 'memory', 'delay', 
            %           'once' and 'skip'.
            %       typeattributes (struct) - type attribute specifiers
            %       group (integer-valued numeric) - list of Group indices
            %           of which the Node is a member of
            
            p = inputParser;
            addParameter(p, 'pipeline', @identity, ...
                @(x)iscell(x)|| ...
                ischar(x)|| ...
                isa(x, 'function_handle')|| ...
                isa(x, 'ProcessingFunction')|| ...
                isa(x, 'Pipeline'));
            addParameter(p, 'inputnodes', [], ...
                @(x)validateattributes(x, {'char', 'numeric', 'cell'}, ...
                {'vector'}));
            addParameter(p, 'outputnodes', [], ...
                @(x)validateattributes(x, {'char', 'numeric', 'cell'}, ...
                {'vector'}));
            addParameter(p, 'data', {}, ...
                @(x)validateattributes(x, {'cell'}, {}));
            addParameter(p, 'label', [], ...
                @ischar);
            addParameter(p, 'type', 'input-output', @ischar);
            addParameter(p, 'typeattributes', []);
            addParameter(p, 'group', [], ...
                @(x)isempty(x)||isvector(x));
            parse(p, varargin{:});
            
            obj.Type = p.Results.type;
            obj.validate_type();
            obj.set_type_attributes(p.Results.typeattributes);
                        
            obj.Pipeline = p.Results.pipeline;
            if ischar(p.Results.inputnodes)
                obj.InputNodes = {p.Results.inputnodes};
            else
                obj.InputNodes = p.Results.inputnodes;
            end
            if ischar(p.Results.outputnodes)
                obj.OutputNodes = {p.Results.outputnodes};
            else
                obj.OutputNodes = p.Results.outputnodes;
            end
            obj.Label = p.Results.label;            
            obj.Group = p.Results.group;
            obj.Input = [];
            obj.Output = Data(p.Results.data);
        end        
        
        function is_computed = get.IsComputed(obj)
            % dependent method, returns true if the Node Output Value is
            % not empty.
            % 
            % inputs: none
            %
            % outputs:
            %   is_computed (logical) - true if the Node Output Value is
            %   non-empty
            
            is_computed = obj.Output.HasData;
        end            
        
        function set.Pipeline(obj, input_)
            % setter for the Pipeline property. calls the Pipeline
            % constructor on whatever is passed.
            % 
            % inputs:
            %   input_ - the input argument, normally a valid argument of
            %       the Pipeline class constructor
            %
            % outputs: none (modifies the caller object)
            
            obj.Pipeline = Pipeline(input_);
        end        
        
        function set.Group(obj, group_)
            % setter for the Group property, runs a validation routine on
            % the input argument
            %
            % inputs:
            %   group_ (integer-valued numeric) - a list of indices of
            %       Groups of which the Node is a member of
            
            validateattributes(group_, {'numeric'}, ...
                {'nonnegative'});
            obj.Group = group_(:)';
        end        
        
        function has_changed = update_data(obj, data_, varargin)
            % updates the Value in the target Input, Output or both
            % properties. propagates changes to successors by default.
            %
            % inputs:
            %   data_ (any type) - the data to update with
            %   target (string) - 'output', or 'input', specifies the
            %       target property to update. name-value pair, the default
            %       is 'output'.
            %
            % outputs:
            %   has_changed (logical) - true if the data changed, false if
            %       the same value was passed as the original.
            
            p = inputParser;
            addParameter(p, 'target', 'output', @ischar);
            parse(p, varargin{:});
            target_ = p.Results.target;
            
            has_changed = false;
            
            switch lower(target_)
                case 'output'
                    for ind_data = 1:numel(obj.Output)
                        if ~are_equal(obj.Output(ind_data), data_)
                            obj.Output(ind_data).set(data_);
                            has_changed = true;
                        end
                    end
                case 'input'
                    for ind_data = 1:numel(obj.Input)
                        if ~are_equal(obj.Input(ind_data), data_)
                            obj.Input(ind_data).set(data_);
                            obj.clear('target', 'output');
                            has_changed = true;
                        end
                    end
                otherwise
                    error(['Target invalid. Valid targets: ' ...
                        'input and output.']);
            end
        end        
        
        function clone_data(obj, target_node, varargin)
            % copies Node data to another Node object.
            %
            % inputs:
            %   target_node - Node, the target Node object to copy data
            %   target_field (string) - optional, either 'input' or 
            %       'output', specifying the target field of the target 
            %       Node object to copy to. default: 'output'
            %   source_field (string) - optional, either 'input' or 
            %       'output' specifying the source field of the caller Node
            %       from which data will be copied. default: 'output'
            
            p = inputParser;
            addRequired(p, 'target_node', @(x)isa(x, 'Node'));
            addOptional(p, 'target_field', 'output', ...
                @(x)ischar(x)&&ismember(lower(x), {'input', 'output'}));
            addOptional(p, 'source_field', 'output', ...
                @(x)ischar(x)&&ismember(lower(x), {'input', 'output'}));
            parse(p, target_node, varargin{:});
            target_node = p.Results.target_node;
            target_field = p.Results.target_field;
            source_field = p.Results.source_field;
            
            switch lower(source_field)
                case 'output'
                    data_ = obj.Output;
                case 'input'
                    data_ = obj.Input;
                otherwise
                    data_ = obj.Output;
            end
            
            switch lower(target_field)
                case 'input'
                    target_node.Input.set(data_);
                case 'output'
                    target_node.Output.set(data_);
            end
        end        
        
        function clear(obj, varargin)
            % clears Node Output, Input or both
            % 
            % inputs:
            %   target (string) - name-value pair, can be 'input', 'output'
            %       and 'both'. specifies the target property to be cleared
            % 
            % outputs:
            %   none (modifies the caller object)
            
            p = inputParser;
            addParameter(p, 'target', 'output', @ischar);
            parse(p, varargin{:});
            target_ = p.Results.target;
            
            obj.update_data({}, 'target', target_);
        end        
        
        function run(obj)
            % runs Node, updates Output property. runs Node according to
            % the protocol corresponding the Node type:
            %
            %   - input-output Nodes run only when not computed. they run
            %       their Pipeline one time and set their Output field
            %       equal to the returned value
            %   - accumulating Nodes aggregate their Outputs. the Output
            %       will be set to Pipeline(Output, Input)
            %   - memory Nodes append their Outputs. the Output will be set
            %       to [Output Pipeline(Input)], where concatenation might
            %       not exclusively be array concatenation
            %   - skip Nodes only run every TypeAttributes.skip times,
            %       otherwise they pass their Inputs unchanged
            %
            % inputs: none
            %
            % outputs: none (modifies caller object)
            
            switch obj.Type                
                case 'input-output'
                    if ~obj.IsComputed
                        obj.Output.set(obj.Pipeline.apply(obj.Input.Value));
                    end                    
                case 'accumulating'
                    if obj.IsComputed
                        obj.Output.set(obj.Pipeline.apply( ...
                            obj.Output.Value, obj.Input.Value));
                    else
                        obj.Output.set(obj.Input.Value);
                    end                    
                case 'memory'
                    if isempty(obj.Output.Value)
                        obj.Output.set({obj.Pipeline.apply( ...
                            obj.Input.Value)});
                    elseif numel(obj.Output.Value) < ...
                            obj.TypeAttributes.buffersize
                        obj.Output.append( ...
                            obj.Pipeline.apply(obj.Input.Value));
                    else
                        obj.Output.set(obj.Output.Value(2:end));
                        obj.Output.append(obj.Pipeline.apply( ...
                            obj.Input.Value));
                    end                    
                case 'skip'
                    obj.TypeAttributes.counter = ...
                        obj.TypeAttributes.counter + 1;
                    if rem(obj.TypeAttributes.counter, ...
                            obj.TypeAttributes.skip) == 0
                        obj.Output.set(obj.Pipeline.apply( ...
                            obj.Input.Value));
                    end                    
                otherwise
                    obj.error_node_type();
            end            
        end        
        
        function set_data(obj, data_)
            % convenience method, sets Input if Node is an input Node
            %
            % inputs:
            %   data_ (any type) - the data to set
            %
            % outputs: none (modifies caller object)
            
            if obj.IsInputNode
                obj.Input.set(data_);
            else
                error(['Data can be only set from outside the Node ' ...
                    'class for input nodes.']);
            end
        end
        
        function reorder_input_node_ids(obj, new_order)
            % this method reorders the Node's InputNodeIDs property
            %
            % inputs:
            %   new_order (integer-valued numeric) - a list of indices,
            %   InputNodeIDs will be set to InputNodeIDs(new_order).
            %
            % outputs: none (modifies caller object)
            
            validateattributes(new_order, {'numeric'}, ...
                {'integer', 'vector'});
            if numel(new_order) ~= numel(obj.InputNodeIDs)
                error(['The number of ordering indices must match the ' ...
                    'number of input node IDs']);
            end
            if numel(unique(new_order)) ~= numel(new_order)
                error('Ordering indices must be unique.');
            end
            obj.InputNodeIDs = obj.InputNodeIDs(new_order);
        end        
        
        function copied_object = deep_copy(obj)
            % creates a deep copy of the Node, including its Input and
            % Output.
            % 
            % inputs: none
            %
            % outputs:
            %   copied_object (Node) - the deep copy of the caller Node.
            %       modifying the properties of copied_object will not
            %       affect the caller Node.
            
            copied_object = obj.copy();
            copied_object.Pipeline = obj.Pipeline.deep_copy();
            if isa(obj.Input, 'Data')
                copied_object.Input = obj.Input.copy();
            end
            if isa(obj.Output, 'Data')
                copied_object.Output = obj.Output.copy();
            end
        end        
        
        function hash = pipeline_hash(obj)
            % returns a hash of the Node's serialized Pipeline property.
            % this is used to compare the Pipelines of two or more Nodes.
            % the returned hashes are equal only if the Pipelines are
            % exactly the same.
            %
            % inputs: none
            % outputs:
            %   hash (string) - the hash as a string
            
            hash = DataHash(obj.Pipeline.get_nor);
        end
    end
    
    methods (Access = private)        
        function validate_type(obj)
            if ~ismember(obj.Type, obj.VALID_TYPES)
                obj.error_node_type();
            end
        end        
        
        function set_type_attributes(obj, type_attributes)
            if ~isstruct(type_attributes)
                switch obj.Type
                    case 'input-output'
                        obj.TypeAttributes = struct('counter', 0);
                    case 'memory'
                        obj.TypeAttributes = struct('counter', 0, ...
                            'buffersize', type_attributes);
                    case 'skip'
                        obj.TypeAttributes = struct('counter', 0, ...
                            'skip', type_attributes);
                    case 'accumulating'
                        obj.TypeAttributes = struct('counter', 0, ...
                            'skip', type_attributes);
                end
            else
                obj.TypeAttributes = type_attributes;
            end
        end        
        
        function error_node_type(obj)
            error(['Invalid Node type was specified (''' obj.Type ...
                ''') Valid types are: ' ...
                strjoin(obj.VALID_TYPES, ', ') '.']);
        end        
    end    
end