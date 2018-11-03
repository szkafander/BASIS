function datalink_ = aggregate_data(data_, datalink_, property_name, ...
    varargin)
% stores data in a DataLink object. store_data calls the aggregate method
% of the DataLink object.
%
% inputs:
%   data_ - the data to store.
%   datalink_ - the DataLink object to store data_ in. this must be a
%       handle to the object itself.
%   property_name (string) - the name of the field of the Store in the
%       DataLink object that will store data_.
%   mode (function handle) - name-value pair, specifies the aggregating
%       function. the new data will be aggregating_function(old_data,
%       new_data). aggregate_data does not check input-output relations in
%       the aggregating function.
%
% outputs:
%   datalink_ - the handle of the updated DataLink object.

p = inputParser;
addParameter(p, 'mode', @(x,y)x+y, @(x)isa(x, 'function_handle'));
parse(p, varargin{:});

datalink_.aggregate(data_, property_name, 'mode', p.Results.mode);