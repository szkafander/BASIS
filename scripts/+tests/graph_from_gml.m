% to see where we are
folder = fileparts(mfilename('fullpath'));

% this loads and constructs a Graph object from a .gml graph file
graph_ = Graph([folder '\..\..\data\graphs\shadow_simple_processing.gml']);

% plot the graph and its groups
figure('units', 'normalized', 'position', [0.1 0.1 0.8 0.4]);
subplot(1, 3, 1); graph_.plot(); title('graph');
subplot(1, 3, 2); graph_.plot('group', 1); title('group 1');
subplot(1, 3, 3); graph_.plot('group', 2); title('group 2');