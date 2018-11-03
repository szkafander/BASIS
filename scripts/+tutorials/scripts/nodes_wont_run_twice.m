%% nodes won't run twice
% hit ctrl+enter while highlighting a cell to run it.
% comments explain the code.

%% the following demonstrates the run logic behind input-output nodes
% in BASIS, the regular input-output nodes will not run unless their Data
% property is empty. the Data class has a dependent method to check for
% that. let us demonstrate this by building a simple Graph, adding one
% Node, and assigning a Pipeline that prints out 'I have just run' if the
% Node has been run.

graph_ = Graph();
graph_.add_node(Node('label', 'test', ...
    'pipeline', Pipeline(@(~)disp('I have just run.'))));
graph_.plot();
graph_.validate();
graph_.run();

% you should see 'I have just run' appearing in the console.

%% now let us add some data to the Node. this will set the HasData
% attribute of the Node's Output to true and the Node will no longer run.

graph_.Nodes{1}.Output.set('some data');
graph_.run();

% you should see nothing appear in the console. the Node has not run.

%% now let us clear the Node's Output and run it again.

graph_.Nodes{1}.clear();
graph_.run();

% it prints 'I have just run' again.
% this demonstrated the default behavior of input-output Nodes. this is
% useful for some tricks as well. for example, you can have a node load a
% constant parameter i.e., through the data.load_parameter function. when
% the Node is run the first time, it will load the requested data and set
% its Output equal to that. subsequent runs of the Node will not load the
% data again. this is useful in looped operation, i.e., through using the
% Driver class.