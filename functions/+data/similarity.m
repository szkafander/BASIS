function similarity_value = similarity(values, varargin)
% computes a similarity metric value between value_1 and value_2. supports
% scalar, vector and matrix values. the supported similarity metrics:
% absolute difference, relative difference, mean square difference, mean
% absolute difference.
%
% inputs:
%   values (cell or numeric) - a collection of values. if no second value
%       is passed, similarity will compute similarity metrics between
%       combinations of rows of array type values or combinations of
%       elements of cell type values. if a second value is passed,
%       similarity metric values between the combinations of those values
%       will be computed row-wise (array) or elementwise (cell).
%   second_values (cell or numeric) - optional, a collection of values. if
%       passed, similarity will compute similarity metric values between
%       all combinations of rows or elements of the first and second
%       collection of values.
%   type (string) - name-value pair, specifies the similarity metric. valid
%       values: 'mean_square_difference', 'root_mean_square_difference' and
%       'mean_absolute_difference'. the default is
%       'mean_absolute_difference'. note: for scalar values, all types
%       except 'mean_square_difference' produce the same result.
%   mode (string) - name-value pair, specifies whether to normalize the
%       differences by values of the first collection of values. the
%       default is 'relative'. valid values: 'absolute', 'relative'.
%
% outputs:
%   similarity_values (numeric) - similarity scalar values. if more than
%       two values were passed, similarity_values is a matrix. if a second
%       set of values were passed, rows of similarity_values represent the
%       first set of values and columns of similarity_values represent the
%       second set of values.

p = inputParser;
addOptional(p, 'second_values', []);
addParameter(p, 'type', 'mean_absolute_difference', @ischar);
addParameter(p, 'mode', 'relative', @ischar);
parse(p, varargin{:});

second_values = p.Results.second_values;
second_values_passed = ~isempty(second_values);
if ~second_values_passed
    second_values = values;
end

if ~iscell(values)
    is_values_cell = false;
    if any(size(values) == 1)
        is_values_vector = true;
    else
        is_values_vector = false;
    end
else
    is_values_vector = false;
    is_values_cell = true;
end

if ~second_values_passed
    is_second_values_vector = is_values_vector;
    is_second_values_cell = is_values_cell;
else
    if ~iscell(second_values)
        is_second_values_cell = false;
        if any(size(second_values) == 1)
            is_second_values_vector = true;
        else
            is_second_values_vector = false;
        end
    else
        is_second_values_vector = false;
        is_second_values_cell = true;
    end
end

% both are vectors, fast computation
if is_values_vector && is_second_values_vector
    values_first = repmat(values(:)', [numel(second_values) 1]);
    values_second = repmat(second_values(:), [1 numel(values)]);
    similarity_value = abs(values_first - values_second);
    if strcmpi(p.Results.mode, 'relative')
        similarity_value = similarity_value ./ values_first;
    end
    if strcmpi(p.Results.type, 'mean_square_difference')
        similarity_value = similarity_value .^ 2;
    end
elseif ~is_values_vector && ~is_second_values_vector
    similarity_value = zeros(size(values, 1), size(second_values, 1));
    for i = 1:size(values, 1)
        values_first = repmat(values(i, :), [size(second_values, 1) 1]);
        differences = values_first - second_values;
        if strcmpi(p.Results.mode, 'relative')
            differences = differences ./ values_first;
        end
        switch p.Results.type
            case 'mean_absolute_difference'
                differences = mean(abs(differences), 2);
            case 'mean_square_difference'
                differences = mean(differences.^2, 2);
            case 'root_mean_square_difference'
                differences = sqrt(mean(differences.^2, 2));
        end
        similarity_value(i, :) = differences;
    end
elseif is_values_vector && ~is_second_values_vector
    values_first = repmat(values, [size(second_values, 1) 1]);
    similarity_value = values_first - second_values;
    if strcmpi(p.Results.mode, 'relative')
        similarity_value = similarity_value ./ values_first;
    end
    switch p.Results.type
        case 'mean_absolute_difference'
            similarity_value = mean(abs(similarity_value), 2);
        case 'mean_square_difference'
            similarity_value = mean(similarity_value.^2, 2);
        case 'root_mean_square_difference'
            similarity_value = sqrt(mean(similarity_value.^2, 2));
    end
elseif ~is_values_vector && is_second_values_vector
    values_second = repmat(second_values, [size(values, 1) 1]);
    similarity_value = values - values_second;
    if strcmpi(p.Results.mode, 'relative')
        similarity_value = similarity_value ./ values;
    end
    switch p.Results.type
        case 'mean_absolute_difference'
            similarity_value = mean(abs(similarity_value), 2);
        case 'mean_square_difference'
            similarity_value = mean(similarity_value.^2, 2);
        case 'root_mean_square_difference'
            similarity_value = sqrt(mean(similarity_value.^2, 2));
    end
end


% TODO