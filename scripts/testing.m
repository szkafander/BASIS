% the following is a list of implemented tests
% you can run these tests by clicking inside the text cells bounded by '%%'
% symbols and hitting ctrl+enter
% note: you can view the individual scripts by typing
%   open tests.<script name> in the command line

%% this tests reading and visualizing a graph from a .gml file
tests.graph_from_gml

%% this tests reading a graph and running specific nodes
tests.run_some_nodes

%% this tests on-disk and in-memory data storage
% note: on-disk storage in an asynchronous loop is sometimes
% unstable in Matlab 2016b
% delete /scripts/tests/store_ondisk.mat if the vector size error appears
tests.data_storage

%% this tests reading exotic image formats
% three images will be shown, a .dm3 micrograph, a .dng raw image and an
% .im7 LaVision format
tests.exotic_image_formats