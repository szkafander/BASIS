classdef Driver < handle
    % class that drives a Graph by feeding input images and running it in a
    % loop. also handles group cloning. feeds input images to special frame
    % Nodes. frame Nodes are identified by their labels: they must follow
    % the format frame_<index>, where the index is an integer. the integers
    % must not be regular, but most be unique. inputs are fed to frame
    % Nodes in the ascending order of frame Node indices.
    
    properties
        % the indices of the frame nodes
        FrameNodeIDs
    end
    
    properties (SetObservable = true)
        % the underlying Graph to run
        Graph
        % the underlying Case to feed images from
        Case
        % the behavior of the Driver specified as a struct
        Behavior
    end
    
    properties (Hidden = true)
        % a mapping of Graph Groups to clone between
        TargetGroups
        % listener to changes to the underlying Graph
        Listener_Graph
        % listener to changes to the underlying Case
        Listener_Case
    end
    
    methods        
        function obj = Driver(varargin)
            % constructor
            %
            % usage:
            %   driver = Driver() - empty Driver, fields must be manually
            %       filled in
            %   driver = Driver(case) - Driver based on a Case specified by
            %       a Case, with an empty Graph that must be specified
            %       manually
            %   driver = Driver(case, graph) - Driver based on a Case and a
            %       Graph, both must be the appropriate objects
            %   driver = Driver(_, name-value pairs) - additional
            %       name-value pairs can be passed
            %
            % name-value pairs:
            %   behavior (cell) - the Driver behavior specified by a cell
            %       of name-value pairs. the Behavior attributes are the
            %       following:
            %           mode (string) - can be 'sequential' or 'random'.
            %               sequential reads images in successive order,
            %               while random reads them randomly.
            %           start_index (integer-valued scalar) - the index of
            %               the Event to start at. only effective with the
            %               sequential mode
            %           number_of_frames (integer-valued scalar) - the
            %               number of frames to load in total
            %           skip (integer-valued scalar) - the number of frames
            %               to skip when reading sequentially.
            
            p = inputParser;
            addOptional(p, 'case', [], @(x)isa(x, 'Case'));
            addOptional(p, 'graph', [], @(x)isa(x, 'Graph'));
            addParameter(p, 'behavior', 'sequential', ...
                @(x)ischar(x)||iscell(x));
            parse(p, varargin{:});
            
            obj.Listener_Graph = ...
                addlistener(obj, 'Graph', 'PostSet', @obj.callback_graph);
            obj.Listener_Case = ...
                addlistener(obj, 'Case', 'PostSet', @obj.callback_case);
            
            obj.Graph = p.Results.graph;
            obj.Case = p.Results.case;
            obj.Behavior = p.Results.behavior;
        end
        
        
        function set.Behavior(obj, arg)
            % setter for the Behavior property. parser the passed cell.
            %
            % inputs:
            %   arg (cell) - the Behavior cell
            %
            % outputs: none (modifies caller object)
            
            obj.Behavior = obj.parse_behavior(arg);
        end
        
        function run(obj)
            % runs the Driver, feeds all images in the queue and runs the
            % Graph in a loop
            %
            % inputs: none
            %
            % outputs: none (modifies caller object)
            
            if ~obj.Case.IsRead
                obj.Case.read();
            end
            if ~obj.Graph.IsValidated
                obj.Graph.validate();
            end
            
            if ischar(obj.Behavior.number_of_frames)
                if strcmpi(obj.Behavior.number_of_frames, 'all')
                    number_of_frames = obj.Case.NumEvents;
                else
                    error(['Invalid number_of_frames field in the ' ...
                        'Behavior property. Valid values are integers ' ...
                        'and the ''all'' string.']);
                end
            else
                number_of_frames = obj.Behavior.number_of_frames;
            end
            
            switch obj.Behavior.mode
                case 'sequential'
                    run_sequential_protocol();
                case 'random'
                    run_random_protocol();
            end            
            
            function run_sequential_protocol()                
                if number_of_frames > obj.Case.NumEvents
                    warning(['Requested a larger number of Events ' ...
                        'than what is found in the specified Case. ' ...
                        'Driver will only feed Events up to the total ' ...
                        'number of Events.']);
                    number_of_frames_ = obj.Case.NumEvents;
                else
                number_of_frames_ = min(obj.Case.NumEvents, ...
                    (obj.Behavior.skip + 1) * number_of_frames);
                end
                
                for event_ind = obj.Behavior.start_index : ...
                        (obj.Behavior.skip + 1) : number_of_frames_
                    
                    event_current = obj.Case.Events{event_ind};
                    
                    paths_to_load = cellfun(@(x)x.Path, ...
                        event_current.Frames, ...
                        'UniformOutput', false);
                    
                    % check if any of these are loaded
                    paths_already_loaded = cellfun( ...
                        @(y)num2str(y.Input.Value), ...
                        obj.Graph.Nodes(obj.FrameNodeIDs), ...
                        'UniformOutput', false);
                    
                    for ind_path = 1:numel(paths_to_load)
                        
                        pair_found = false;
                        
                        path_ = paths_to_load(ind_path);
                        is_loaded = ismember(paths_already_loaded, path_);
                        is_loaded_on_node_id = ...
                            obj.FrameNodeIDs(is_loaded);
                        
                        groups_of_loaded = cellfun(@(x)x.Group, ...
                            obj.Graph.Nodes(is_loaded_on_node_id), ...
                            'UniformOutput', false);
                        groups_of_loaded = [groups_of_loaded{:}];
                        
                        groups_to_load = obj.Graph.Nodes{ ...
                            obj.FrameNodeIDs(ind_path)}.Group;
                        source_group = false;
                            target_group = false;
                        for group_of_loaded = groups_of_loaded
                            
                            for group_to_load = groups_to_load
                                if obj.Graph.get_isomorphism_between( ...
                                        group_of_loaded, group_to_load) ...
                                        && obj.Graph.is_group_computed( ...
                                            group_of_loaded)
                                    source_group = group_of_loaded;
                                    target_group = group_to_load;
                                    pair_found = true;
                                    break;
                                end
                            end
                            if pair_found
                                break;
                            end
                        end
                        
                        if pair_found
                            obj.Graph.clone_group_to_group( ...
                                source_group, target_group);
                        end
                        
                    end                    
                    
                    cnt_frame_ind = 0;
                    for frame_ind = obj.FrameNodeIDs
                        cnt_frame_ind = cnt_frame_ind + 1;
                        current_value = ...
                            obj.Graph.Nodes{frame_ind}.Input.Value;
                        if isempty(current_value)
                            current_value = '';
                        end
                        if ~strcmp(current_value, ...
                                obj.Case.Events{event_ind}.Frames{ ...
                                cnt_frame_ind}.Path)
                            obj.Graph.update_node_data(frame_ind, ...
                                obj.Case.Events{event_ind} ...
                                .Frames{cnt_frame_ind}.Path, ...
                                'target', 'input');
                        end
                    end
                    obj.Graph.run();
                end
            end
            
            function run_random_protocol()
                event_inds = randi(numel(obj.Case.Events), ...
                    [1 number_of_frames]);
                for event_ind = event_inds
                    for frame_ind = obj.FrameNodeIDs
                        obj.Graph.update_node_data(frame_ind, ...
                            obj.Case.Events{event_ind} ...
                            .Frames{frame_ind}.Path, ...
                            'target', 'input');
                    end
                    obj.Graph.run();
                end
            end
        end        
    end
    
    methods (Access = private)        
        function behavior = parse_behavior(obj, arg)
            
            valid_modes = {'sequential', 'random'};
            
            if iscell(arg)
                behavior = check_behavior(name_value_pairs_to_struct(arg));
            elseif ischar(arg)
                behavior = check_behavior(struct('mode', arg));
            else
                error(['Behavior must be specified by a mode string or' ...
                    ' cell vector of name-value pairs.']);
            end
            
            function behavior = check_behavior(behavior)
                
                % check if the default property is passed as field
                default_prop = 'mode';
                if isfield(behavior, default_prop)
                    if ischar(behavior.(default_prop))
                        if ~ismember(behavior.(default_prop), valid_modes)
                            error(['The ' default_prop ' field of the' ...
                                ' passed behavior is invalid. Valid ' ...
                                'values are: ' ...
                                strjoin(valid_modes, ', ') '.']);
                        end
                    else
                        error(['The ' default_prop ' field of the ' ...
                            'passed behavior must be a string. Valid ' ...
                            'string values are: ' ...
                            strjoin(valid_modes, ', ') '.']);
                    end
                else
                    error(['Passed behavior must contain the default ' ...
                        '''mode'' field. Please specify the mode ' ...
                        'field. Valid modes are: ' ...
                        strjoin(valid_modes, ', ') '.']);
                end
                
                % check if optional properties have been passed
                optional_props = {'start_index', 'skip', ...
                    'number_of_frames', 'replacement'};
                default_values = {1, 0, 'all', false};
                valid_types = {{'numeric'}, {'numeric'}, {'numeric'}, ...
                    {'logical'}};
                valid_attrs = {{'scalar', 'integer', 'nonnegative'}, ...
                    {'scalar', 'integer', 'nonnegative'}, {}, ...
                    {'scalar'}};
                for i = 1:numel(optional_props)
                    if ~isfield(behavior, optional_props{i})
                        behavior.(optional_props{i}) = default_values{i};
                    else
                        validateattributes( ...
                            behavior.(optional_props{i}), ...
                            valid_types{i}, valid_attrs{i}, 'Driver', ...
                            optional_props{i});
                    end
                end
                switch class(behavior.number_of_frames)
                    case 'double'
                        validateattributes(behavior.number_of_frames, ...
                            {'numeric'}, ...
                            {'scalar', 'integer', 'nonnegative'}, ...
                            'Driver', 'number_of_frames');
                    case 'char'
                        if ~strcmpi(behavior.number_of_frames, 'all')
                            error(['Invalid string value passed for ' ...
                                'the number_of_frames field of ' ...
                                'Behavior. Pass ''all'' if you want ' ...
                                'read all Events.']);
                        end
                end
                
            end
                
        end
        
        function set_path_node_ids(obj)
            path_node_ids = find(cellfun( ...
                @(x)~isempty(strfind(lower(x.Label), 'frame')), ...
                obj.Graph.Nodes));
            path_numbers = zeros(1, numel(path_node_ids));
            for i = 1:numel(path_node_ids)
                path_string = strsplit( ...
                    obj.Graph.Nodes{path_node_ids(i)}.Label, '_');
                if numel(path_string) == 2
                    path_number = str2double(path_string{2});
                    if round(path_number) == path_number
                        path_numbers(i) = path_number;
                    else
                        error_path_number();
                    end
                else
                    error_path_number();
                end
            end
            
            [~, sort_inds] = sort(path_numbers, 'ascend');
            obj.FrameNodeIDs = path_node_ids(sort_inds);
            
            function error_path_number()
                error(['Path format does not match ' ...
                    'path_<path number> on Node ' ...
                    num2str(path_node_ids(i)) '. Path is ' ...
                    'identified and matched with the event ' ...
                    'structure based on its number by Driver. ' ...
                    'Please verify that all labels on Nodes ' ...
                    'that load data (probably images) follow the ' ...
                    'format ''path_<path number>'', where ' ...
                    'path_number is a string convertible to an ' ...
                    'integer.']);
            end
            
        end        
        
        function set_target_groups(obj)
            obj.TargetGroups = cell(1, numel(obj.FrameNodeIDs));
            all_groups = obj.Graph.get_unique_group_ids();
            cnt_framenode = 0;
            for frame_node_id = obj.FrameNodeIDs
                cnt_framenode = cnt_framenode + 1;
                current_groups = obj.Graph.Nodes{frame_node_id}.Group;
                isomorphic_target_groups = [];
                for current_group = current_groups(:)'
                    target_groups = setdiff(all_groups, current_group);
                    for target_group = target_groups
                        if obj.Graph.Groups.LUT_isomorphism( ...
                                current_group, target_group)
                            isomorphic_target_groups = ...
                                [isomorphic_target_groups target_group];
                        end
                    end
                end
                obj.TargetGroups{cnt_framenode} = isomorphic_target_groups;
            end
        end        
    end
    
    methods (Static = true)        
        function callback_graph(~, evnt)
            evnt.AffectedObject.set_path_node_ids();
            evnt.AffectedObject.set_target_groups();
        end
        
        function callback_case(src, evnt)
            % evnt.AffectedObject.set_behavior();
        end        
    end    
end