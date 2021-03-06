% to see where we are
folder = fileparts(mfilename('fullpath'));

% run
Driver( ...
    Case([folder '\..\..\data\images\pyrometry\rolling'], ...
        'framesperevent', 2), ...
    Graph([folder '\..\..\data\graphs\pyrometry_optic_flow.gml'])).run();