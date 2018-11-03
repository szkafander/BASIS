function mapped_ = map(input_, mapping, varargin)
% maps the input data input_ to an output mapped_ by using a mapping
% defined as a polynomial or a lookup table.
%
% inputs:
%   input_ - the input, usually a numeric array-like.
%   mapping - the mapping to be applied to input_. normally a numeric
%       array-like: if an interpolation mapping is used, mapping can be a 
%       2XN or NX2 vector where the first row or column holds original
%       values and the second row or column stores the mapped values. if
%       a polynomial mode is used, mapping is a Matlab polynomial and
%       mapped_ will be polyval(mapping, inputs_).
%   mode (string) - name-value pair, accepted values are 'polynomial' and
%       'interpolation'.
%
% outputs:
%   mapped_ - the mapped data.

p = inputParser;
addParameter(p, 'mode', 'polynomial', @ischar);
parse(p, varargin{:});

VALID_MODES = {'polynomial', 'interpolation'};

class_image = class(input_);

try
    input_ = double(input_);
    mapping = double(mapping);
catch
    error(['Invalid image and/or mapping was passed. Image_input and ' ...
        'mapping must be numeric arrays.']);
end

switch p.Results.mode
    case 'polynomial'
        mapped_ = polyval(mapping, input_);
    case 'interpolation'
        mapping_size = size(mapping);
        if any(mapping_size == 1)
            values_old = 1:numel(mapping);
            values_new = mapping;
        elseif all(mapping_size == 2) || mapping_size(2) == 2
            values_old = mapping(:, 1);
            values_new = mapping(:, 2);
        elseif mapping_size(1) == 2
            values_old = mapping(1, :);
            values_new = mapping(2, :);
        else
            error_invalid_mapping();
        end
        mapped_ = interp1(values_old, values_new, input_, ...
            'linear', 'extrap');
    otherwise
        error(['Invalid mode was passed. Valid modes are: ' ...
            strjoin(VALID_MODES, ', ') '.']);
end

mapped_ = cast(mapped_, class_image);

function error_invalid_mapping()
error(['The variable passed with the argument ''mapping'' ' ...
    'must be a 2-vector. Please pass a vector argument ' ...
    'that has either two columns or two rows. Refer to ' ...
    'the documentation of preprocessing.map for more ' ...
    'details.']);