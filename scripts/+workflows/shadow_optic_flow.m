% to see where we are
folder = fileparts(mfilename('fullpath'));

% clear datastore if exists
disp(' ');
disp(['Running this demo will erase the datalink_ and store_ ' ...
    'variables from the workspace.']);
disp(' ');
key = input(['Type ''Y'' or ''y'' and hit enter to continue or type ' ...
    'any other string and hit enter to abort.\n\n'], 's');

if ~strcmpi(key, 'y')
    disp('Aborting demo.');
    return;
end

clear datalink_;
clear store_;

disp('Running graph...');
driver_ = Driver( ...
   Case([folder '\..\..\data\images\shadowgraph\rolling\low_mag'], ...
        'framesperevent', 2), ...
   Graph([folder '\..\..\data\graphs\shadow_optic_flow.gml']));
driver_.run();
disp('Graph run.');

disp('Plotting results...');

displacement = datalink_.Link.of_demo;
num_runs = driver_.Graph.get_node_by_label('counter').Output.Value;
mean_displacement = displacement ./ num_runs;

close all;
figure,
subplot(1, 3, 1);
imagesc(mean_displacement(:,:,1));
axis image;
title('x displacement');

subplot(1, 3, 2);
imagesc(mean_displacement(:,:,2));
axis image;
title('y displacement');

subplot(1, 3, 3);
imagesc(sqrt(mean_displacement(:,:,1).^2 + mean_displacement(:,:,2).^2));
axis image;
title('displacement magnitude');