classdef Graph < handle
    % BASIS Graph. represents a computational workflow via a Directed
    % Acyclic Graph (DAG). Nodes store Data and define an element of
    % computation via a chained list of functions, a.k.a a Pipeline of
    % ProcessingFunctions. edges route inputs and outputs. routing rules:
    %
    % 1. routing is done in a directed, acyclic fashion. there can be no 
    %   loops in the Graph. the .validate method will not let cyclic Graphs
    %   compile.
    % 2. a Node can have multiple inputs. Inputs are passed as SEPARATE 
    %   ARGUMENTS to the Node Pipeline. if you need to zip a number of 
    %   inputs, use an auxiliary Node running e.g., data.merge.
    % 3. a Node Pipeline can have multiple output arguments. in this case,
    %   the OUTPUTS WILL BE ZIPPED INTO A MATLAB CELL. a Node only has one 
    %   Output Data.
    % 4. if a Node Output is routed to multiple Nodes, THE ENTIRE OUTPUT IS
    %   ROUTED to every successor Node. if you need to split Outputs, use 
    %   an auxiliary Node running e.g., data.split.
    % 5. NODE INPUT ROUTING ORDER MATTERS! Input route order can be set by 
    %   giving edges integer labels (in a .gml), or modifying the 
    %   InputNodeIDs property of the Node directly (in a script). when 
    %   labeling a .gml, you don’t need to number every edge, only the ones 
    %   that have an important order. all unnumbered edges will be passed
    %   after the numbered ones in a random order.
    %
    % Graphs can be instantiated in a number of ways. for running a Graph
    % object, call its .validate and .run method. .validate must only be
    % called once, after instantiation.
    %
    % the underlying properties of the Graph is the Nodes and DirectedGraph
    % properties, of which the latter is hidden. Graph wraps Matlab's
    % digraph functions to compute graph-related properties. if any of the
    % underlying properties change, Graph recomputes its derived
    % properties. this behavior can be toggled using the .toggle_updating
    % method.   
    
    properties (SetObservable = true)
        % a cell of Node objects
        Nodes
    end
    
    properties (SetObservable = true, Hidden = true)
        % a Matlab digraph object
        DirectedGraph
    end
    
    properties (SetAccess = private)
        % logical, true if the Graph is validated
        IsValidated = false
        % protected, number of Nodes
        NumberOfNodes
        % protected, integer-valued vector, call order of Nodes
        CallOrder
        % protected, indices of input Nodes
        InputNodeIDs
        % protected, indices of output Nodes
        OutputNodeIDs
        % protected, the Groups struct, this stores information related to 
        % Node Groups
        Groups
    end
    
    properties (Dependent = true, SetAccess = private)
        % dependent, protected, the indices of Nodes that have been 
        % computed
        ComputedNodeIDs
        % dependent, protected, logical, true if the Graph has been run
        IsComputed
    end
    
    properties (SetAccess = private, Hidden = true)
        % protected, hidden, listener to changes in Nodes
        Listener_Nodes
        % protected, hidden, listener to changes in DirectedGraph
        Listener_DirectedGraph
    end    
    
    methods
        function obj = Graph(varargin)
            % constructor
            %
            % usage:
            %   graph_ = Graph() - creates an empty Graph object. Nodes can
            %       be added by modifying the Nodes property or via the
            %       .add_node method.
            %   graph_ = Graph(nodes) - creates a Graph object with the
            %       Nodes property initialized from nodes, a cell of Node
            %       objects.
            %   graph_ = Graph(path) - creates a Graph object from a Graph
            %       Markup Language (.gml) file. in the .gml, Nodes can
            %       labeled via the Graph labeling mini-language.
            %   graph_ = Graph(digraph) - creates a Graph object from a
            %       Matlab digraph object. the 'label' column is used in
            %       the Nodes table to set Node labels. edges set
            %       input-output routing and edge labels determine
            %       ordering.
            
            p = inputParser;
            addOptional(p, 'graph_', {}, ...
                @(x)isa(x, 'digraph')||ischar(x)||iscell(x));
            parse(p, varargin{:});
            graph_ = p.Results.graph_; 
            
            switch class(graph_)
                case 'digraph'
                    if ~is_valid_graph(graph_)
                        error('Input graph is invalid.');
                    end
                    obj.Nodes = digraph_to_nodes(graph_);
                case 'cell'
                    if ~all(cellfun(@(x)isa(x, 'Node'), graph_))
                        error(['Cell passed as input contained ' ...
                            'non-Node elements. All elements must ' ...
                            'be Nodes.']);
                    end
                    obj.Nodes = graph_;                    
                case 'char'
                    gmldata = read_gml(graph_);
                    nodes = graph_data_to_nodes(find_graph(gmldata));
                    obj.Nodes = nodes;
            end
            
            obj.Listener_Nodes = ...
                addlistener(obj, 'Nodes', 'PostSet', @obj.callback_nodes);
            obj.Listener_DirectedGraph = ...
                addlistener(obj, 'DirectedGraph', 'PostSet', ...
                @obj.callback_directedgraph);
            
            obj.initialize();
        end
        
        function number_of_nodes = get.NumberOfNodes(obj)
            % dependent getter for the NumberOfNodes property
            % 
            % inputs: none
            %
            % outputs:
            %   number_of_nodes (integer-valued scalar) - the number of
            %   nodes in the Graph
            
            number_of_nodes = numel(obj.Nodes);
        end
        
        function computed_node_ids = get.ComputedNodeIDs(obj)
            % dependent getter for the ComputedNodeIDs property
            %
            % inputs: none
            %
            % outputs:
            %   computed_node_ids (integer-valued vector) - a vector of
            %   indices of Nodes that have been computed
            
            computed_node_ids = find(cellfun(@(x)x.IsComputed, obj.Nodes));
        end
        
        function is_computed = get.IsComputed(obj)
            % dependent getter for the IsComputed property
            %
            % inputs: none
            % 
            % outputs:
            %   is_computed (logical) - true if the Graph has been run
            
            is_computed = numel(obj.ComputedNodeIDs) == obj.NumberOfNodes;
        end
        
        function node_ids = get_node_ids(obj)
            % returns Node indices
            %
            % inputs: none
            %
            % outputs:
            %   node_ids (integer-valued vector) - a vector of Node indices
            
            node_ids = 1:obj.NumberOfNodes;
        end    
        
        function node_labels = get_node_labels(obj)
            % returns a cell of Node labels
            %
            % inputs: none
            %
            % outputs:
            %   node_labels (cell of strings) - cell of Node labels
            
            node_labels = cellfun(@(x)x.Label, obj.Nodes, ...
                'UniformOutput', false);
        end        
        
        function node = get_node_by_label(obj, label)
            % returns a handle to a Node specified by its label. if
            % multiple Nodes are found with the same label, returns a cell
            % of handles to those Node objects.
            %
            % inputs:
            %   label (string) - Node label
            %
            % outputs:
            %   node (Node or cell of Nodes) - handle or handles to the
            %       found Nodes
            
            labels = obj.get_node_labels();
            ind_node = ismember(labels, label);
            if sum(ind_node) > 1
                node = obj.Nodes(ind_node);
            else
                node = obj.Nodes{ind_node};
            end
        end
        
        function node_ids = get_node_id_by_label(obj, label)
            % returns indices of Nodes with a matched label
            %
            % inputs:
            %   label (string) - Node label
            %
            % outputs:
            %   node_ids (integer-valued vector) - vector of indices of
            %       Nodes that have the same label as label
            
            labels = obj.get_node_labels();
            if any(cellfun(@(x)~isempty(x), labels))                
                ids = obj.get_node_ids();
                ind_node = ismember(labels, label);
                node_ids = ids(ind_node);
            else
                warning('No Node with labels to remove from.');
                node_ids = [];
            end
        end
        
        function initialize(obj)
            % initializes Graph, sets DirectedGraph, sets Input/Output
            % routing, etc. this method is called automatically unless
            % updating is toggled off using .toggle_updating
            %
            % inputs: none
            %
            % outputs: none (modifies caller object)
            
            % set successors and predecessors
            node_labels = obj.get_node_labels();
            node_inds = obj.get_node_ids();
            for node_ind = node_inds
                inputnodes = obj.Nodes{node_ind}.InputNodes;
                if iscell(inputnodes)
                    inputnodes = cellfun(@replace_labels_with_id, ...
                        inputnodes, 'UniformOutput', false);
                    inputnodes = [inputnodes{:}];
                else
                    inputnodes = inputnodes( ...
                        ismember(inputnodes, node_inds));
                end
                inputnodes = remove_nans(inputnodes);                
                outputnodes = obj.Nodes{node_ind}.OutputNodes;
                if iscell(outputnodes)
                    outputnodes = cellfun(@replace_labels_with_id, ...
                        outputnodes, 'UniformOutput', false);
                    outputnodes = [outputnodes{:}];
                else
                    outputnodes = outputnodes( ...
                        ismember(outputnodes, node_inds));
                end
                outputnodes = remove_nans(outputnodes);                
                obj.Nodes{node_ind}.InputNodeIDs = inputnodes;
                obj.Nodes{node_ind}.OutputNodeIDs = outputnodes;
            end
            
            % scan input-output routes both ways
            for node_ind = node_inds
                input_inds = obj.Nodes{node_ind}.InputNodeIDs;
                for input_ind = input_inds(:)'
                    if ~ismember(node_ind, ...
                            obj.Nodes{input_ind}.OutputNodeIDs)
                        obj.Nodes{input_ind}.OutputNodeIDs = ...
                            [obj.Nodes{input_ind}.OutputNodeIDs node_ind];
                    end
                end
                output_inds = obj.Nodes{node_ind}.OutputNodeIDs;
                for output_ind = output_inds(:)'
                    if ~ismember(node_ind, ...
                            obj.Nodes{output_ind}.InputNodeIDs)
                        obj.Nodes{output_ind}.InputNodeIDs = ...
                            [obj.Nodes{output_ind}.InputNodeIDs node_ind];
                    end
                end
            end
            
            % set DirectedGraph
            obj.DirectedGraph = nodes_to_digraph(obj.Nodes);
            
            % call listener manually if it is off
            if ~obj.Listener_DirectedGraph.Enabled
                obj.CallOrder = obj.DirectedGraph.toposort();
            end
            
            % set input and output node ID's
            obj.InputNodeIDs = find(cellfun(@(x)isempty( ...
                x.InputNodeIDs), obj.Nodes));
            obj.OutputNodeIDs = find(cellfun(@(x)isempty( ...
                x.OutputNodeIDs), obj.Nodes));
            
            % set number of nodes
            obj.NumberOfNodes = numel(obj.Nodes);
            
            % clear inputs
            for node_id = obj.CallOrder(:)'
                if isempty(obj.Nodes{node_id}.InputNodeIDs)
                    obj.Nodes{node_id}.IsInputNode = true;
                else
                    obj.Nodes{node_id}.IsInputNode = false;
                end
                if isempty(obj.Nodes{node_id}.OutputNodeIDs)
                    obj.Nodes{node_id}.IsOutputNode = true;
                else
                    obj.Nodes{node_id}.IsOutputNode = false;
                end
                if ~obj.Nodes{node_id}.IsInputNode
                    obj.Nodes{node_id}.Input = [];
                end
            end
            
            % set Node properties
            for node_id = obj.CallOrder(:)'
                input_node_ids = obj.Nodes{node_id}.InputNodeIDs;
                if numel(obj.Nodes{node_id}.Input) < numel(input_node_ids)
                    for input_node_id = input_node_ids(:)'
                        obj.Nodes{node_id}.Input = ...
                            [obj.Nodes{node_id}.Input ...
                            obj.Nodes{input_node_id}.Output];
                    end
                end                
            end
            
            % set upstream node ID's for all nodes
            for node_id = 1:numel(obj.Nodes)
                indices = obj.DirectedGraph.dfsearch(node_id);
                obj.Nodes{node_id}.UpstreamNodeIDs = ...
                    indices(2:end)';
            end
            
            % set groups
            obj.propagate_groups();
            obj.set_groups_property();
            
            % init empty Data for input nodes
            for node_id = obj.InputNodeIDs
                if isempty(obj.Nodes{node_id}.Input)
                    obj.Nodes{node_id}.Input = Data();
                end
            end            
            
            function replaced_id = replace_labels_with_id(label)
                if ischar(label)
                    membership = ismember(node_labels, label);
                    if sum(membership) > 0
                        replaced_id = find(membership);
                    else
                        replaced_id = NaN;
                    end
                else
                    replaced_id = label;
                end
            end            
        end
        
        function reset(obj)
            % resets Graph, deletes all Input and Output Data
            %
            % inputs: none
            % 
            % outputs: none (modifies caller object)
            
            for node_id = obj.CallOrder
                obj.Nodes{node_id}.clear('target', 'input');
                obj.Nodes{node_id}.clear('target', 'output');
            end
        end        
        
        function output_ = run(obj)
            % runs the Graph, computes all Nodes by calling their Pipelines
            % on the Inputs. run will only run if the Graph has been
            % validated via the .validate method.
            %
            % inputs: none
            %
            % outputs:
            %   outputs_ (Data) - the Data object or a cell of Data objects
            %       of the Output Data of the output nodes
            
            if obj.IsValidated
                for node_id = obj.CallOrder
                    obj.Nodes{node_id}.run();
                end
                output_ = cell(1, numel(obj.OutputNodeIDs));
                for output_id = 1:numel(obj.OutputNodeIDs)
                    output_{output_id} = ...
                        obj.Nodes{obj.OutputNodeIDs(output_id)}.Output;
                end
                output_ = output_{:};
            else
                error('Graph is not validated. Run Graph.validate().')
            end
        end        
        
        function run_group(obj, group_ind)
            % runs a Group of Nodes
            %
            % inputs:
            %   group_ind (integer-valued scalar) - the index of the Group
            %       to run
            %
            % outputs: none (modifies caller object)
            
            if obj.IsValidated
                for node_id = obj.get_group_node_ids(group_ind)
                    obj.Nodes{node_id}.run();
                end
            else
                error('Graph is not validated. Run Graph.validate().')
            end
        end
        
        function validate(obj, varargin)
            % validates the Graph, including checking for loops, whether
            % all Nodes have valid labels and indices. optionally prints a
            % summary of the Graph. sets the IsValidated property.
            %
            % inputs:
            %   verbose (logical) - name-value pair, if true, validate
            %       prints a summary of the Graph
            %
            % outputs: none (modifies the caller object)
            
            p = inputParser;
            addParameter(p, 'verbose', false, @islogical);
            parse(p, varargin{:});
            
            % check if DAG
            is_dag = obj.DirectedGraph.isdag;
            
            % check if all nodes have unique ID's
            node_inds_nonunique = find_nonunique(obj.get_node_ids());
            nodes_have_nonunique_ids = any(node_inds_nonunique);
            
            % check if all labels are unique
            node_labels_nonunique = find_nonunique(obj.get_node_labels());
            nodes_have_nonunique_labels = any(node_labels_nonunique);
            
            % issue warnings and errors
            if ~is_dag
                error(['Graph is not directed acyclic. Revise ' ...
                    'topology. Use graph.plot() to verify that the ' ...
                    'revised topology is direct acyclic.']);
            end
            
            if nodes_have_nonunique_ids
                error(['Nodes with the following linear indices do ' ...
                    'not have unique ID''s: ' ...
                    num2str(find(node_inds_nonunique)) '. All Nodes ' ...
                    'must have unique ID''s. Please revise Node ID''s.']);
            end
            
            if nodes_have_nonunique_labels
                warning(['Not all Nodes have unique labels. The best ' ...
                    'practice is to give each node a unique label. ' ...
                    'Nodes with the following linear indices do not ' ...
                    'have unique labels: ' ...
                    num2str(find(node_labels_nonunique)) '.']);
            end            
            
            if p.Results.verbose
                if is_dag && nodes_have_unique_ids
                    disp('Graph is valid.');
                    obj.print_summary();
                end
            end
            
            obj.IsValidated = is_dag && ~nodes_have_nonunique_ids;
        end        
        
        function toggle_updating(obj, varargin)
            % toggles automatic Graph updating. updating is by default on.
            % updating means that the Graph object listens to changes to
            % its DirectedGraph or Nodes property and recomputes derived
            % properties if those change.
            %
            % inputs:
            %   status (logical) - optional, if passed, the updating status
            %       is set to status
            %   verbose (logical) - name-value pair, if true, prints
            %       updating status. the default is false.
            %
            % outputs: none (modifies caller object)
            
            p = inputParser;
            addOptional(p, 'status', [], @islogical);
            addParameter(p, 'verbose', false, @islogical);
            parse(p, varargin{:});
            
            status_ = p.Results.status;
            
            if ~isempty(status_)
                obj.Listener_Nodes.Enabled = status_;
                obj.Listener_DirectedGraph.Enabled = status_;
            else
                obj.Listener_Nodes.Enabled = ~obj.Listener_Nodes.Enabled;
                obj.Listener_DirectedGraph.Enabled = ...
                    ~obj.Listener_DirectedGraph.Enabled;
            end
            
            if p.Results.verbose
                disp(' ');
                disp('Current listener status: ');
                disp(' ');
                disp(table([obj.Listener_Nodes.Enabled; ...
                    obj.Listener_DirectedGraph.Enabled], ...
                    'VariableNames', {'status'}, ...
                    'RowNames', {'Listener_Nodes', ...
                    'Listener_DirectedGraph'}));
            end
        end
        
        function print_summary(obj)
            % prints a summary of the Graph including Node labels,
            % and input-output indices
            % 
            % inputs: none
            %
            % outputs: none (void, prints in the console)
            
            disp(' ');
            disp('Graph summary:');
            disp(' ');
            disp(table(obj.get_node_ids()', obj.get_node_labels()', ...
                cellfun(@(x)x.InputNodeIDs, obj.Nodes, ...
                'UniformOutput', false)', ...
                cellfun(@(x)x.OutputNodeIDs, obj.Nodes, ...
                'UniformOutput', false)', ...
                'VariableNames', ...
                {'ID', 'label', 'input_node_ids', 'output_node_ids'}));
        end
        
        function update_node_data(obj, node_id, data_, varargin)
            % updates Node with new data and propagates changes upstream on
            % graph. data is set to either the Input or Output property.
            %
            % inputs:
            %   node_id (integer-valued scalar) - the index of the Node to
            %       update
            %   data_ (any type) - the data to set
            %   target (string) - name-value pair, accepted values are:
            %       'input' and 'output'. the default is 'output'.
            %   do_not_propagate (logical) - name-value pair, if true, the
            %       update is not propagated to successors. the default is
            %       false.
            %
            % outputs: none (modifies caller object)
            
            p = inputParser;
            addParameter(p, 'do_not_propagate', false, @islogical);
            addParameter(p, 'target', 'output', @ischar);
            parse(p, varargin{:});
            
            has_changed = obj.Nodes{node_id}.update_data(data_, ...
                'target', p.Results.target);
            
            if ~p.Results.do_not_propagate && has_changed
                obj.clear_upstream_node_data(node_id);
            end
        end
        
        function clear_node_data(obj, node_id, varargin)
            % clears node data and propagates changes upstream on Graph
            %
            % inputs:
            %   do_not_propagate (logical) - name-value pair, if true, the
            %       update is not propagated to successors. the default is
            %       false.
            %
            % outputs: none (modifies caller object)
            
            p = inputParser;
            addParameter(p, 'do_not_propagate', false, @islogical);
            parse(p, node_id, group, varargin{:});
            do_not_propagate = p.Results.do_not_propagate;
            
            obj.update_node_data(node_id, {}, ...
                'do_not_propagate', do_not_propagate);
        end
        
        function clear_upstream_node_data(obj, node_id)
            % clears all successor Data if they are input-output Nodes
            %
            % inputs:
            %   node_id (integer-valued scalar) - index of Node to clear
            %   from
            %
            % outputs: none (modifies caller object)
            
            for id = obj.Nodes{node_id}.UpstreamNodeIDs(:)'
                if strcmpi(obj.Nodes{id}.Type, 'input-output')
                    obj.Nodes{id}.clear();
                end
            end
        end
        
        function add_node(obj, node_)
            % adds a new Node to the graph. the new Node is routed via its
            % InputNodes and OutputNodes property.
            %
            % inputs:
            %   node_ (Node) - Node object to add
            %
            % outputs: none (modifies caller object)
            
            if iscell(node_)
                for ind = 1:numel(node_)
                    obj.add_node(node_{ind});
                end
            else
                obj.Nodes = [obj.Nodes {node_}];
            end
        end
        
        function remove_node(obj, node_id)
            % removes a node from Graph.Nodes
            %
            % inputs:
            %   node_id (cell, numeric or string) - the node to remove.
            %       can be referenced by its label, index. multiple labels
            %       or indices can be requested as well.
            %
            % outputs: none (modifies caller object)
            
            if iscell(node_id)
                for ind = 1:numel(node_id)
                    obj.remove_node(node_id{ind});
                end
            elseif ischar(node_id)
                obj.remove_node(obj.get_node_id_by_label(node_id));
            else
                if ~isempty(node_id)
                    linear_ind = false(size(obj.get_node_ids()));
                    for i = 1:numel(node_id)
                        linear_ind = linear_ind | ...
                            obj.get_node_ids() == node_id(i);
                        if sum(linear_ind) == 0
                            error(['Requested node ID not found in ' ...
                                'Nodes. Please revise the passed node' ...
                                'id.']);
                        end                        
                    end
                    obj.Nodes(linear_ind) = [];
                end
            end
        end

        function plot(obj, varargin)
            % visualizes the Graph. computed Nodes are displayed as green
            % dots, uncomputed Nodes are displayed as red dots. Edges are
            % labeled based on their routing order. Node Groups can be
            % highlighted by enlarging their dots.
            %
            % inputs:
            %   group (integer-valued scalar) - Group index to highlight
            %
            % outputs: none (void, opens a figure and plots the graph)
            
            p = inputParser;
            addParameter(p, 'group', [], ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'integer', 'scalar'}));
            parse(p, varargin{:});
            group = p.Results.group;
            
            % add edge labels based on variable passing order
            edge_labels = cell(numel(obj.DirectedGraph.Edges), 1);
            edge_labels = cellfun(@(~)'1', edge_labels, ...
                'UniformOutput', false);
            end_nodes = obj.DirectedGraph.Edges.EndNodes;
            
            % join node labels with node ID's for clarify
            node_labels = cell(numel(obj.Nodes), 1);
            
            % fill labels
            for i = 1:numel(obj.Nodes)
                node_id = obj.DirectedGraph.Nodes.id(i);
                node_labels{i} = strjoin({ ...
                    num2str(node_id), ...
                    obj.DirectedGraph.Nodes.label{i}}, '.');
                incoming_edges = end_nodes(:, 2) == node_id;
                incoming_edge_ids = find(incoming_edges);
                incoming_edge_sources = end_nodes(incoming_edges, 1);
                input_node_ids = obj.Nodes{i}.InputNodeIDs;
                
                for j = 1:numel(input_node_ids)
                    this_edge = incoming_edge_ids( ...
                        incoming_edge_sources == input_node_ids(j));
                    edge_labels{this_edge} = num2str(j);
                end
            end
            
            % plot graph
            h = obj.DirectedGraph.plot('NodeLabel', node_labels, ...
                'MarkerSize', 10, 'EdgeColor', 'k', 'NodeColor', 'r', ...
                'EdgeLabel', edge_labels);
            
            % highlight Nodes that have already run
            highlight(h, obj.ComputedNodeIDs, 'NodeColor', 'g');
            
            % highlight specified group
            if ~isempty(group)
                highlight(h, obj.get_group_node_ids(group));
            end            
        end
        
        function set_group(obj, node_id, group, varargin)
            % convenience method to set Group membership of a Node.
            % propagates membership to successors.
            %
            % inputs:
            %   node_id (integer-valued scalar) - the index of the Node to
            %       set Group membership for
            %   group (integer-valued scalar) - the group index to which
            %       the Node will belong to
            %   do_not_propagate (logical) - name-value pair, if true, the
            %       group membership is not propagated
            %
            % outputs: none (modifies caller object)
            
            p = inputParser;
            addRequired(p, 'node_id', ...
                @(x)validateattributes(x, {'numeric'}, ...
                {'scalar', 'integer'}));
            addRequired(p, 'group', ...
                @(x)validateattributes(x, {'numeric'}, {'integer'}));
            addParameter(p, 'do_not_propagate', false, @islogical);
            parse(p, node_id, group, varargin{:});
            group = p.Results.group;
            node_id = p.Results.node_id;
            do_not_propagate = p.Results.do_not_propagate;
            
            if ~ismember(node_id, obj.InputNodeIDs)
                error('You can only group input nodes.');
            end
            
            obj.Nodes{node_id}.Group = unique(group);
            
            if ~do_not_propagate
                obj.propagate_groups();
            end
        end        
        
        function set_groups_property(obj)
            % an initializer for the Groups struct. sets Group node
            % indices, defines Groups and computes Group isomorphism.
            %
            % inputs: none
            %
            % outputs: none (modifies caller object)
            
            groups = struct();
            
            % get all unique groups
            unique_groups = obj.get_unique_group_ids();
            
            % this is to order group node id's
            callorder = obj.CallOrder;
            
            for group = unique_groups(:)'
                
                % find nodes that have this group
                node_ids_in = find(cellfun( ...
                    @(x)any(x.Group==group), ...
                    obj.Nodes));                
                
                % set Groups property
                groups(1).(['group_' num2str(group)]) = callorder( ...
                    ismember(callorder, node_ids_in));
            end
            
            obj.Groups = groups;
            
            obj.set_isomorphism();
        end        
        
        function group_ids = get_group_ids(obj)
            % gets Group membership indices for each Node
            %
            % inputs: none
            %
            % outputs:
            %   group_ids (cell) - cell of Group membership indices for
            %       each Node
            
            group_ids = cellfun(@(x)x.Group, obj.Nodes, ...
                'UniformOutput', false);
        end        
        
        function unique_group_ids = get_unique_group_ids(obj)
            % returns unique Group indices
            %
            % inputs: none
            %
            % outputs:
            %   unique_group_ids (integer-valued vector) - vector of Group
            %       indices. only the unique indices are returned.
            
            groups_all = obj.get_group_ids();
            node_ids = ~cellfun(@isempty, groups_all);
            groups_valid = cellfun(@(x)x(:)', groups_all(node_ids), ...
                'UniformOutput', false);
            unique_group_ids = unique(horzcat(groups_valid{:}));
        end
        
        function node_ids = get_group_node_ids(obj, group_id)
            % returns a the indices of Nodes that are in a certain Group
            %
            % inputs:
            %   group_id (integer-valued scalar) - the index of the Group
            %       the Node indices of which will be listed
            
            node_ids = obj.Groups(1).(['group_' num2str(group_id)]);
        end
        
        function number_of_groups = get_number_of_groups(obj)
            % returns the number of different Groups
            %
            % inputs: none
            %
            % outputs:
            %   number_of_groups (integer-valued scalar) - the number of
            %       Groups
            fns = fieldnames(obj.Groups);
            number_of_groups = numel(find((cellfun(@(x)strcmp(x(1:5), ...
                'group'), fns))));
        end
        
        function set_isomorphism(obj)
            % computes isomorpism between Groups. two Groups are isomorphic
            % if the topology of the subgraphs are identical and the same
            % Pipelines are called on the corresponding Nodes. the
            % Pipelines are compared via comparing a hash of their
            % serialized object representation. note: there is usually no
            % need to call this method as it is called in .initialize
            %
            % inputs: none
            %
            % outputs: none (modifies caller object)
            
            num_groups = obj.get_number_of_groups;
            obj.Groups.LUT_isomorphism = false(num_groups);
            obj.Groups.LUT_isomorphic_indices = cell(num_groups);
            unique_group_ids = obj.get_unique_group_ids();
            for g1 = 1:numel(unique_group_ids)
                for g2 = 1:numel(unique_group_ids)
                    if g1 == g2
                        obj.Groups.LUT_isomorphism(g1, g2) = true;
                        obj.Groups.LUT_isomorphic_indices{g1, g2} = ...
                            (1:numel(obj.get_group_node_ids( ...
                            unique_group_ids(g1))))';
                    else
                        graph_1 = obj.get_subgraph(unique_group_ids(g1));
                        graph_2 = obj.get_subgraph(unique_group_ids(g2));
                        if size(graph_1.Nodes, 1) == ...
                                size(graph_2.Nodes, 1) && ...
                            size(graph_1.Edges, 1) == ...
                                size(graph_2.Edges, 1)
                            isomorphism_ = isomorphism( ...
                                graph_1, ...
                                graph_2, ...
                                'NodeVariables', 'pipeline_hash');
                        else
                            isomorphism_ = [];
                        end
                        val = ~isempty(isomorphism_);
                        obj.Groups.LUT_isomorphism(g1, g2) = val;
                        obj.Groups.LUT_isomorphic_indices{g1, g2} = ...
                            isomorphism_;
                    end
                end
            end
        end
        
        function clone_group_to_group(obj, source_group, target_group)
            % copies Data from Nodes of a Group to corresponding Nodes to
            % another Group
            %
            % inputs:
            %   source_group (integer-valued scalar) - the index of the
            %       Group to copy from
            %   target_group (integer-valued scalar) - the index of the
            %       Group to copy to
            %
            % outputs: none (modifies caller object)
            
            validateattributes(source_group, {'numeric'}, ...
                {'integer', 'scalar'});
            validateattributes(target_group, {'numeric'}, ...
                {'integer', 'scalar'});
            node_ids_source = obj.get_group_node_ids(source_group);
            node_ids_target = obj.get_group_node_ids(target_group);
            if obj.Groups.LUT_isomorphism(source_group, target_group)
                isomorphic_indices = obj.Groups.LUT_isomorphic_indices{ ...
                    source_group, target_group};
                for i = 1:numel(node_ids_source)
                    node_id_source = node_ids_source(i);
                    node_id_target = node_ids_target( ...
                        isomorphic_indices(i));
                    obj.Nodes{node_id_source}.clone_data( ...
                        obj.Nodes{node_id_target});
                    if obj.Nodes{node_id_source}.IsInputNode && ...
                            obj.Nodes{node_id_target}.IsInputNode
                        obj.Nodes{node_id_source}.clone_data( ...
                            obj.Nodes{node_id_target}, ...
                            'source_field', 'input', ...
                            'target_field', 'input');
                    end
                end
            else
                error('Source and target groups are not isomorphic.');
            end
        end
        
        function is_computed = is_group_computed(obj, group_id)
            % checks if a Group is computed, i.e., all member Nodes are
            % computed
            %
            % inputs:
            %   group_id (integer-valued scalar) - the index of the Group
            %       to check
            %
            % outputs:
            %   is_computed (logical) - true if all Nodes have been
            %       computed in the Group
            is_computed = all(cellfun(@(x)x.IsComputed, ...
                obj.Nodes(obj.get_group_node_ids(group_id))));
        end
        
        function group_ind = get_group_ind(obj, group)
            % gets the linear index of a Group (Group indices must not be
            % regular). the linear index is the Group's linear index in the
            % Groups struct. there is usually no need to call this method
            % manually.
            %
            % inputs:
            %   group (integer-valued scalar) - the index of the Group
            %
            % outputs:
            %   group_ind (integer-valued scalar) - the linear index of the
            %       Group
            
            group_ind = find(obj.get_unique_group_ids() == group);
        end

        function is_isomorphic = get_isomorphism_between(obj, ...
                source_group, target_group)
            % checks isomorphism between two Groups. isomorphism is not
            % computed in this method, but indexed from the Groups struct.
            %
            % inputs:
            %   source_group (integer-valued scalar) - the index of the
            %       Group to copy from
            %   target_group (integer-valued scalar) - the index of the
            %       Group to copy to
            %
            % outputs:
            %   is_isomorphic (logical) - true if the Groups are
            %       isomorphic, false otherwise
            
            is_isomorphic = obj.Groups.LUT_isomorphism( ...
                obj.get_group_ind(source_group), ...
                obj.get_group_ind(target_group));
        end

        function subgraph_ = get_subgraph(obj, group_id)
            % returns a Matlab digraph object built from Nodes in a Group
            %
            % inputs:
            %   group_id (integer-valued scalar) - the index of the Group
            %       to check
            %
            % outputs:
            %   subgraph_ (digraph) - a Matlab digraph object built from
            %       Nodes in the Group group_id
            
            group_node_ids = obj.get_group_node_ids(group_id);
            subgraph_ = obj.DirectedGraph.subgraph(group_node_ids);
            pipeline_hashes = cellfun(@(x)x.pipeline_hash(), ...
                obj.Nodes(group_node_ids), 'UniformOutput', false);
            subgraph_.Nodes = [subgraph_.Nodes ...
                struct2table(struct('pipeline_hash', pipeline_hashes'))];
        end        
    end

    methods (Access = private)
        function check_node_ids(obj)
            node_ids = obj.get_node_ids();
            if ~isempty(node_ids)
                if (numel(unique(node_ids)) == numel(node_ids)) && ...
                        (numel(node_ids) == max(node_ids))
                    if ~all(sort(node_ids, 'ascend') == 1:max(node_ids))
                        reset_node_ids();
                    end
                else
                    reset_node_ids();
                end
            end
            
            function reset_node_ids()
                node_ids_new = 1:obj.NumberOfNodes;
                for node_id = node_ids_new
                    obj.Nodes{node_id}.ID = node_id;
                end
                disp(['Graph reordered node ID''s after detecting ' ...
                    'inconsistent node ID values.']);
                disp('The following is a summary of the operation:\n');
                disp(table(node_ids', node_ids_new', ...
                    obj.get_node_labels()', 'VariableNames', ...
                    {'original_node_ids', 'new_node_ids', 'label'}));
            end
        end
               
        function propagate_groups(obj)
            node_ids = setdiff(1:numel(obj.Nodes), obj.InputNodeIDs);
            for node_id = node_ids(:)'
                obj.Nodes{node_id}.Group = [];
            end
            
            % check group levels
            groups_all = cellfun(@(x)x.Group, obj.Nodes, ...
                'UniformOutput', false);
            node_ids = ~cellfun(@isempty, groups_all) & ...
                cellfun(@(x)x.IsInputNode, obj.Nodes);
            groups_valid = cellfun(@(x)x(:)', groups_all(node_ids), ...
                'UniformOutput', false);
            unique_groups = unique(horzcat(groups_valid{:}));
            
            % set upstream id's
            for group = unique_groups(:)'
                
                % find nodes that have this group
                node_ids_in = find(cellfun( ...
                    @(x)any(x.Group==group), ...
                    obj.Nodes));
                
                % collect upstream node ids in group
                upstream_ids_in = [];
                for node_id_in = node_ids_in(:)'
                    upstream_ids_in = union(upstream_ids_in, ...
                        obj.Nodes{node_id_in}.UpstreamNodeIDs);
                end
                
                % collect non-group nodes
                node_ids_out = setdiff(obj.InputNodeIDs, node_ids_in);
                
                % collect upstream node ids in non-group
                upstream_ids_out = [];
                for node_id_out = node_ids_out(:)'
                    upstream_ids_out = union(upstream_ids_out, ...
                        obj.Nodes{node_id_out}.UpstreamNodeIDs);
                end
                
                % set group of nodes
                upstream_ids_in = setdiff(upstream_ids_in, ...
                    intersect(upstream_ids_in, upstream_ids_out));
                for i = 1:numel(upstream_ids_in)
                    obj.Nodes{upstream_ids_in(i)}.Group = unique( ...
                       [obj.Nodes{upstream_ids_in(i)}.Group group]);
                end                
            end            
        end        
    end
    
    methods (Access = private, Static = true)        
        function callback_nodes(~, event)
            event.AffectedObject.initialize();
        end
        
        function callback_directedgraph(~, event)
            event.AffectedObject.CallOrder = ...
                event.AffectedObject.DirectedGraph.toposort();
        end        
    end    
end