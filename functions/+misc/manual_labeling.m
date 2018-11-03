function labels = manual_labeling(image_input, properties_, varargin)
% shows a randomized set of binary features from properties_, overlaid on 
% image_input and waits for a keypress. if you press a numeric key from 0
% to 9, manual_labeling treats that as a class label and concatenates it to
% a collection of labels. if you press 'q', no more features will be shown
% from image_input. returns labels, a table that has a column 'labels' that
% stores the extracted labels. this function is used to extract feature
% data for classification for e.g., shadowgraph particle detection.
% properties_ must contain linear pixel indices for the detections. this is
% normally stored in the 'pixelidxlist' column of the output of
% measurement.measure_particles.
%
% inputs:
%   image_input (image) - the image on which the features will be overlaid
%   properties_ (table) - a table of measurements on binary features. this
%       is normally produced by using measurement.measure_particles.
%   pixelidxlist (string) - name-value pair that specifies the column name
%       from which the linear pixel indices are drawn to render the
%       overlaid image. the default is 'pixelidxlist'.
%   overview (logical) - name-value pair that specifies whether to show an
%       overview image at the start of the feature loop. if true, raises
%       an overview image and allows for clicking on image regions where
%       positive features are suspected by the user. this facilitates
%       collecting positive features. the default is true.
%   max_features (integer-valued scalar) - the maximum number of features 
%       to be shown. the default is Inf, i.e., all features in properties_
%       will be shown (a feature is a row in properties_). use this to
%       limit the number of proposals in images in which too many
%       detections were produced. name-value pair.
%   shuffle_features (logical) - name-value pair that specifies whether to
%       shuffle the rows of properties, i.e., randomize sampling. if false,
%       the samples are drawn from properties_ in the order of their 'id'
%       property or row index. the default is true.
%   margin (integer-valued scalar) - name-value pair that specifies the
%       size of the margin around the detected objects to be drawn in
%       pixels. the default is 10 that means that a margin of 10 pixels in
%       all directions will be put on the image details shown, counted from
%       the extrema of the pixel indices of the detected object.
%
% outputs:
%   labels (table) - a subset of properties_ merged with the manual labels.
%       manual_labeling returns a concatenated table instead of just
%       returning the labels because normally not all features are labeled
%       and this facilitates the further processing of the data.

p = inputParser;
addParameter(p, 'overview', true, @islogical);
addParameter(p, 'pixelidxlist', 'pixelidxlist', @ischar);
addParameter(p, 'max_features', Inf, ...
    @(x)validateattributes(x, {'numeric'}, {'scalar', 'integer'}));
addParameter(p, 'shuffle_features', true, @islogical);
addParameter(p, 'null_label', 0, @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'integer'}));
addParameter(p, 'label_name', 'label', @ischar);
addParameter(p, 'margin', 10, @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'integer'}));
parse(p, varargin{:});

close all;

switch class(properties_)
    case 'table'
        num_features = size(properties_, 1);
    case 'struct'
        num_features = numel(properties_);
    otherwise
        error(['The properties_ argument must be a table or struct. ' ...
            'Please pass a variable that is one of these types.']);
end

image_input = data.cast_image(image_input);
image_size = size(image_input);
image_size = image_size(1:2);

properties_org = properties_;

if p.Results.overview
    pixelidxlist = properties_.(p.Results.pixelidxlist);
    imshow(image_input);
    hold on;
    px = []; py = [];
    mouseButton = 1;
    k = 0;
    while mouseButton == 1
        k = k + 1;
        [pcx, pcy, mouseButton] = ginput(1);
        plot(pcx, pcy, 'r+');
        text(pcx - 5, pcy - 5, num2str(k));
        px = cat(1, px, round(pcx));
        py = cat(1, py, round(pcy));
    end
    hold off;
    inds = sub2ind(image_size, py, px);
    feature_inds = false(num_features, 1);
    for ind_feature = 1:num_features
        if ~isempty(intersect(inds, pixelidxlist{ind_feature}))
            feature_inds(ind_feature) = true;
        end
    end
    properties_ = properties_(feature_inds, :);
    properties_discarded = properties_org(~feature_inds, :);
    num_features = size(properties_, 1);
end

last_feature = min(num_features, p.Results.max_features);

if p.Results.shuffle_features
    inds_selected = randsample(num_features, last_feature, false);
else
    inds_selected = 1:last_feature;
end

properties_ = properties_(inds_selected, :);

pixelidxlist = properties_.(p.Results.pixelidxlist);

cnt_label = 0;
labels = zeros(last_feature, 1);

end_loop = false;

for ind_feature = 1:last_feature
    feature_pixel_inds = pixelidxlist{ind_feature};
    blank = false(size(image_input, 1), size(image_input, 2));
    blank(feature_pixel_inds) = true;
    [ri, ci] = ind2sub(image_size, feature_pixel_inds);
    image_overlaid = overlay_image(image_input, ...
        bwperim(imfill(blank, 'holes')));
    imshow(image_overlaid);
    title(['press a numeric key to classify this feature as one of ' ...
        'classes 0..9 or press ''q'' to quit.']);
    xlim([min(ci)-p.Results.margin max(ci)+p.Results.margin]);
    ylim([min(ri)-p.Results.margin max(ri)+p.Results.margin]);
    drawnow;
    while true
        w = waitforbuttonpress;
        if w == 1
            key = get(gcf, 'currentcharacter');
            if strcmpi(key, 'i') || strcmpi(key, 'j')
                key = 'a';
            elseif strcmpi(key, 'q')
                end_loop = true;
                break;
            end
            label = str2double(key);
            if ~isnan(label)
                cnt_label = cnt_label + 1;
                labels(cnt_label) = label;
                break;
            end
        end
    end
    if end_loop
        break;
    end
end

if p.Results.overview
    properties_ = data.merge(properties_(1:cnt_label, :), ...
        properties_discarded, 'mode', 'table');
    labels = [labels(1:cnt_label); ...
        p.Results.null_label * ones(size(properties_discarded, 1), 1)];
    labels = data.merge(properties_, labels, 'mode', ...
        ['table:columns:' p.Results.label_name]);
else
    labels = data.merge(properties_(1:cnt_label, :), ...
        labels(1:cnt_label), 'mode', ...
        ['table:columns:' p.Results.label_name]);
end