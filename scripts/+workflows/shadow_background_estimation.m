close all;

% to see where we are
folder = fileparts(mfilename('fullpath'));

% this loads and constructs a Graph object from a .gml graph file
disp('reading graph...');

graph_ = Graph([folder ...
    '\..\..\data\graphs\shadow_background_estimation.gml']);

disp('graph read.');

% read a case
disp('reading case...');

case_ = Case([folder ...
    '\..\..\data\images\shadowgraph\rolling\mid_mag']);

disp('case read.');

% feed images to the graph
driver_ = Driver(case_, graph_, ...
    'behavior', {'mode', 'random', 'number_of_frames', 100});
driver_.run();
title('estimated background');

disp('background estimated.');