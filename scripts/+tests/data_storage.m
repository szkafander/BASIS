% on-disk, the path string identifies it
% delete it if it exists so that we can re-run this demo
if exist('store_ondisk.mat', 'file')
    delete('store_ondisk.mat');
end

% to see where we are
folder = fileparts(mfilename('fullpath'));

% define two stores
% in-memory
disp('creating data stores...');

store_inmemory = Store();
store_ondisk = fullfile(folder, 'store_ondisk.mat');

disp('stores created.');

% create a toy graph that computes and stores values of the sine function
% instantiate graph object
disp('creating graph...');

graph_ = Graph();

% add node #1 that applies the sine function
graph_.add_node(Node('label', 'sine', ...
    'outputnodes', 2, ...
    'pipeline', @sin));

% add node #2 that will store the result
graph_.add_node(Node('label', 'store'));

disp('graph created.');

% demo the in-memory store
disp('linking the in-memory data store...');

datalink_ = DataLink(store_inmemory);
fieldname_ = 'data_storage_demo';

disp('data store linked.');

% attach the data store Pipeline to node #2
graph_.Nodes{2}.Pipeline = ...
    Pipeline(@(x)data.store_data(x, datalink_, fieldname_));

% validate
graph_.validate();

% feed with data and run (see function below)
disp('running graph...');

feed_with_values_and_run(graph_);

disp('graph run');

% read back data and plot for validation
disp('re-reading data for validation. you should see a sine curve.');

hfig = figure;
plot(0:0.1:2*pi, datalink_.Link.(fieldname_));
xlabel('x'); ylabel('sine values read from in-memory datastore');

disp(['your data are in the workspace variable ' fname(store_inmemory) ...
    '. you can verify by checking the contents of ' ...
    fname(store_inmemory) '.' fieldname_ '.']);

input('press a key to continue...');

% demo the on-disk store
disp('linking the on-disk data store...');

datalink_ = DataLink(store_ondisk);
fieldname_ = 'data_storage_demo';

disp('data store linked.');

% attach the data store Pipeline to node #2
disp('attaching datalink to pipeline...');

graph_.Nodes{2}.Pipeline = ...
    Pipeline(@(x)data.store_data(x, datalink_, fieldname_));

disp('datalink attached.');

% reset and validate
graph_.reset();
graph_.validate();

% feed with data and run (see function below)
disp('running graph...');

feed_with_values_and_run(graph_);

disp('graph run.');

% read back data and plot for validation
disp('re-reading from on-disk data store for validation...')

hold on; plot(0:0.1:2*pi, datalink_.Link.(fieldname_), 'ro');
xlabel('x'); ylabel('sine values');
legend('from in-memory store', 'from on-disk store');
figure(hfig);

disp(['your data are in ' store_ondisk '. you can verify manually by ' ...
    'navigating to the folder ' folder ' in Matlab and left clicking ' ...
    'on the file and checking the "Details" window or loading it by ' ...
    'double-clicking on it and verifying the store_ondisk.' fieldname_ ...
    ' variable.']);

function feed_with_values_and_run(graph_)
    for x = 0:0.1:2*pi
        graph_.update_node_data(1, x, 'target', 'input');
        graph_.run();
    end
end

function name_ = fname(~)
    name_ = inputname(1);
end