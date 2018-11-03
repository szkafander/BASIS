%% pipeline script language tutorial
% hit ctrl+enter while highlighting a cell to run it.
% comments explain the code.

%% the following demonstrates Pipeline definition using the pipeline 
% mini-language. make sure that you open
% \graphs\pipeline_script_language.gml in a GML editor and check pipeline
% definitions there.

% load the .gml
graph_ = Graph([get_basis_path ...
    '..\data\graphs\pipeline_script_language.gml']);
graph_.plot();

%% the first node
% the pipeline definition in the .gml is the following:
%
%   out_ <- @(~)identity(linspace(0,3.14,100))
%
% let's dissect this.
%
%   "out_" - the output argument. in the script language, output arguments
%       are only used to tell ProcessingFunction how many output arguments
%       to expect. here it is a single argument. otherwise output arguments
%       are separated by a comma. requesting two arguments would look like
%       this:
%       a, b <- @some_function...
%
%   "<-" - this is the token that separates outputs from the function name.
%
%   "@" - this is the token Matlab uses to refer to function handles. using
%       @ is simply required by Matlab's syntax.
%
%   "(~)" - parentheses after @ specify anonymous inputs. the "~" token is
%       a placeholder for meaning "no input". by Matlab's anonymous
%       function syntax rules, you must specify an anonymous input if the
%       anonymous function takes any inputs - in this case, the linspace...
%       argument. otherwise use a symbol that you refer to in the function
%       argument, i.e.,
%       @(some_input)some_function(some_input, parameters...)
%
%   "identity" - this is a BASIS placeholder function, it simply returns
%       whatever is passed to it unchanged. @identity is actually the
%       default BASIS ProcessingFunction. here we use it to simply set a
%       value (identity's argument) to a Node Output.
%
%   "linspace(0,3.14,100)" - this is a Matlab named function, it returns a
%       regularly spaced vector of 100 values between 0 and 3.14.
%
% so we expect this Node to return the result of linspace(0,3.14,100). let
% us check this by running the Node.

graph_.Nodes{1}.run();

% .run() runs the Node's Pipeline on its Input as arguments (here nothing)
% and sets the Value of the Node's Output equal to the returned value. let
% us check this.

x = graph_.Nodes{1}.Output.Value;
plot(x);
title('this should be a line ramping up to 3.14');

%% the second node
% the pipeline definition is @sin
% this is a Matlab named function.
% everything follows Matlab's anonymous function declaration rules here.
% the Node takes the Output of Node #1 as input and applies the sine
% function to it. let us run this and check the output.

graph_.Nodes{2}.run();

% let us plot this against x, the output of Node #1, since this is Node
% #2's input argument.

plot(x, graph_.Nodes{2}.Output.Value);
title('this should be sin(x) in [0, 3.14]');

%% the third node
% the pipeline definition here is out_ <- @(x)x.^2
% as you probably suspect, this defines a parabolic function. the important
% point here is to give an output argument ("out_"). this is needed for all
% anonymous functions. anonymous functions are anything Matlab will not
% find on its Path. since there is no function named "x" on its path,
% Matlab will not find this and thus BASIS will treat it as an anonymous
% function. the reason for having to give an output argument in the
% pipeline language is the following: when constructing the Pipeline, BASIS
% will try to find the number of output arguments of the function.
% anonymous functions cannot provide this information to BASIS and
% therefore the number of output arguments will be taken as 0. this will
% not raise an exception on its own but almost always leads to unexpected
% behavior, since the Node will not run when it sees that the Pipeline
% returns no outputs. let us run this and check.

graph_.Nodes{3}.run();

plot(x, graph_.Nodes{3}.Output.Value);
title('this should be a parabola in [0, 3.14]');

%% the fourth node
% the pipeline definition is out_ <- @(x)x.^3 -> @sqrt
% this is a chained pipeline.
% chaining means that, in this case, two functions will be called. the two
% function definitions are separated by the "->" token. thus, the input (x)
% will be first raised to the 3rd power, then the square root will be
% taken. let us run and check that the output is x^(3/2).

graph_.Nodes{4}.run();

plot(x, graph_.Nodes{4}.Output.Value);
title('this should be x^{3/2} in [0, 3.14] - the maximum is 5.6');

%% let us see how to define the Node #4's Pipeline using a Matlab script.

% let us add a new Node
graph_.add_node(Node('label', 'the same as Node #4', 'inputnodes', 1));
graph_.plot();

%% let us define the same Pipeline for this Node as Node #4's
% note that we set 'numoutputs' explicitly for the first
% ProcessingFunction, since it is anonymous

graph_.Nodes{5}.Pipeline = Pipeline({ ...
    ProcessingFunction(@(x)x.^3, 'numoutputs', 1), ...
    ProcessingFunction(@sqrt)});
graph_.Nodes{5}.run();

% let us plot the Outputs of Nodes #4 and #5 and compare - they should be
% the same.
plot(x, graph_.Nodes{4}.Output.Value, 'b'); hold on;
plot(x, graph_.Nodes{5}.Output.Value, 'ro');
legend('from Node #4', 'from Node #5');
title('the two outputs should be the same');