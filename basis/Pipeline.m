classdef Pipeline < matlab.mixin.Copyable
    % encapsulation for ProcessingFunction objects.
    % allows higher-level manipulation of lists of ProcessingFunction
    % objects and runs chains of ProcessingFunction objects.
    
    properties        
        % cell of processingFunction objects
        ProcessingFunctions        
    end
    
    methods        
        function obj = Pipeline(varargin)
            % constructor
            %
            % usage:
            %   pipeline = Pipeline() - empty Pipeline object, fields must
            %       be filled out manually
            %   pipeline = Pipeline(function handle) - constructs a
            %       Pipeline with one ProcessingFunction from the passed
            %       function handle
            %   pipeline = Pipeline(processingfunction) - constructs a
            %       Pipeline object with one ProcessingFunction defined by
            %       the processingfunction argument
            %   pipeline = Pipeline(function name) - constructs a Pipeline
            %       object with one ProcessingFunction constructed from the
            %       passed function name
            %   pipeline = Pipeline(cell) - constructs a Pipeline object
            %       with a chain of ProcessingFunctions defined in the
            %       passed cell. ProcessingFunctions will be chained in the
            %       order they appear in the passed cell. inside the cell,
            %       any argument of the ProcessingFunction constructor can
            %       be passed (function name, function handle or
            %       ProcessingFunction).
            
            p = inputParser;
            addOptional(p, 'processingfunctions', {}, ...
                @(x)iscell(x)|| ...
                ischar(x)|| ...
                isa(x, 'function_handle')|| ...
                isa(x, 'ProcessingFunction')|| ...
                isa(x, 'Pipeline'));
            parse(p, varargin{:});
            
            % handle processingfunctions
            processingfunctions = p.Results.processingfunctions;            
            if isa(processingfunctions, 'ProcessingFunction')
                % single ProcessingFunction
                obj.ProcessingFunctions = {processingfunctions};                
            elseif isa(processingfunctions, 'function_handle')|| ...
                    ischar(processingfunctions)
                % single function handle
                obj.ProcessingFunctions = ...
                    {ProcessingFunction(processingfunctions)};
            elseif isa(processingfunctions, 'Pipeline')
                obj = processingfunctions.copy();
            elseif iscell(processingfunctions)
                % cell of something
                if all(cellfun(@(x)isa(x, 'function_handle') ...
                        ||isa(x, 'ProcessingFunction') ...
                        ||ischar(x), ...
                        processingfunctions))
                    obj.ProcessingFunctions = cellfun( ...
                        @(x)ProcessingFunction(x), processingfunctions, ...
                        'UniformOutput', false);
                else
                    error(['Pipeline input not recognized. The ' ...
                        'Pipeline constructor accepts single function ' ...
                        'handles, single ProcessingFunction objects ' ...
                        'and cell arrays of function handles or ' ...
                        'ProcessingFunction objects.']);
                end
            else
                error(['Pipeline input not recognized. The ' ...
                    'Pipeline constructor accepts single function ' ...
                    'handles, single ProcessingFunction objects ' ...
                    'and cell arrays of function handles or ' ...
                    'ProcessingFunction objects.']);
            end
        end
        
        function obj = add_processingfunction(obj, processingfunction)
            % appends a processingFunction to pipeline.ProcessingFunctions.
            %
            % inputs:
            %   processingfunction - a ProcessingFunction object or any
            %       type from which a ProcessingFunction can be constructed
            %
            % outputs: none (modifies caller object)
            
            obj.ProcessingFunctions = [obj.ProcessingFunctions ...
                {ProcessingFunction(processingfunction)}];            
        end
        
        function output_ = apply(obj, varargin)
            % applies the processingFunctions stored in the pipeline in
            % succession to input and returns the final output. input and
            % output types vary and depend on the called 
            % ProcessingFunctions. input-output consistency is not checked 
            % explicitly by Pipeline. ProcessingFunctions are called
            % sequentially, i.e., pipeline.ProcessingFunctions{1} is called
            % first.
            %
            % inputs:
            %   the function inputs, variable number and types
            %
            % outputs:
            %   outputs_ (variable type) - the output of the chain
            
            if ~isempty(obj.ProcessingFunctions)
                for cnt_pf = 1:numel(obj.ProcessingFunctions)
                    if cnt_pf == 1
                        output_ = varargin;
                    end
                    if iscell(output_)
                        output_ = ...
                            obj.ProcessingFunctions{cnt_pf}.apply( ...
                            output_{:});
                    else
                        output_ = ...
                            obj.ProcessingFunctions{cnt_pf}.apply(output_);
                    end
                end
            else
                error(['Pipeline does not contain any ' ...
                    'processing functions.']);
            end            
        end
        
        function nor = get_nor(obj)
            % returns a string representation of the object. used to
            % compare Pipelines.
            %
            % inputs: none
            %
            % outputs:
            %   nor (string) - a string representation of the object
            
            nor = object2str(obj);
            for i = 1:numel(obj.ProcessingFunctions)
                nor = [nor newline object2str(obj.ProcessingFunctions{i})];
            end
        end
        
        function copied_object = deep_copy(obj)
            % returns a deep copy of the Pipeline object.
            %
            % inputs: none
            %   
            % outputs:
            %   copied_object (Pipeline) - a deep copy of the Pipeline
            %       object
            
            copied_object = obj.copy();
            for i = 1:numel(obj.ProcessingFunctions)
                copied_object.ProcessingFunctions{i} = ...
                    obj.ProcessingFunctions{i}.copy();
            end
        end        
    end    
end