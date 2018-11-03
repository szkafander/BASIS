classdef Frame < matlab.mixin.Copyable   
    % stores information related to Frames including paths and timing.
    % note: you should never have to manually call any of this class'
    % methods. Frame is a subclass of matlab.mixin.Copyable, i.e., it
    % behaves as a handle class.
    
    properties
        % path to image
        Path = 'not specified'        
        % misc info, resolution, etc.
        Description = [];
    end
    
    properties (SetAccess=immutable)
        % frame time
        Time = NaN
        % frame index
        Index = NaN
    end
    
    properties (SetAccess=protected)
        % is frame loaded?
        IsLoaded = false;
        % attached data
        Data = [];
    end   
    
    methods              
        function obj = Frame(varargin)
            % constructor
            %
            % usage:
            %   frame = Frame() - empty Frame object, fields must be filled
            %       in manually
            %   frame = Frame(path) - Frame constructed from a path to an
            %       image
            %   frame = Frame(_, name-value pairs) - additional name-value
            %       pairs can be passed
            %
            % name-value pairs:
            %   time (numeric, nonnegative scalar) - the Frame time
            %   index (integer-valued scalar) - the Frame's linear index
            %   data (struct) - a struct to attach to the object. by
            %       default, it has to fields: output and function.
            
            p = inputParser;
            addOptional(p, 'path', 'not specified', ...
                @(x)ischar(x)||isempty(x));
            addParameter(p, 'time', NaN, ...
                @(x)validateattributes(x, ...
                {'numeric'}, {'nonnegative', 'scalar'}));
            addParameter(p, 'index', NaN, ...
                @(x)validateattributes(x, ...
                {'numeric'}, {'nonnegative', 'scalar'}));
            addParameter(p, 'data', ...
                struct('output', {}, 'function', {}), ...
                @isstruct);
            parse(p, varargin{:});
            
            % avoid conflicts with builtins
            path_ = p.Results.path;
            index_ = p.Results.index;
            time_ = p.Results.time;
            data_ = p.Results.data;
            
            obj.Index = index_;
            obj.Time = time_;
            obj.Data = data_;
            obj.Path = path_;            
        end 
        
        function obj = load(obj, varargin)
            % loads image on path if not already loaded and sets the Data
            % property.
            %
            % inputs:
            %   reset (logical) - name-value pair, if true, resets the Data
            %       property before loading
            %
            % outputs: none (modifies caller object)
            
            p = inputParser;
            addParameter(p, 'reset', false, @islogical);
            parse(p, varargin{:});
            reset_ = p.Results.reset;
            
            if reset_
                obj.reset();
            end
            
            if ~obj.IsLoaded
                obj.Data(1).output = imread(obj.Path);
                obj.Data(1).function = {'Frame.load', ...
                    obj.Path};
                obj.validate_image(obj.Data(1).output);
                obj.IsLoaded = true;
            end
        end      
        
        function obj = reset(obj)
            % resets Frame Data
            %
            % inputs: none
            %
            % outputs: none (modifies caller object)
            
            obj.Data = struct('output', {}, 'function', {});
            obj.IsLoaded = false;
        end
        
        function show(obj)
            % shows the image data in the Data property
            %
            % inputs: none
            %
            % outputs: none (void, displays image)
            
            if obj.IsLoaded
                figure;
                imagesc(obj.Data(1).output);
                axis image;
                string_index = '??';
                string_time = '??';
                if ~isnan(obj.Index)
                    string_index = num2str(obj.Index);
                end
                if ~isnan(obj.Time)
                    string_time = num2str(obj.Time);
                end
                title(['frame ' string_index ' at time ' string_time]);
            end
        end
    end    
    
    methods(Static)
        function validate_image(image_input)
            if isimg(image_input)
                size_image = size(image_input);
                if numel(size_image) == 3
                    if size_image(3) > 3
                        warning([' - image appears to have more than ' ...
                            '3 color channels. this is unusual.']);
                    end
                end
            elseif ~isempty(image_input)
                error('not an image.');
            end
        end
    end
end