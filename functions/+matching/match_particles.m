function matching_indices = match_particles(properties_1, properties_2, ...
    varargin)
% a naive particle matcher. finds matching, possibly displaced particles
% between two images, represented by two property tables, properties_1 and
% properties_2. searches for all matching objects, then selects the best
% matching based on criteria. both properties tables should contain at
% least a column that stores particle position, i.e., the 'centroid'.
%
% inputs:
%   properties_1 (table) - table of particle properties, typically
%       extracted by using measurement.measure_particles or similar.
%       pertains the the first image frame.
%   properties_2 (table) - table of particle properties, typically
%       extracted by using measurement.measure_particles or similar.
%       pertains to the second image frame. ideally, the column names of
%       properties_1 and properties_2 are the same or at least fully
%       overlap.
%   descriptors (cell of strings) - name-value pair, specifies the
%       descriptors based on which final similarity is computed. all of
%       these must be columns in both properties_1 and properties_2. if
%       passing multiple descriptors, the mean absolute similarity will be
%       computed. the default is {'area'}.
%   constrained_descriptors(cell of strings) - name-value pair, specifies 
%       descriptors for which similarity criteria are defined. these must 
%       be columns in both properties_1 and properties_2. the default is 
%       {'area'}. note that features can be array-like, but their number of
%       elements must be the same featurewise.
%   criteria (cell of function handles) - name-value pair, specifies the
%       matching criteria in terms of anonymous functions or function
%       handles. for simple similarity metrics, please use
%       data.similarity. the default is {@(x,y)data.similarity(x, y, 
%       'type', 'relative')<0.1}. the functions must be able
%       to handle vector inputs. the functions must return a logical
%       variable. matches for which any of the criteria return false will
%       be excluded from further search. the most similar of the remaining
%       features will be matched.
%   search_window (4-vector) - name-value pair, specifies the search window
%       around each feature in properties_1 to which features are matched
%       in properties_2. the window is defined in terms of a typical
%       displacement [ux uy] and a window size around the displaced
%       position, [wx wy]. the search window is therefore defined by the
%       4-vector [ux uy wx wy]. the default is [0 0 25 25].
%   positions (string) - name-value pair, specifies the column name that
%       holds particle positions in both properties_1 and properties_2.
%       note that positions must be represented by a single coordinate. the
%       default is 'centroid'.
%   index_names (cell of strings) - name-value pair, specifies the name of
%       the columns in matching_indices that hold the matching indices.
%       should have (at least) 2 elements. the default is {'ind_1',
%       'ind_2'}.
%
% outputs:
%   matching_indices (table) - table that holds two columns. each column
%       stores row indices, indexing properties_1 and properties_2,
%       respectively. these indices represent the found matches.

p = inputParser;
addParameter(p, 'positions', 'centroid', @ischar);
addParameter(p, 'search_window', [0 0 25 25], ...
    @(x)validateattributes(x, {'numeric'}, {'vector', 'numel', 4}));
addParameter(p, 'descriptors', {'area'}, @iscellstr);
addParameter(p, 'constrained_descriptors', {'area'}, @iscellstr);
addParameter(p, 'criteria', ...
    {@(x,y)data.similarity(x, y, 'type', 'relative')<0.1}, @iscell);
addParameter(p, 'index_names', {'ind_1', 'ind_2'}, @iscellstr);
parse(p, varargin{:});

positions_1 = properties_1.(p.Results.positions);
positions_2 = properties_2.(p.Results.positions);

search_window = p.Results.search_window;
descriptors = p.Results.descriptors;
constrained_descriptors = p.Results.constrained_descriptors;
criteria = p.Results.criteria;

inds_descriptors_1 = ismember(properties_1.Properties.VariableNames, ...
    descriptors);
inds_descriptors_2 = ismember(properties_2.Properties.VariableNames, ...
    descriptors);
descriptors_1 = table2array(properties_1(:, inds_descriptors_1));
descriptors_2 = table2array(properties_2(:, inds_descriptors_2));

num_features_1 = size(properties_1, 1);
num_features_2 = size(properties_2, 1);

search_window_matrix = repmat(search_window(3:4), [num_features_2 1]) .^ 2;

ind_1 = (1:num_features_1)';
ind_2 = zeros(num_features_1, 1);

for ind_feature = 1:num_features_1
    position_current = positions_1(ind_feature, :);
    displaced_current = position_current + search_window(1:2);
    distances = (positions_2 ...
        - repmat(displaced_current, [num_features_2 1])).^2;
    inds_possible = all(distances < search_window_matrix, 2);
    for ind_descriptor = 1:numel(constrained_descriptors)
        property_current = ...
            properties_1.(constrained_descriptors{ind_descriptor});
        properties_possible = ...
            properties_2(inds_possible, :).( ...
            constrained_descriptors{ind_descriptor});
        criterion = criteria{ind_descriptor};
        criterion_eval = criterion(property_current, properties_possible);
        inds_possible = inds_possible & criterion_eval(:);
    end
    lininds_possible = find(inds_possible);
    descriptors_current = descriptors_1(ind_feature, :);
    descriptors_possible = descriptors_2(inds_possible, :);
    similarities = data.similarity(descriptors_current, ...
        descriptors_possible);
    [~, ind_most_similar] = min(similarities);
    ind_2(ind_feature) = lininds_possible(ind_most_similar);
end

matching_indices = struct2table(struct(p.Results.index_names{1}, ind_1, ...
    p.Results.index_names{2}, ind_2));