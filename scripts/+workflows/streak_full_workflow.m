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
Driver( ...
   Case([folder '\..\..\data\images\streak\stepping']), ...
   Graph([folder '\..\..\data\graphs\streak_simple_processing.gml'])).run();
disp('Graph run.');

disp('Plotting results...');

% plotting
T = datalink_.Link.streak_demo.temperature;
d = datalink_.Link.streak_demo.diameter;
v = datalink_.Link.streak_demo.velocity;

close all;

figure,
set(gcf, 'Name', 'bivariate statistics');

subplot(1, 3, 1);
plot(T, d, 'o');
x = [min(T) max(T)];
hold on;
plot(x, polyval(polyfit(T, d, 1), x));
xlabel('temperature, K');
ylabel('diameter, m');

subplot(1, 3, 2);
plot(T, v, 'o');
x = [min(T) max(T)];
hold on;
plot(x, polyval(polyfit(T, v, 1), x));
xlabel('temperature, K');
ylabel('velocity, m/s');

subplot(1, 3, 3);
plot(d, v, 'o');
x = [min(d) max(d)];
hold on;
plot(x, polyval(polyfit(d, v, 1), x));
xlabel('diameter, m');
ylabel('velocity, m/s');

techniques.streak.show_streaks_3d(datalink_.Link.streak_demo, 'figure', 2);
xlabel('x, m');
ylabel('y, m');
zlabel('z, m');