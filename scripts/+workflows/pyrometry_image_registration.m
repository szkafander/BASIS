% to see where we are
folder = fileparts(mfilename('fullpath'));

% this loads and constructs a Graph object from a .gml graph file
graph_ = Graph([folder ...
    '\..\..\data\graphs\pyrometry_bicolor_image_registration.gml']);

% set up the case
% this looks at files in the target folder and automatically determines
% read mode and frames per event. in this case, the setup is two-sensor
% two-color imaging. each frame is a separate view.
case_ = Case([folder ...
    '\..\..\data\images\pyrometry\stepping']);

% set up the driver
driver_ = Driver(case_, graph_);

% run the driver. this automatically loops through the case and applies the
% methodology defined in graph_
figure('name', 'registered false color image');
driver_.run();