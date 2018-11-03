% to see where we are
folder = fileparts(mfilename('fullpath'));

% create a toy graph that loads and displays images
disp('creating graph...');

graph_ = Graph();

% add node #1 that applies the sine function
graph_.add_node(Node('label', 'frame_1', ...
    'outputnodes', 2, ...
    'pipeline', @data.read_image));

% add node #2 that will store the result
graph_.add_node(Node('label', 'cast_and_show', ...
    'pipeline', Pipeline({@data.cast_image, @imshow, @(~)pause(2)})));

disp('graph created.');

% validate
graph_.validate();

% feed with data and run (see function below)
case_ = Case([folder ...
    '\..\..\data\images\image_formats']);

% set up the driver
driver_ = Driver(case_, graph_);

% run the driver
warning('off', 'MATLAB:tifflib:TIFFReadDirectory:libraryWarning');
driver_.run();