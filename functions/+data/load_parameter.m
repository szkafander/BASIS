function parameter = load_parameter(input_, varargin)
% loads a parameter from disk, Store or DataLink and returns it. can be
% used to load constants in Nodes. behavior is the following:
%   - if a .mat file is specified and no variable name is specified,
%       load_parameter loads the .mat file as a struct with all fields
%   - if a .mat file is specified and a variable name is specified,
%       load_parameter loads that field of the .mat file
%   - if a Store or DataLink is specified and no variable name is
%       specified, load_parameter loads the first property it finds in the
%       Store or the Link of DataLink
%   - if a Store or DataLink is specified and a variable name is specified,
%       load_parameter loads that property in the Store or the Link of the
%       DataLink
%
% inputs:
%   input_ (.mat file path, Store or DataLink) - the data from which the
%       variable will be loaded
%   variable_name (string) - name-value pair, the name of the field in
%       input_ that will be loaded. the default is []. if not specified,
%       the first field will be loaded, if there are any fields.
%
% outputs:
%   parameter - the loaded parameter value

p = inputParser;
addParameter(p, 'variable_name', [], ...
    @(x)ischar(x)||isa(x, 'Store')||isa(x, 'DataLink'));
parse(p, varargin{:});
variable_name = p.Results.variable_name;

if ischar(input_)
    parameter = load(input_);
    if ~isempty(variable_name)
        parameter = parameter.(variable_name);
    end
elseif isa(input_, 'Store')
    if isempty(variable_name)
        fns = fieldnames(input_);
        if ~isempty(fns)
            parameter = input_.(fns{1});
        else
            error(['No variable name specified and no properties were ' ...
                'found in the specified Store. Please specify a ' ...
                'variable name that exists in the passed Store as a ' ...
                'property.']);
        end
    else
        parameter = input_.(variable_name);
    end
elseif isa(input_, 'DataLink')
    if isempty(variable_name)
        fns = fieldnames(input_.Link);
        if ~isempty(fns)
            parameter = input_.Link.(fns{1});
        else
            error(['No variable name specified and no properties were ' ...
                'found in the Link of the  specified DataLink. Please ' ...
                'specify a variable name that exists in the passed ' ...
                'Store as a property.']);
        end
    else
        parameter = input_.Link.(variable_name);
    end
end