classdef Event < matlab.mixin.Copyable
    % stores Event-related information, including paths, timing, frames,
    % etc. this is a wrapper to encapsulate Frame objects. apart from
    % storing Cases, the user should not have to manually call this. Even
    % is a subclass of matlab.mixin.Copyable, i.e., it behaves as a handle
    % class.
    
    properties
        % this can store a loaded image
        Data
        % a cell of Frame objects
        Frames
        % the Event time (see Case for the Event-Frame structure)
        Time
        % the Event's linear index
        Index
    end
    
    methods
        function obj = Event(varargin)
            % constructor
            %
            % usage:
            %   event = Event() - empty Event object, fields must be
            %       manually filled out
            %   event = Event(path) - creates an Event with a single Frame
            %       defined by a path to the Frame
            %   event = Event(frame) - creates an Event with a single Frame
            %       defined by a Frame object
            %   event = Event(event) - creates an Event object that is a
            %       deep copy of another Event object, event
            %   event = Event(cell) - creates an Event object with a number
            %       of Frames defined in the passed cell. the cell can
            %       contain Frame objects of paths.
            
            % empty event
            p = inputParser;
            addOptional(p, 'frames', [], ...
                @(x)iscell(x)||ischar(x)||isframe(x)||isa(x, 'Event'));
            addParameter(p, 'time', NaN, ...
                @(x)validateattributes(x, ...
                {'numeric'}, {'nonnegative', 'scalar'}));
            addParameter(p, 'index', NaN, ...
                @(x)validateattributes(x, ...
                {'numeric'}, {'nonnegative', 'scalar'}));
            parse(p, varargin{:});
            
            % avoid conflicts with builtins
            frames = p.Results.frames;
            index_ = p.Results.index;
            time_ = p.Results.time;
            
            obj.Frames = frames;
            obj.Index = index_;
            obj.Time = time_;
            
            if isframe(frames)
                % construct from single frame
                obj.Frames = {frames};
            elseif ischar(frames)
                % construct from single filename
                obj.Frames = {Frame(frames)};
            end
            
            % construct from cell array
            [is_frames, is_empty] = isframes(frames);
            if is_frames
                if is_empty
                    obj.Frames = {};
                else
                    obj.Frames = frames;
                end
            elseif iscellstr(frames)
                if is_empty
                    obj.Frames = {};
                else
                    num_frames = numel(frames);
                    frames_ = cell(num_frames, 1);
                    for i = 1:num_frames
                        frames_{i} = Frame(frames{i});
                    end
                    obj.Frames = frames_;
                end
            end
            
            % construct from Event object
            if isa(frames, 'Event')
                obj = frames.deep_copy();
            end
        end
        
        function obj = load_frames(obj, varargin)
            % loads frames and places image data in the Data property.
            % 
            % inputs:
            %   indices_frame (optional, logical or integer-valued vector) 
            %       - is an array for logical indexing or an array with 
            %       numeric indices. by default, load_frames loads all
            %       frames.
            %
            % outputs: none (modifies caller object)
            
            p = inputParser;
            addOptional(p, 'indices_frame', [], @(x)validateattributes( ...
                x, {'numeric'}, {'vector'}));
            parse(p, varargin{:});
            indices_frame = p.Results.indices_frame;
            
            if isempty(indices_frame)
                indices_frame = true(size(obj.Frames));
            else
                if islogical2(indices_frames)
                    if numel(indices_frames) ~= numel(obj.Frames)
                        error(['number of indices must be equal to ' ...
                            'number of Frame objects in Frames.']);
                    end
                else
                    if ~(all(round(indices_frame) == indices_frame))
                        error('indices must be integer-valued.');
                    elseif ~all(indices_frame > 0)
                        error('indices are base 1.');
                    end
                end
            end
            
            if ~(all(arrayfun(@islogical, indices_frame)) || ...
                    all(arrayfun(@(x)floor(x)==x, indices_frame)))
                error(['invalid frame indices passed. ' ...
                    'indices_frame must be a logical vector or a ' ...
                    'vector of integer-valued numerics.']);
            end
            if ~isempty(obj.Frames)
                for i = 1:numel(obj.Frames)
                    if indices_frame(i)
                        obj.Frames{i}.load();
                    end
                end
            end
        end
        
        function obj = update(obj, data_)
            % updates Event Data based on passed data_
            %
            % inputs:
            %   data_ (cell or Event) - the data based on which the Data
            %       property is updated
            %
            % outputs: none (modifies caller object)
            
            p = inputParser;
            addRequired(p, 'data', @(x)iscell(x)||isa(x, 'Event'));
            parse(p, data_);
            data_ = p.Results.data;
            
            % avoid loading the same image twice
            if isa(data_, 'Event')
                obj.update_data_based_on_event(data_);
            elseif iscell(data_) && ~isempty(data_)
                if all(cellfun(@(x)isa(x, 'Frame'), data_))
                    obj.update_data_based_on_frames(data_);
                else
                    obj.update_data_based_on_arbitrary(data_);
                end
            else
                obj.update_data_based_on_arbitrary(data_);
            end
        end
        
        function paths = get_paths(obj)
            paths = cell(numel(obj.Frames), 1);
            for i = 1:numel(obj.Frames)
                paths{i} = obj.Frames{i}.Path;
            end
        end
        
        function obj_copy = deep_copy(obj)
            % deep copies Event object, copies all stored Frame objects.
            %
            % inputs: none
            %
            % outputs:
            %   obj_copy (Event) - the deep copy of the caller object
            
            obj_copy = obj.copy();
            if ~isempty(obj_copy.Frames)
                for i = 1:numel(obj_copy.Frames)
                    obj_copy.Frames{i} = obj.Frames{i}.copy();
                end
            end
        end
    end
    
    methods (Access=private)
        function obj = set_to(obj, event)
            obj.Time = event.Time;
            obj.Index = event.Index;
            obj.Data = event.Data;
            if ~isempty(event.Frames)
                for i = 1:numel(event.Frames)
                    obj.Frames{i} = event.Frames{i}.copy();
                end
            end
        end
        
        function obj = update_data_based_on_event(obj, event)
            if ~isa(event, 'Event')
                error('input is not an Event object.');
            end
            
            if ~isempty(obj.Frames)
                if iscell(obj.Frames)
                    if numel(event.Frames) ~= numel(obj.Frames)
                        error(['number of frames in passed Event ' ...
                            'object must be the same as number of ' ...
                            'frames stored.']);
                    else
                        if all(cellfun(@isempty, obj.Frames))
                            % Frames are empty, initialize with passed
                            % Event object
                            obj = event.deep_copy();
                            obj.load_frames();
                        else
                            % Frames not empty, only load what's necessary
                            buffer = obj.deep_copy();
                            buffer.get_paths()
                            for cnt_frame = 1:numel(event.Frames)
                                path_current = ...
                                    event.Frames{cnt_frame}.Path;
                                paths_old = obj.get_paths();
                                ind_in_buffer = ismember(paths_old, ...
                                    path_current);
                                if sum(ind_in_buffer) > 0
                                    ind_in_old = find(ind_in_buffer);
                                    ind_in_old = ind_in_old(1);
                                    buffer.Frames{cnt_frame} = ...
                                        obj.Frames{ind_in_old}.copy();
                                else
                                    buffer.Frames{cnt_frame} = ...
                                        event.Frames{cnt_frame}.copy();
                                end
                            end
                            
                            % load if not loaded
                            buffer.load_frames();
                            % can't set obj = to buffer.deep_copy()
                            obj.set_to(buffer.deep_copy());
                        end
                    end
                end
            else
                % fresh event
                buffer = event.deep_copy();
                buffer.load_frames();
                obj.set_to(buffer);
            end
        end
        
        function obj = update_data_based_on_frames(obj, frames)
            if ~(iscell(frames) && ...
                    all(cellfun(@(x)isa(x, 'Frame'), frames)))
                error('input is not a cell of Frame objects.');
            end
            
            if numel(frames) ~= obj.SIZE
                error(['number of frames in passed cell of frames ' ...
                    'must be equal to InternalBuffer.SIZE.']);
            end
            
            is_element_empty = cellfun(@isempty, obj.Data);
            if all(is_element_empty)
                obj.Data = obj.copy_cell_of_frames(frames);
                obj.load_frames();
            elseif any(is_element_empty)
                warning(['corrupted InternalBuffer.Data field. '...
                    'field is a cell, but some values are empty.']);
            else
                buffer = obj.copy_cell_of_frames(obj.Data);
                for cnt_frame = 1:numel(frames)
                    path_current = frames{cnt_frame}.Path;
                    paths_old = obj.get_paths();
                    ind_in_buffer = ismember(paths_old, ...
                        path_current);
                    if sum(ind_in_buffer) > 0
                        ind_in_old = find(ind_in_buffer);
                        ind_in_old = ind_in_old(1);
                        buffer{cnt_frame} = ...
                            obj.Data{ind_in_old}.copy();
                    else
                        buffer{cnt_frame} = ...
                            frames{cnt_frame}.copy();
                    end
                    % load if not loaded
                    buffer{cnt_frame}.load();
                end
                obj.Data = obj.copy_cell_of_frames(buffer);
            end
        end
        
        function obj = update_based_on_arbitrary(obj, data_)
            % this is tricky and not recommended. if arbitrary data is
            % passed to InternalBuffer, user has to adapt this function.
            % as it is, it checks for handles and tries to copy them. if
            % data_ is a value class, it just sets InternalBuffer.Data
            % equal to data_.
            if isa(data_, 'matlab.mixin.Copyable')
                % try to copy
                obj.Data = data_.copy();
            else
                if ~isa(data_, 'handle')
                    obj.Data = data_;
                else
                    warning(['arbitrary handle class instance passed '...
                        'as input to InternalBuffer. InternalData.Data '...
                        'will be set equal to this passed handle. this '...
                        'might lead to unexpected behavior.']);
                end
            end
        end
        
        function cell_of_frames = copy_cell_of_frames(obj, ...
                cell_of_frames_input)
            num_frames = numel(cell_of_frames_input);
            cell_of_frames = cell(num_frames, 1);
            for i = 1:num_frames
                cell_of_frames{i} = cell_of_frames_input{i}.copy();
            end
        end
    end
end