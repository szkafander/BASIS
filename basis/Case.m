classdef Case < matlab.mixin.Copyable
    % class that stores information about image sets, or in other words,
    % cases. the main purpose of this class is to store information
    % regarding the event-frame structure, frame timing and frame paths.
    %
    % the event-frame structure is a model for batch image data. it is
    % assumed that images are acquired in n-tuples (if n=2, pairs, if n=3, 
    % triplets, etc.). an n-tuple is called an Event. an image in an
    % n-tuple is called a Frame. there are FramesPerEvent frames in an 
    % n-tuple. furthermore, an image set has a ReadMode that can be either 
    % 'stepping' or 'rolling'. a stepping mode means that images are read 
    % Event-wise and a rolling mode means that the images are read 
    % Frame-wise. a few examples:
    %   if ReadMode is stepping and FramesPerEvent is 3, images are read in
    %       this order:
    %       Event 1: image 1, image 2, image 3
    %       Event 2: image 4, image 5, image 6 ...
    %   if ReadMode is rolling and FramesPerEvent is 3, images are read in
    %       the following order:
    %       Event 1: image 1, image 2, image 3
    %       Event 2: image 2, image 3, image 4 ...
    %   if ReadMode is rolling and FramesPerEvent is 1:
    %       Event 1: image 1
    %       Event 2: image 2 ...
    %   if ReadMode is stepping and FramesPerEvent is 1:
    %       Event 1: image 1
    %       Event 2: image 2 ...
    %
    % frame timing is a model for frame timing. it is assumed that the
    % Events and Frames are taken in regular intervals. the intervals can
    % differ for Events and Frames. in almost all cases, the interval is
    % longer between Events than Frames. in fact, it is usually so that the
    % interval between Events is longer than FramesPerEvents * interval
    % between frames. the interval between Events is called DeltaTEvent.
    % the interval between Frames is called DeltaTFrame. there is an
    % optional StartTime and FrameOffset attribute. examples:
    %   if DeltaTEvent = 10, DeltaTFrame = 2, FramesPerEvent = 2,
    %   FrameOffset = 1, StartTime = 5:
    %       Event 1:    Frame 1 (t = StartTime + FrameOffset = 6)
    %                   Frame 2 (t = StartTime + FrameOffset + DeltaTFrame
    %                   = 8)
    %       Event 2:    Frame 1 (t = StartTime + DeltaTEvent + FrameOffset
    %                   = 16)
    %                   Frame 2 (t = StartTime + DeltaTEvent + FrameOffset
    %                   + DeltaTFrame = 18) ...
    
    properties
        % tha path that contains the image set
        Path
        % a cell of the stored Events
        Events
        % any string description to attach to the object
        Description
        % the path to the metadata file
        Metadata
        % readmode, can be 'stepping' and 'rolling'
        ReadMode
        % how many frames an event has
        FramesPerEvent
        % the time between events
        DeltaTEvent = NaN
        % the time between frames within an event
        DeltaTFrame = NaN
        % the start time of the image set
        StartTime = NaN
        % the offset time of the first frame in an event
        FrameOffset = NaN
    end
    
    properties (Dependent = true)
        % dependent, logical, true if the case has been read
        IsRead
        % the number of events read
        NumEvents
    end
    
    methods        
        function obj = Case(varargin)
            % constructor
            %
            % usage:
            %   case_ = Case() - empty case, fields must be filled out
            %       manually
            %   case_ = Case(path) - the default construction protocol is
            %       invoked:
            %       1. the existence of the folder specified by path is
            %           checked
            %       2. the folder is scanned for files
            %       3. if a file called metadata with any extension is
            %           found, it is loaded. the metadata file can contain
            %           any of Case's name-value pairs. if a file is found,
            %           the appropriate properties are set according to it.
            %       4. if a metadata file is not found, the filenames of
            %           the image files in the folder are scanned for
            %           possible clues regarding the event-frame structure
            %           and timing.
            %   case_ = Case(path, name-value pairs) - optional name-value
            %       pairs always override both the metadata file and the
            %       inferred event-frame structure and timing from
            %       filenames
            % 
            % name-value pairs:
            %   framesperevent (integer-valued scalar) - the number of
            %       Frames per Event
            %   readmode (string) - accepted values are: 'stepping' and
            %       'rolling'
            %   deltatevent, deltatframe, frameoffset, starttime (numeric,
            %       positive scalar) - the frame timing parameters
            %   events (cell of Events) - a cell of Events can be passed
            %   metadata (string) - path to metadata file. if passed, this
            %       path will be used. if not passed, the case folder will 
            %       be used. if passed, it can alter the default 'metadata'
            %       filename.
            %   template (Case) - an already set-up Case. if passed, new
            %       case will be a copy of this.            
            
            p = inputParser;
            % path to case folder
            % use obj.is_valid to validate instead
            addOptional(p, 'path', 'not specified', ...
                @(x)(isspecified(x)&&ischar(x))||isempty(x));
            % optional template Case instance
            % constructor will copy all properties from this and proceed
            % with protocol
            addParameter(p, 'template', 'not specified', ...
                @(x)isa(x, 'Case'));
            % readmode as string
            addParameter(p, 'readmode', 'not specified', @ischar);
            % framesperevent
            addParameter(p, 'framesperevent', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'integer', 'nonnegative'}));
            % deltatevent
            addParameter(p, 'deltatevent', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'nonnegative'}));
            % deltatframe
            addParameter(p, 'deltatframe', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'nonnegative'}));
            addParameter(p, 'frameoffset', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'nonnegative'}));
            % starttime
            addParameter(p, 'starttime', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'nonnegative'}));
            % path to metadata file
            addParameter(p, 'metadata', 'not specified', @ischar);
            % description
            addParameter(p, 'description', 'not specified', @ischar);
            % events cell
            addParameter(p, 'events', {}, @iscell);
            parse(p, varargin{:});
            
            % if template passed, copy
            if isa(p.Results.template, 'Case')
                obj = p.Results.template.copy();
            end

            % guess event structure from filenames
            obj.Path = p.Results.path;
            obj.guess_event_structure_from_filenames();

            % search for metadata
            obj.Metadata = p.Results.metadata;
            md_file = obj.search_for_metadata();
            % read if found
            if isspecified(md_file)
                metadata = obj.read_metadata(md_file);
                % update case
                obj.update_based_on_metadata(metadata, 'overwrite', true);
            end
            
            % set params if passed param is valid
            props = properties(obj);
            props_lowercase = cellfun(@lower, props, ...
                'UniformOutput', false);
            fields = fieldnames(p.Results);
            for i = 1:numel(fields)
                inds = ismember(props_lowercase, fields{i});
                if sum(inds) == 1
                    prop_current = props{inds};
                    if obj.is_valid(prop_current, p.Results.(fields{i}))
                        obj.(prop_current) = p.Results.(fields{i});
                    end
                end
            end
            
            % revert to default 0 for timing if invalid
            if isnan(obj.DeltaTFrame)
                obj.DeltaTFrame = 0;
            end
            if isnan(obj.DeltaTEvent)
                obj.DeltaTEvent = 0;
            end
            if isnan(obj.StartTime)
                obj.StartTime = 0;
            end
            if isnan(obj.FrameOffset)
                obj.FrameOffset = 0;
            end
        end
        
        function is_read = get.IsRead(obj)
            is_read = ~isempty(obj.Events);
        end
        
        function num_events = get.NumEvents(obj)
            num_events = numel(obj.Events);
        end
        
        function obj = read(obj, varargin)
            % invokes the default read protocol. read fills up the Events 
            % cell, but does not alter Case properties. however, additional
            % name-value pairs identical to those of the constructor can be
            % passed and these will parametrize read accordingly.
            %
            % inputs:
            %   name-value pairs of the constructor - all of them are
            %       accepted. if any are passed, they will override the
            %       object properties for reading, but will not alter the
            %       object itself.
            %
            % outputs: none (modifies the caller object)
            
            p = inputParser;
            addParameter(p, 'path', 'not specified', ...
                @(x)validateattributes(x, {'char'}, {'nonempty'}));
            addParameter(p, 'readmode', 'not specified', @ischar);
            addParameter(p, 'framesperevent', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'integer', 'nonnegative'}));
            addParameter(p, 'deltatevent', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'nonnegative'}));
            addParameter(p, 'deltatframe', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'nonnegative'}));
            addParameter(p, 'frameoffset', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'nonnegative'}));
            addParameter(p, 'starttime', NaN, ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'nonnegative'}));
            parse(p, varargin{:});
            
            path_ = p.Results.path;
            readmode = p.Results.readmode;
            framesperevent = p.Results.framesperevent;
            deltatevent = p.Results.deltatevent;
            deltatframe = p.Results.deltatframe;
            starttime = p.Results.starttime;
            frameoffset = p.Results.frameoffset;
            
            if ~isspecified(path_)
                path_ = obj.Path;
            end
            if ~obj.isvalidreadmode(readmode)
                readmode = obj.ReadMode;
            end
            if ~obj.isvalidframesperevent(framesperevent)
                framesperevent = obj.FramesPerEvent;
            end
            if isnan(deltatevent)
                deltatevent = obj.DeltaTEvent;
            end
            if isnan(deltatframe)
                deltatframe = obj.DeltaTFrame;
            end
            if isnan(starttime)
                starttime = obj.StartTime;
            end
            if isnan(frameoffset)
                frameoffset = obj.FrameOffset;
            end
            
            cnt_event_linear = 0;
            cnt_frame_linear = 0;
            
            filenames_images = getfiles(path_, 'images_only', true);
            
            switch readmode
                case 'stepping'
                    events = cell(floor(numel(filenames_images) / ...
                        framesperevent), 1);
                    for cnt_event = ...
                            1:framesperevent: ...
                            numel(filenames_images)
                        frames_current = cell(framesperevent, 1);
                        cnt_event_linear = cnt_event_linear + 1;
                        event_time = starttime + ...
                            (cnt_event_linear - 1) * deltatevent;
                        for cnt_frame = 1:framesperevent
                            cnt_frame_linear = cnt_frame_linear + 1;
                            frame_time = (cnt_frame-1) * deltatframe;
                            frames_current{cnt_frame} = Frame([path_ ...
                                filenames_images{cnt_event+(cnt_frame-1)}], ...
                                'index', cnt_frame, ...
                                'time', event_time + frame_time ...
                                + frameoffset);
                        end
                        events{cnt_event_linear} = Event(frames_current, ...
                            'time', event_time, ...
                            'index', cnt_event_linear);
                    end
                    obj.Events = events;
                case 'rolling'
                    events = cell(floor(numel(filenames_images) - ...
                        framesperevent + 1), 1);
                    for cnt_event = ...
                            1:(numel(filenames_images) - ...
                            framesperevent + 1)
                        frames_current = cell(framesperevent, 1);
                        cnt_event_linear = cnt_event_linear + 1;
                        % in rolling mode, deltatframe = deltatevent
                        event_time = starttime + ...
                            (cnt_event_linear - 1) * deltatframe;
                        for cnt_frame = 1:framesperevent
                            cnt_frame_linear = cnt_frame_linear + 1;
                            frame_time = (cnt_frame-1) * deltatframe;
                            frames_current{cnt_frame} = Frame([path_ ...
                                filenames_images{ ...
                                cnt_event + (cnt_frame-1)}], ...
                                'index', cnt_frame, ...
                                'time', event_time + frame_time ...
                                + frameoffset);
                        end
                        events{cnt_event} = Event(frames_current, ...
                            'time', event_time, ...
                            'index', cnt_event_linear);
                    end
                    obj.Events = events;
            end
        end
        
        function md_file = search_for_metadata(obj)
            % searches for the metadata file on the case folder.
            %
            % inputs: none
            %
            % outputs:
            %   md_file (string) - folder to the metadata file.
            
            md_file = dir(obj.Metadata);
            if numel(md_file) == 1
                md_file = obj.Metadata;
            else
                % assume metadata is given as path\metadata
                possible_folder = obj.Metadata;
                md_file = dir([obj.Metadata '*']);
                possible_folder = strsplit(possible_folder, filesep);
                if numel(md_file) == 1
                    md_file = [strjoin(possible_folder{1:end-1}, ...
                        filesep) filesep md_file(1).name];
                else
                    % assume metadata is given as path
                    md_file = dir([obj.Metadata filesep 'metadata*']);
                    if numel(md_file) == 1
                        md_file = [formatpath(obj.Metadata) ...
                            md_file(1).name];
                    else
                        % look for any metadata file on obj.Path
                        md_file = dir([obj.Path filesep 'metadata*']);
                        if numel(md_file) == 1
                            md_file = [obj.Path md_file(1).name];
                        else
                            % metadata not found
                            md_file = 'not specified';
                            warning('metadata not found.');
                        end
                    end
                end
            end
        end
        
        function metadata = read_metadata(obj, md_file)
            % reads the metadata from a file
            %
            % inputs:
            %   md_file (string) - path to the metadata file
            %
            % outputs:
            %   metadata (struct) - a struct representation of the metadata
            
            if ~isempty(md_file)
                obj.Metadata = md_file;
                file_id = fopen(md_file);
                metadata = textscan(file_id, '%s%s');
                fclose(file_id);
                names = metadata{1};
                vals = metadata{2};
                vals = cellfun(@(x)obj.converttoscalarifpossible(x), ...
                    vals, 'UniformOutput', false);
                metadata = cell2struct(vals, names);
            end            
        end
        
        function obj = update_based_on_metadata(obj, metadata, varargin)
            % updates the Case object based on the metadata struct.
            %
            % inputs:
            %   metadata (struct) - the metadata as a struct, read by
            %       read_metadata
            %   overwrite (logical) - name-value pair that specifies
            %       whether to overwrite already set object properties. the
            %       default is false.
            
            p = inputParser;
            addRequired(p, 'metadata', @isstruct);
            addParameter(p, 'overwrite', false, @islogical);
            parse(p, metadata, varargin{:});
            
            metadata = p.Results.metadata;
            overwrite = p.Results.overwrite;
            
            props = properties(obj);
            props_lowercase = cellfun(@lower, props, ...
                'UniformOutput', false);
            fields = cellfun(@lower, fieldnames(metadata), ...
                'UniformOutput', false);
            
            for i = 1:numel(fields)
                inds = ismember(props_lowercase, fields{i});
                
                if sum(inds) == 1
                    if overwrite
                        if obj.is_valid(props{inds}, ...
                                getfieldi(metadata, fields{i}))
                            obj.(props{inds}) = getfieldi(metadata, ...
                                fields{i});
                        end
                    else
                        if ~obj.is_valid(props{inds}, obj.(props{inds})) ...
                                && obj.is_valid( ...
                                getfieldi(metadata, fields{i}))
                            obj.(props{inds}) =  ...
                                getfieldi(metadata, fields{i});
                        end
                    end
                end
            end
        end
        
        function is_valid_property = is_valid(obj, prop_name, prop_value)
            % helper method to check property validity. this method should
            % probably not be used manually, but it is provided in any
            % case.
            %
            % inputs:
            %   prop_name (string) - the name the property
            %   prop_value - the value of the property
            %
            % outputs:
            %   is_valid_property (logical) - true if the property has a
            %       valid value
            
            prop_name = lower(prop_name);
            switch prop_name
                case 'path'
                    is_valid_property = obj.isvalidpath(prop_value);
                case 'framesperevent'
                    is_valid_property = obj.isvalidframesperevent( ...
                        prop_value);
                case 'readmode'
                    is_valid_property = obj.isvalidreadmode(prop_value);
                case {'deltatevent', 'deltatframe'}
                    is_valid_property = obj.isvaliddeltat(prop_value);
                case {'starttime', 'frameoffset'}
                    is_valid_property = obj.isvalidtime(prop_value);
                case 'name'
                    is_valid_property = obj.isvalidname(prop_value);
                otherwise
                    is_valid_property = false;
            end
        end
        
        function guess_event_structure_from_filenames(obj)
            % infers event-frame structure and frame timing from filenames.
            % a number of filename formats are supported:
            %
            %   frameindex - a single frame index is provided
            %   eventindex_frameindex - event indices and frame indices are
            %       provided, delimited by a delimiter
            %   eventindex_eventtime_frameindex_frametime - event indices,
            %   event times, frame indices, frame times are provided,
            %   delimited by a delimiter
            %   case_frameindex - only a case name and frame indices are
            %       provided, delimited by a delimiter character
            %   case_eventindex_frameindex - a case name, frame indices and
            %       event indices are provided, delimited by a delimiter
            %   case_eventindex_eventtime_frameindex_frametime - a case
            %       name, event indices, event times, frame indices and
            %       frame times are provided, delimited by a delimiter.
            %
            % delimiters are inferred from filenames. valid delimiters are:
            %   '_', ' ', ',', ';', '-', '=', '%', '&'
            %
            % guess_event_structure_from_filenames returns a matched event
            % structure, if all filenames follow the convention in the case
            % folder.
            %
            % inputs: none
            % 
            % outputs: none (modifies caller object)
            
            filenames_images = getfiles(obj.Path, 'images_only', true);
            
            consistent_eventindices = false;
            consistent_eventtimes = false;
            consistent_frameindices = false;
            consistent_frametimes = false;
            
            if ~isempty(filenames_images)
                % check if all fit some pattern
                pattern_cell = cellfun(@(x)matchfilenamepattern(x), ...
                    filenames_images, 'UniformOutput', false);
                
                % check if all fit the same pattern
                are_all_valid_pattern = ...
                    all(cellfun(@(x)strcmp(x, pattern_cell{1}), ...
                    pattern_cell));
                
                if are_all_valid_pattern
                    % collect all patterns
                    filename_params = cellfun( ...
                        @(x)obj.vectorizedissectedpars(x), ...
                        filenames_images, 'UniformOutput', false);
                    
                    % collect patterns as matrices
                    eventindices = cellfun(@(x)x{1}, filename_params);
                    eventtimes = cellfun(@(x)x{2}, filename_params);
                    frameindices = cellfun(@(x)x{3}, filename_params);
                    frametimes = cellfun(@(x)x{4}, filename_params);
                    
                    if all(~isnan(eventindices))
                        consistent_eventindices = true;
                    end
                    
                    if all(~isnan(eventtimes))
                        consistent_eventtimes = true;
                    end
                    
                    if all(~isnan(frameindices))
                        consistent_frameindices = true;
                    end
                    
                    if all(~isnan(frametimes))
                        consistent_frametimes = true;
                    end
                end
                                
                % check logical consistency
                if ~consistent_eventindices && consistent_frameindices
                    % no event indices, only frame indices
                    % in this case, framesperevent = 1 and readmode is
                    % rolling (does not matter)
                    obj.FramesPerEvent = 1;
                    obj.ReadMode = 'rolling';                    
                elseif consistent_eventindices && ...
                        consistent_frameindices
                    % we have event and frame indices as well
                    % both have to be valid
                    % the counts for unique eventindices must be equal
                    % the counts for unique frameindices must be equal
                    % plus they must be equal to each other
                    [~, ~, counts_unique_events] = ...
                        unique(eventindices);
                    [~, ~, counts_unique_frames] = ...
                        unique(frameindices);
                    counts_unique_events = ...
                        accumarray(counts_unique_events, 1);
                    counts_unique_frames = ...
                        accumarray(counts_unique_frames, 1);
                    
                    if numel(counts_unique_events) > 0 && ...
                            numel(counts_unique_frames) > 0
                        if all(counts_unique_frames == ...
                                counts_unique_frames(1)) && ...
                                obj.isvalidframesperevent( ...
                                counts_unique_frames(1)) && ...
                                all(counts_unique_events == ...
                                counts_unique_events(1))
                            
                            obj.FramesPerEvent = ...
                                counts_unique_events(1);
                            
                            % this has been equivalent to a stepping
                            % readmode
                            obj.ReadMode = 'stepping';
                        else
                            % if logical consistency is not met, Case
                            % can still follow pattern, but this is
                            % error prone (warn)
                            obj.FramesPerEvent = 'pattern';
                            obj.ReadMode = 'pattern';
                            warning(['Event and frame indices are ' ...
                                'logically inconsistent. Proceed ' ...
                                'with caution. Re-instantiation ' ...
                                'with proper parametrization ' ...
                                'is advised.']);
                        end
                    end
                end
                
                % try to figure out event timing here
                if numel(filenames_images) > 1
                    if consistent_frametimes
                        if obj.isvalidframesperevent( ...
                                obj.FramesPerEvent)
                            deltat = diff(frametimes( ...
                                1:obj.FramesPerEvent));
                            first_frametimes = frametimes( ...
                                1:obj.FramesPerEvent:end);
                            if all(first_frametimes == first_frametimes(1))
                                obj.FrameOffset = first_frametimes(1);
                            end
                            if all(deltat == deltat(1))
                                if obj.isvaliddeltat(deltat(1))
                                    obj.DeltaTFrame = deltat(1);
                                    warning(['DeltaTFrame set from ' ...
                                        'filename patterns.']);
                                end
                            end
                        end
                    end
                    if consistent_eventtimes
                        if obj.isvalidframesperevent( ...
                                obj.FramesPerEvent)
                            deltat = diff(eventtimes( ...
                                1:obj.FramesPerEvent:end));
                            if all(deltat == deltat(1))
                                if obj.isvaliddeltat(deltat(1))
                                    obj.DeltaTEvent = deltat(1);
                                    warning(['DeltaTEvent set from ' ...
                                        'filename patterns.']);
                                    obj.StartTime = eventtimes(1);
                                end
                            end
                        end
                    end
                end
            end
        end
        
        function obj = set.Path(obj, path_)
            % setter for Path property. does string formatting.
            %
            % inputs:
            %   path_ (string) - the path to the case folder
            %
            % outputs: none (modifies the caller object)
            
            if ischar(path_)
                path_ = formatpath(path_);
            end
            obj.Path = path_;
        end        
    end
    
    methods (Access=private)        
        function pars = vectorizedissectedpars(obj, filename_input)
            [a, b, c, d] = dissectfilename(filename_input);
            pars = {a b c d};
        end
        
        function scalar = converttoscalarifpossible(obj, input_)
            val = str2double(input_);
            if ~isnan(val)
                scalar = val;
            else
                scalar = input_;
            end
        end
        
        function is_valid_path = isvalidpath(obj, path_)
            is_valid_path = ischar(path_) && ~isempty(path_) && ...
                size(path_, 1) == 1;
        end
        
        function is_valid_framesperevent = ...
                isvalidframesperevent(obj, framesperevent)
            is_valid_framesperevent = isscalar(framesperevent) && ...
                rem(framesperevent, framesperevent) == 0 && ...
                ~isempty(framesperevent) && all(framesperevent) > 0;
        end
        
        function is_valid_readmode = isvalidreadmode(obj, readmode)
            is_valid_readmode = ~isempty(readmode) && ischar(readmode) ...
                && size(readmode, 1) == 1 && ...
                (strcmpi(readmode, 'stepping') || ...
                strcmpi(readmode, 'rolling'));
        end
        
        function is_valid_deltat = isvaliddeltat(obj, deltat)
            is_valid_deltat = ~isempty(deltat) && isscalar(deltat) && ...
                all(deltat >= 0);
        end
        
        function is_valid_time = isvalidtime(obj, timeval)
            is_valid_time = ~isempty(timeval) && isscalar(timeval) && ...
                all(timeval >= 0);
        end
        
        function is_valid_name = isvalidname(obj, name)
            is_valid_name = ischar(name);
        end        
    end    
end