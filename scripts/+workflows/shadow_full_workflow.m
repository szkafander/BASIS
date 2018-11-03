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
   Case([folder '\..\..\data\images\shadowgraph\stepping\high_mag']), ...
   Graph([folder '\..\..\data\graphs\shadow_simple_processing.gml']));
driver_.run();
disp('Graph run.');

disp('Plotting results...');

% plotting
s = datalink_.Link.shadow_demo.shape;
d = datalink_.Link.shadow_demo.diameter;
v = datalink_.Link.shadow_demo.velocity_magnitude;

close all;

figure,
set(gcf, 'Name', 'bivariate statistics');

subplot(1, 3, 1);
plot(s, d, 'o');
x = [min(s) max(s)];
hold on;
plot(x, polyval(polyfit(s, d, 1), x));
xlabel('shape');
ylabel('diameter, m');

subplot(1, 3, 2);
plot(s, v, 'o');
x = [min(s) max(s)];
hold on;
plot(x, polyval(polyfit(s, v, 1), x));
xlabel('shape');
ylabel('velocity, m/s');

subplot(1, 3, 3);
plot(d, v, 'o');
x = [min(d) max(d)];
hold on;
plot(x, polyval(polyfit(d, v, 1), x));
xlabel('diameter, m');
ylabel('velocity, m/s');