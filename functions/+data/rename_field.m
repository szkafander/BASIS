function renamed = rename_field(data_, field_old, field_new)
% renames a field or column in a struct or table input data_. the field or
% column to be renamed can be specified either by using its field- or
% column name or via its linear index. if an index is used, the field or
% column is pulled from fieldnames(data_) or data_.Properties.VariableNames
% for struct and table inputs, respectively.
%
% inputs:
%   data_ (struct or table) - the input struct or table that contains the
%       field or column to be renamed.
%   field_old (string or integer-valued scalar) - the field or column to
%       rename. this can be specified by using a string or an integer
%       scalar index.
%   field_new (string) - the new name of the renamed field or column.
%
% outputs:
%   renamed (table or struct) - table or struct that contains the renamed
%       field or column.

switch class(data_)
    case 'struct'
        if isnumeric(field_old)
            fns = fieldnames(data_);
            field_old = fns{field_old};
        end
        [data_.(field_new)] = data_.(field_old);
        renamed = rmfield(data_, field_old);
    case 'table'
        if ischar(field_old)
            field_old = ismember(data_.Properties.VariableNames, ...
                field_old);
        end
        renamed = data_;
        renamed.Properties.VariableNames{field_old} = field_new;
    otherwise
        error(['Improper value was passed with the data_ ' ...
            'argument. rename_field only accepts struct or table ' ...
            'inputs.']);
end