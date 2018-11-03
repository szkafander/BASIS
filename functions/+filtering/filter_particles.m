function properties_ = filter_particles(properties_input, fieldnames_, ...
    operations, varargin)
% filters rows of table properties_input based on binary operations applied
% to columns of variables specified by fieldnames_.
%
% inputs:
%   properties_input - a table obtained by measurement.measure_particles.
%   fieldnames_ - a cell vector of fieldname strings. each fieldname
%       specifies a column in the table properties_input.
%   operations - a cell vector of function handles that represent binary
%       operations on a column in properties_input. a binary operation must
%       return a logical variable. fieldnames and operations are matched,
%       i.e., an operation for every fieldname must be specified.
%   
% outputs: a filtered table that only contains rows of properties_input for
%   which all operations returned true.

fieldnames_ = cellfun(@(x)strrep(x, ':', '__'), fieldnames_, ...
    'UniformOutput', false);

inds_pass = true(size(properties_input, 1), 1);

for ind_fieldname = 1:numel(fieldnames_)
    values = properties_input.(fieldnames_{ind_fieldname});
    operation = operations{ind_fieldname};
    inds_pass = inds_pass & operation(values);
end

properties_ = properties_input(inds_pass, :);