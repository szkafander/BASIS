function datalink_ = store_data(data_, datalink_, property_name, varargin)
% stores data in a DataLink object. store_data calls the append method of
% the DataLink object.
%
% inputs:
%   data_ - the data to store.
%   datalink_ - the DataLink object to store data_ in. this must be a
%       handle to the object itself.
%   property_name (string) - the name of the field of the Store in the
%       DataLink object that will store data_.
%
% outputs:
%   datalink_ - the handle of the updated DataLink object.

datalink_.append(data_, property_name);