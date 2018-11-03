%% clone group tutorial
% hit ctrl+enter while highlighting a cell to run it.
% comments explain the code.

%% the following demonstrates cloning Group data in Graphs
% we will use the graph \data\graphs\pyrometry_optic_flow.gml to do this.
% this Graph performs optic flow calculation after a denoising step on a
% rolling image set. frames in the rolling image set is read in a pattern
% 1-2, 2-3, 3-4... this leads to a situation where in every iteration after
% the first, half of the computation is already done in the Graph. data can
% be moved from the second Group to the first and then load the next frame
% in the second Group.

% we load the graph first
graph_ = Graph([get_basis_path '..\data\graphs\pyrometry_optic_flow.gml']);

% let us display the two Groups in the Graph - Group member Nodes are
% highlighted by enlarging their Node markers
subplot(1, 2, 1);
graph_.plot('group', 1);
title('group 1');
subplot(1, 2, 2);
graph_.plot('group', 2);
title('group 2');

%% we can see that each Group carries out the same computation: first, the
% image is read, then the read image is denoised.

% first, let us manually add the path of the first frame to Group 1
graph_.get_node_by_label('frame_1').set_data([get_basis_path ...
    '..\data\images\pyrometry\rolling\frame_01.png']);

% we run the Nodes of Group 1
group_node_ids_1 = graph_.get_group_node_ids(1);
for i = group_node_ids_1
    graph_.Nodes{i}.run();
end

% let us plot what we have computed
subplot(1, 3, 1);
imshow(graph_.Nodes{group_node_ids_1(1)}.Output.Value);
title('read image');
subplot(1, 3, 2);
imshow(graph_.Nodes{group_node_ids_1(2)}.Output.Value);
title('denoised image');
subplot(1, 3, 3);
graph_.plot();
title('green shows Nodes that have been run.');

%% now clone the data from Group 1 to Group 2
graph_.clone_group_to_group(1, 2);

% let us plot data from Group 2
group_node_ids_2 = graph_.get_group_node_ids(2);

subplot(1, 3, 1);
imshow(graph_.Nodes{group_node_ids_2(1)}.Output.Value);
title('read image');
subplot(1, 3, 2);
imshow(graph_.Nodes{group_node_ids_2(2)}.Output.Value);
title('denoised image');
subplot(1, 3, 3);
graph_.plot();
title('green shows Nodes that have been run.');

% these should be the same as we have plotted before.

%% the Driver class can run Graphs in a loop by feeding frame nodes images
% read from an image set. Driver will carry out Group cloning automatically
% when it detects that computation has already been done on a fed image.
% let us test this.

% first, we add the "shout" function to the Pipelines of Nodes in Groups 1
% and 2. this function does nothing, except displays a message when its
% Node is run.
cnt = 0;
for i = group_node_ids_1
    cnt = cnt + 1;
    graph_.Nodes{i}.Pipeline.add_processingfunction( ...
        ProcessingFunction(@(x)shout( ...
        ['group 1 Node ' num2str(cnt) ' run'], x), ...
        'numoutputs', 1));
end

cnt = 0;
for i = group_node_ids_2
    cnt = cnt + 1;
    graph_.Nodes{i}.Pipeline.add_processingfunction( ...
        ProcessingFunction(@(x)shout( ...
        ['group 2 Node ' num2str(cnt) ' run'], x), ...
        'numoutputs', 1));
end

%% now let us run the Graph with a Driver. notice output in the console.

Driver(Case([folder '\..\..\data\images\pyrometry\rolling'], ...
            'framesperevent', 2), ...
       graph_).run();

% in the console, you see that Nodes in Group 1 are only run once. after
% that, output is just cloned from Group 2, then a new image is pushed to
% Group 2 and Group 2 is rerun.