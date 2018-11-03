function data_selected = select(data_input, selected_part)
% selects and returns parts of the data in data_input. parts to be selected
% are specified in the argument selected_part. this function is meant to be
% used in Graphs to route output variables or select from loaded parameter
% objects. this function selects variables from aggregate data in a sense
% analogous to selecting columns from tall-format datasets, i.e., it should
% not be used to select subsets of a single array-like variable.
%
% inputs:
%   data_input (struct, cell, numeric array or Data) - the data to select
%       from.
%   selected_part (integer-valued scalar, array of integer-valued scalars,
%       string or cell of strings) - numeric index, numeric indices,
%       fieldname or fieldnames of variables to select from data_input.
%       string and cell of string arguments can only be passed when
%       operating on struct or table type variables passed in the argument
%       data_input. when specifying numeric indices with struct or table
%       data_input, select returns the fields based on their numeric order.
%       in the case of tables, this is the order of columns read from left
%       to right. in the case of struct, the order is usually the order in
%       which the fields have been declared. if a 3d array is passed in
%       data_input and a numeric index is specified in selected_part, then 
%       select operates along the third dimension and assumes that you are
%       trying to select image channels.
%
% outputs:
%   data_selected - the selected variables from data_input. the type of
%       data_selected is determined by the following rules:
%           - if data_input is a numeric array, data_selected will be a
%               numeric array.
%           - if data_input is a struct, and a single variable is specified
%               in selected_part, data_selected will be the type of that
%               single variable.
%           - if data_input is a table, and a single variable is specified
%               in selected_part, data_selected will be a column vector or
%               column cell array, depending on the uniformity of types in
%               the requested column.
%           - if data_input is a struct or table, and multiple indices or
%               fieldnames are requested in selected_part, then
%               data_selected will be a cell containing arrays or cells of
%               the requested variables.

validateattributes(selected_part, {'numeric', 'char', 'cell'}, {});
if isnumeric(selected_part) && ~all(round(selected_part) == selected_part)
    error(['When specifying numeric indices in the argument ' ...
        'selected_part, all indices must be integer-valued. Please ' ...
        'only pass an integer-valued scalar or an array of ' ...
        'integer-valued scalars in selected_part.']);
end

if isa(data_input, 'Data')
    data_input = data_input.Value;
end

if iscell(data_input)
    if isnumeric(selected_part)
        switch numel(selected_part)
            case 0
                data_selected = {};
            case 1
                data_selected = data_input{selected_part};
            otherwise
                data_selected = data_input(selected_part);
        end
    elseif ischar(selected_part) || iscellstr(selected_part)
        error_str_invalid()
    else
        error_selected_invalid()
    end
elseif istable(data_input) || isstruct(data_input)
    switch class(data_input)
        case 'struct'
            fieldnames_ = fieldnames(data_input);
        case 'table'
            fieldnames_ = data_input.Properties.VariableNames;
    end
    if isnumeric(selected_part)
        switch numel(selected_part)
            case 0
                data_selected = [];
            case 1
                data_selected = data_input.(fieldnames_(selected_part));
            otherwise
                data_selected = cell(1, numel(selected_part));
                for i = 1:numel(selected_part)
                    data_selected{i} = ...
                        data_input.(fieldnames_(selected_part(i)));
                end
        end
    elseif ischar(selected_part)
        data_selected = data_input.(selected_part);
    elseif iscellstr(selected_part)
        switch numel(selected_part)
            case 0
                data_selected = [];
            case 1
                data_selected = data_input.(selected_part);
            otherwise
                data_selected = cell(1, numel(selected_part));
                for i = 1:numel(selected_part)
                    data_selected{i} = ...
                        data_input.(selected_part{i});
                end
        end
    else
        error_selected_invalid()
    end
elseif isnumeric(data_input)
    if isnumeric(selected_part)
        if numel(size(data_input)) == 3
            data_selected = data_input(:, :, selected_part);
        else
            data_selected = data_input(selected_part);
        end
    elseif ischar(selected_part) || iscellstr(selected_part)
        error_str_invalid()
    else
        error_selected_invalid()
    end
else
    error(['A variable of unsupported type was passed as data_input. ' ...
        'Supported types are: numeric, cell, Data, struct and table. ' ...
        'Please revise the variable passed with the data_input ' ...
        'argument.']);
end


function error_str_invalid()
error(['A named data field or column was requested for ' ...
    'selection, but a cell data_input was passed. Parts of ' ...
    'data inputs can only be specified using numeric indices. ' ...
    'Please specify an integer-valued scalar or an array of ' ...
    'integer-valued scalars in the argument selected_part.']);

function error_selected_invalid()
error(['A variable with an invalid type was passed as ' ...
    'the selected_part argument. Valid types are: ' ...
    'an integer-valued scalar or an array of integer-valued ' ...
    'scalars, a string or a cell of strings. Please revise ' ...
    'passed selected_part argument.']);