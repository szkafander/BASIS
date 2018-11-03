function properties_balanced = balance_dataset(properties_, varargin)
% balances the dataset properties_ via randomly sampling rows to ensure
% that all classes are approximately equally represented in
% properties_balanced. having a balanced dataset makes training 
% learning-based particle classifiers easier. in a pipeline, run this after
% feature normalization.
%
% inputs:
%   properties_ (table) - a table of features, typically obtained by using
%       misc.manual_labeling
%   labels (string) - name-value pair, name of the column in properties_
%       that holds the labels. the default is 'label'.
%   multiplier (float scalar) - the maximum number of classes kept will be 
%       multiplier X min_number, where min_number is the number of features
%       of the class with the fewest features. the default is 1.5.
%       name-value pair.
%
% outputs:
%   properties_balanced (table) - a filtered version of properties_ in
%       which the classes are balanced via randomly dropping features of
%       classes with too many features.

p = inputParser;
addParameter(p, 'labels', 'label', @ischar);
addParameter(p, 'multiplier', 1.5, ...
    @(x)validateattributes(x, {'numeric'}, {'scalar', 'nonnegative'}));
parse(p, varargin{:});

labels = properties_.(p.Results.labels);
unique_labels = unique(labels);
num_unique_labels = numel(unique_labels);
num_features = zeros(num_unique_labels, 1);

for i = 1:num_unique_labels
    num_features(i) = numel(find(labels == unique_labels(i)));
end

num_smallest_class = min(num_features);
max_class_size = ceil(num_smallest_class * p.Results.multiplier);

for i = 1:num_unique_labels
    inds = randsample(num_features(i), ...
        min(num_features(i), max_class_size), false);
    props_current = properties_(labels == unique_labels(i), :);
    if i == 1
        properties_balanced = props_current(inds, :);
    else
        properties_balanced = [properties_balanced; ...
            props_current(inds, :)];
    end
end