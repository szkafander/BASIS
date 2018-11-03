% to see where we are
folder = fileparts(mfilename('fullpath'));

% this loads and constructs a Graph object from a .gml graph file
disp('reading graph...');

graph_ = Graph([folder '\..\..\data\graphs\shadow_simple_processing.gml']);

disp('graph read.');

% add some data to a Node and run it
graph_.Nodes{1}.Input.set( ...
    [folder ...
    '\..\..\data\images\shadowgraph\rolling\mid_mag\set_211000001.jpg']);

figure('units', 'normalized', 'position', [0.1 0.1 0.8 0.4]);

disp('running Node 1...');

graph_.Nodes{1}.run();

disp('Node 1 run.');

% run its successor
successor_id = graph_.Nodes{1}.UpstreamNodeIDs(1);

disp('running Node 2...');

graph_.Nodes{successor_id}.run();

disp('Node 2 run.');

subplot(1, 3, 2); imshow(graph_.Nodes{successor_id}.Output.Value, []);
title(['read output from Node ' num2str(successor_id)]);

% run one more successor
successor_id = graph_.Nodes{successor_id}.UpstreamNodeIDs(1);

disp('running Node 3...');

graph_.Nodes{successor_id}.run();

disp('Node 3 run.');

subplot(1, 3, 3); imshow(graph_.Nodes{successor_id}.Output.Value, []);
title(['read output from Node ' num2str(successor_id)]);

subplot(1, 3, 1); graph_.plot();
title('graph with already computed nodes');