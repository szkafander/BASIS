classdef ProcessingFunction < matlab.mixin.Copyable
    % this class handles functions that can be called in Graph Nodes. the
    % purpose of ProcessingFunction is to store a handle for the function,
    % parametrize the function and parse the number of inputs and outputs.
    
    properties
        % the name of the function stored in the object
        FunctionName
        % the number of input arguments
        NumInputs
        % the number of output arguments
        NumOutputs
        % logical, true if there are a variable number of input arguments
        VariableNumInputs
        % logical, true if there are a variable number of output arguments
        VariableNumOutputs
        % separate parameters can be passed
        Parameters
        % any string description to attach to the object
        Description
    end
    
    properties (Hidden = true)
        % the function handle
        Handle
    end
    
    methods
        function obj = ProcessingFunction(varargin)
            % constructor
            %
            % usage:
            %   pf = ProcessingFunction() - creates an empty
            %       ProcessingFunction object with an @identity handle
            %   pf = ProcessingFunction(function_handle) - creates a
            %       ProcessingFunction with a function handle
            %       function_handle. the number of inputs and outputs will
            %       be attempted to be parsed from the function definition,
            %       if found.
            %   pf = ProcessingFunction(function_name) - creates a
            %       ProcessingFunction with a function handle parsed from a
            %       function name. the number of inputs and outputs will
            %       be attempted to be parsed from the function definition,
            %       if found.
            %
            % name-value pairs:
            %   numinputs (integer-valued scalar) - the number of input
            %       arguments
            %   numoutputs (integer-valued scalar) - the number of output
            %       arguments
            %   parameters (cell) - additional parameters passed to the
            %       function. additional name-value pairs can be
            %       incorporated as well with their normal syntax. can only
            %       be used if the object is constructed from a function
            %       name.
            %   description (string) - any description or comment to be
            %       attached to the object for your own information.
            
            p = inputParser;
            addOptional(p, 'function_name', @identity, ...
                @(x)ischar(x)|| ...
                isa(x, 'function_handle')|| ...
                isa(x, 'ProcessingFunction'));
            addParameter(p, 'numinputs', 'not specified', ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'integer', 'nonnegative'}));
            addParameter(p, 'numoutputs', 'not specified', ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'integer', 'nonnegative'}));
            addParameter(p, 'parameters', {});
            addParameter(p, 'description', 'not specified', @ischar);
            parse(p, varargin{:});
            
            function_name_ = p.Results.function_name;
            parameters_ = p.Results.parameters;
            description_ = p.Results.description;
            numinputs_ = p.Results.numinputs;
            numoutputs_ = p.Results.numoutputs;
            
            if isa(function_name_, 'ProcessingFunction')
                obj = function_name_.copy();
            else
                [n_argin, has_varargin, n_argout, ...
                    has_varargout, function_name_formatted, ...
                    true_function_name] = ...
                    get_number_of_args(function_name_);
                
                if isa(function_name_, 'function_handle')
                    handle_function = function_name_;
                else
                    if ~isspecified(function_name_)
                        handle_function = '@identity';
                    else
                        handle_function = ...
                            str2func(function_name_formatted);
                    end
                end

                obj.FunctionName = true_function_name;
                obj.Parameters = parameters_;
                obj.Description = description_;
                
                handle_function = @(varargin)handle_function( ...
                    varargin{:}, obj.Parameters{:});
                obj.Handle = handle_function;
                
                if isspecified(numinputs_)
                    obj.NumInputs = numinputs_;
                    obj.VariableNumInputs = false;
                else
                    obj.NumInputs = n_argin;
                    obj.VariableNumInputs = has_varargin;
                end
                if isspecified(numoutputs_)
                    obj.NumOutputs = numoutputs_;
                    obj.VariableNumOutputs = false;
                else
                    obj.NumOutputs = n_argout;
                    obj.VariableNumOutputs = has_varargout;
                end
            end            
        end        
        
        function set.NumInputs(obj, val)
            % setter for the NumInputs property. does argument checking.
            % 
            % inputs:
            %   val (integer-valued scalar) - the number of inputs
            %
            % outputs: none (modifies caller object)
            
            validateattributes(val, {'numeric'}, ...
                {'scalar', 'integer', 'nonnegative'});
            obj.NumInputs = val;
        end
        
        function set.NumOutputs(obj, val)
            % setter for the NumOutputs property. does argument checking.
            % 
            % inputs:
            %   val (integer-valued scalar) - the number of outputs
            %
            % outputs: none (modifies caller object)
            
            validateattributes(val, {'numeric'}, ...
                {'scalar', 'integer', 'nonnegative'});
            obj.NumOutputs = val;
        end        
        
        function output_ = apply(obj, varargin)
            % applies the stored function to the passed inputs. rules for
            % number of input and outputs arguments:
            %   1. if the number of outputs is 0, returns an empty array
            %   2. if the number of outputs is non-zero, returns exactly
            %       that many outputs. if the function returns more
            %       arguments by definition, the outputs are truncated at
            %       NumOutputs.
            %   3. if the number of ouputs is more than 1 and the function
            %       returns more than 1 outputs, a cell of outputs is
            %       returned.
            %
            % inputs:
            %   variable number of inputs, inputs of the function stored in
            %       Handle
            
            if obj.NumOutputs == 0
                output_ = [];
                obj.Handle(varargin{:});
            elseif obj.NumOutputs == 1
                output_ = obj.Handle(varargin{:});
            else
                output_ = cell(1, obj.NumOutputs);
                [output_{:}] = obj.Handle(varargin{:});                
            end            
        end        
    end
end