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

% set up the driver
driver_ = Driver( ...
    Case([folder '\..\..\data\images\shadowgraph\rolling\high_mag']), ...
    Graph([folder '\..\..\data\graphs\shadow_sizing.gml']));

% feed images
driver_.run();

% display results - the 3 is a dummy resolution
disp(['The particle diameter was: ' ...
    num2str(mean(store_.shadow_sizing.equivdiameter.*3)) ' +/- ' ...
    num2str(std(store_.shadow_sizing.equivdiameter.*3)) ' microns.']);