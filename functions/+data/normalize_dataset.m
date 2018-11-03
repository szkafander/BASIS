function [data_normalized, normalization] = normalize_dataset( ...
    properties_, varargin)
% a utility function to normalize and standardize columns in the table of
% properties properties_. normalize_dataset acts columnwise. the following
% operations are supported: mean subtraction, divide by standard deviation,
% scale between range(1)..range(2). properties_ should only contain scalar
% features. the scalar features can be found by using e.g.,
% filtering.extract_scalar_features. if properties_ contains a column
% called 'id', normalize_dataset ignores and does not return it.
%
% inputs:
%   properties_ (table) - table of properties, normally produced by
%       measurement.measure_particles or similar
%   centering (logical) - name-value pair, if true, then the mean is
%       subtracted from every column. the default is true.
%   standardization (logical) - name-value pair, if true, then each column
%       is divided by its standard deviation. the default is true.
%   scale_between (2-vector) - name-value pair. it accepts a 2-element
%       vector in which the first element should be smaller than the second
%       element. if specified, scales every column between the two values.
%       the default is [] (no scaling).
%   normalization (table) - name-value pair. a normalization table, the
%       second output argument of this function. using this table
%       overrides all previous options and performs normalization based on
%       the table. this is used to normalize unseen data based on training
%       data.
%
% outputs:
%   data_normalized (table) - the normalized version of properties_
%   normalization (table) - a table that holds information necessary to
%       carry out normalization on unseen data.

p = inputParser;
addParameter(p, 'normalization', [], @isstruct);
addParameter(p, 'centering', true, @islogical);
addParameter(p, 'standardization', true, @islogical);
addParameter(p, 'scale_between', [], ...
    @(x)validateattributes(x, {'numeric'}, {'vector', 'numel', 2}));
parse(p, varargin{:});

data_normalized = properties_;

if ismember('id', data_normalized.Properties.VariableNames)
    data_normalized.id = [];
end

num_features = size(data_normalized, 1);

if ~isempty(p.Results.normalization)
    normalization = p.Results.normalization;
    % do normalization based on struct
else
    columns = properties.Properties.VariableNames;
    
    if ~isempty(p.Results.scale_between)
        for i = 1:numel(columns)
            var_current = data_normalized.(columns{i});
            if iscell(var_current)
                try
                    var_current = cell2mat(var_current);
                catch
                    error_nonscalar();
                end
                if numel(var_current) ~= num_features
                    error_nonscalar();
                end
                min_current = min(var_current);
                max_current = max(var_current);
                min_new = p.Results.scale_between(1);
                max_new = p.Results.scale_between(2);
                data_normalized.(columns{i}) = ((min_new + max_new) ...
                    + (max_new - min_new) ...
                    .* (2 .* var_current - (min_current + max_current)) ...
                    ./ (max_current - min_current)) ./ 2;
            end
        end
    else
        
        if p.Results.centering
            for i = 1:numel(columns)
                var_current = data_normalized.(columns{i});
                if iscell(var_current)
                    try
                        var_current = cell2mat(var_current);
                    catch
                        error_nonscalar();
                    end
                    if numel(var_current) ~= num_features
                        error_nonscalar();
                    end
                    mean_current = mean(double(var_current));
                    data_normalized.(columns{i}) = ...
                        data_normalized.(columns{i}) - mean_current;
                end
            end
        end
        
        if p.Results.standardization
            for i = 1:numel(columns)
                var_current = data_normalized.(columns{i});
                if iscell(var_current)
                    try
                        var_current = cell2mat(var_current);
                    catch
                        error_nonscalar();
                    end
                    if numel(var_current) ~= num_features
                        error_nonscalar();
                    end
                    std_current = std(double(var_current));
                    data_normalized.(columns{i}) = ...
                        data_normalized.(columns{i}) ./ std_current;
                end
            end
        end
        
    end
    
end

function error_nonscalar()
error(['Querying one of the columns in properties_' ...
    ' returned a cell array. normalize_dataset ' ...
    'tried to convert this to a numeric array, ' ...
    'but was unsuccessful. This can happen if ' ...
    'a feature in properties_ is not a scalar ' ...
    'feature. Please check that all features are ' ...
    'scalar. If necessary, please use ' ...
    'filtering.extract_scalar_features.']);