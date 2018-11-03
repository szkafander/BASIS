function output_ = merge(varargin)
% merges a variable number of inputs to a cell array or 3D array.
%
% inputs:
%   any number of variables of any type
%       if there is only one input variable apart from name-value pairs and
%       the input variable is a cell array, merge treats values of the cell
%       array as if they had been passed as separate input variables.
% additional name-value pairs:
%   'mode' - specifies merge mode. accepted values:
%       'cell' (default) - merges input variables to a cell
%       '3darray' - concatenates input variables along the third dimension.
%           useful for producing image stacks. inputs must be concatenable
%           along the third dimension.
%       'struct:<field 1>_<field_2>_<...>' - creates a Matlab struct object
%           from the input fields, where the fields are placed into field
%           1, field 2, ... in successive order. specifying the fieldnames
%           (along with the ":" token) is optional.
%       'table:<row, column, or neither>' - concatenates table inputs if
%           the numbers of their columns are equal. passed struct arrays
%           are converted to tables if possible.
%       'table:columns_<column name 1>,<column name 2>,...' - concatenates
%           table inputs horizontally, i.e., adds new columns with names
%           <column name>. the passed data must contain at least one table
%           and at least one numeric array variable. the numeric arrays
%           must have the same number of elements as the number of rows of
%           the table. this mode is used to quickly add derived variables
%           to a table.
%
% outputs:
%   output_ - output cell or 3D array

% scan for mode parameter
mode_id = find( cellfun(@find_mode, varargin) );

if isempty(mode_id)
    mode_ = 'cell';
elseif numel(varargin) < mode_id + 1
    varargin(mode_id) = [];
    mode_ = 'cell';
else
    mode_ = varargin{mode_id + 1};
    varargin([mode_id mode_id+1]) = [];
end

if numel(varargin) == 1 && iscell(varargin{1})
    varargin = varargin{1};
end

switch strtok(mode_, '_-,: ')
    case 'cell'
        output_ = {varargin{:}};
    case '3darray'
        output_ = cat(3, varargin{:});
    case 'struct'
        struct_arg = strsplit(mode_, ':');
        if numel(struct_arg) > 2
            error(['Invalid mode string. Struct mode string must ' ...
                'follow the format: ' ...
                '''struct:<field 1>_<field_2>_<...>''.']);
        elseif numel(struct_arg) == 1
            fieldnames = cellfun(@(x)['field_' num2str(x)], ...
                num2cell(1:numel(varargin)), 'UniformOutput', false);
        else
            fieldnames = cellfun(@strtrim, ...
                strsplit(struct_arg{2}, ','), 'UniformOutput', false);
        end
        if numel(fieldnames) ~= numel(varargin)
            error(['Number of passed struct field names must be ' ...
                'equal to number of input arguments to merge.']);
        end
        output_ = cell2struct(varargin, fieldnames, 2);
    case 'table'
        table_arg = strsplit(mode_, ':');
        if numel(table_arg) > 1
            table_arg = {table_arg{1}, strjoin(table_arg(2:end), ':')};
        end
        if numel(table_arg) == 1
            mode_ = 'row';
        elseif numel(table_arg) == 2
            if strcmpi(table_arg{2}, 'column')
                mode_ = 'column';
            elseif strcmpi(strtok(table_arg{2}, ':'), 'columns')
                mode_ = 'columns';
                args = strsplit(table_arg{2}, ':');
                column_names = cellfun(@strtrim, ...
                    strsplit(args{2}, ','), ...
                    'UniformOutput', false);
            end
        end
        args = varargin;
        try
            for i = 1:numel(args)
                if isstruct(args{i})
                    args{i} = struct2table(args{i});
                end
            end
        catch
            error(['Not all passed arguments are tables ' ...
                'or table dimensions or column names are ' ...
                'inconsistent. Please check the passed ' ...
                'arguments.']);
        end
        switch mode_
            case 'row'
                output_ = cat(1, varargin{:});
            case 'column'
                output_ = cat(2, varargin{:});
            case 'columns'
                ind_tables = cellfun(@istable, varargin);
                table_vars = varargin(ind_tables);
                non_table_vars = varargin(~ind_tables);
                table_vars = cat(2, table_vars{:});
                if numel(non_table_vars) ~= numel(column_names)
                    error(['Trying to use the ''columns'' mode for' ...
                        ' merge. This mode requires that the ' ...
                        'number of the passed non-table variables ' ...
                        'are the same as the number of named ' ...
                        'columns. Please revise the named columns ' ...
                        'or the passed data to merge.']);
                else
                    for column_ind = 1:numel(column_names)
                        current_table = non_table_vars{column_ind};
                        current_table = struct( ...
                            column_names{column_ind}, ...
                            current_table);
                        table_vars = cat(2, table_vars, ...
                            struct2table(current_table));
                    end
                end
                output_ = table_vars;
        end
end


function is_mode = find_mode(value)
% regular strcmpi unfortunately recurses into cells
is_mode = false;
if ischar(value)
    is_mode = strcmpi(value, 'mode');
end