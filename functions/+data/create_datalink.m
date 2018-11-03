function datalink_ = create_datalink(datalink_name, store_name)
% creates a DataLink object datalink_name with an in-memory Store called
% store_name in its Link in the base Matlab workspace. this function can be
% used in Graphs to initialize DataLink objects.
%
% inputs:
%   datalink_name (string) - the name of the DataLink object variable to be
%       created in the workspace.
%   store_name (string) - the name of the Store that is placed in the
%       DataLink's Link property.
%
% outputs:
%   datalink_ (DataLink) - a handle to the created DataLink object.

exists = evalin('base', ['exist(''' datalink_name ''', ''var'')']);
if ~exists
    evalin('base', [store_name ' = Store();']);
    evalin('base', [datalink_name ' = DataLink(' store_name ');']);
else
    warning(['Requested DataLink object already exists in the ' ...
        'workspace. This might lead to unexpected behavior.']);
end
datalink_ = evalin('base', datalink_name);