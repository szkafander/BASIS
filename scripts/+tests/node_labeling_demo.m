% to see where we are
folder = fileparts(mfilename('fullpath'));

% this loads and constructs a Graph object from a .gml graph file
graph_ = Graph([folder '\..\..\data\graphs\node_labeling_demo.gml']);

graph_.plot()