function binary_ = hierarchic_detection(image_input, varargin)
% detects many, possibly overlapping features. returns a multi-channel
% binary image. every channel represents a level of detection. supports two
% detection heuristics: Maximally Stable Extremal Regions (MSER) and 
% multi-level thresholding ('fastPSV'). normally, the output must be
% further processed to remove overlapping regions.
%
% inputs:
%   image_input (image) - the input image
%   method (string) - name-value pair that is either 'mser' or 'fastpsv'.
%       the default is 'mser'.
%   binary_processing (function handle) - name-value pair that specifies an
%       optional function for processing the binary detection results
%       level-wise. the default is @identity (no processing).
%   num_levels (integer-valued scalar) - the number of levels for
%       multi-level thresholding when method is 'fastpsv'. the more levels,
%       the more features detected, but features in each level are more
%       correlated. the default is 10.
%   max_level (float scalar, 0..1) - the maximum threshold for multi-level
%       thresholding. the maximum threshold is calculated as
%       max(image_input(:)) * max_level. only relevant if method is 
%       'fastpsv'. the default is 0.7.
%   min_level (float scalar, 0..1) - the minimum threshold for multi-level
%       thresholding. the minimum threshold is calcualted as
%       max(image_input(:)) * min_level. only relevant if method is
%       'fastpsv'. the default is 0.15.
%   delta, max_area, min_area, max_variation, min_diversity,
%   bright_on_dark, dark_on_bright - respective MSER name-value pairs,
%       please see the documentation for the third party function vl_mser 
%       for details.
%   delete_boundary_objects (logical) - name-value pair, if true, objects
%       that touch the image boundary are removed from the detection. the
%       default is true.
%
% outputs:
%   binary_ (logical ndarray) - binary detections as an n-channel logical
%       image. each channel represents a level of detection. if method is
%       'mser', each level represents a level set. if method is 'fastpsv',
%       each level represents a threshold.

check_arg = @(x)validateattributes(x, {'numeric'}, {'scalar', 'integer'});

p = inputParser;
addParameter(p, 'method', 'mser', @ischar);
addParameter(p, 'requested_fields', {'image', 'pixelidxlist'}, @iscellstr);
addParameter(p, 'binary_processing', @identity, ...
    @(x)isa(x, 'function_handle'));
addParameter(p, 'num_levels', 10, ...
    @(x)validateattributes(x, {'numeric'}, {'scalar', 'integer'}));
addParameter(p, 'max_level', 0.7, check_arg);
addParameter(p, 'min_level', 0.15, check_arg);
addParameter(p, 'delta', 5, check_arg);
addParameter(p, 'max_area', 0.75, check_arg);
addParameter(p, 'min_area', [], check_arg);
addParameter(p, 'max_variation', 0.25, check_arg);
addParameter(p, 'min_diversity', 0.2, check_arg);
addParameter(p, 'bright_on_dark', false, @islogical);
addParameter(p, 'dark_on_bright', true, @islogical);
addParameter(p, 'delete_boundary_objects', true, @islogical);
parse(p, varargin{:});

min_area = p.Results.min_area;
if isempty(min_area)
    min_area = 3 / (size(image_input, 1) * size(image_input, 2));
end

bright_on_dark = p.Results.bright_on_dark;
if bright_on_dark
    bright_on_dark = 1;
else
    bright_on_dark = 0;
end

dark_on_bright = p.Results.dark_on_bright;
if dark_on_bright
    dark_on_bright = 1;
else
    dark_on_bright = 0;
end

switch p.Results.method
    case 'mser'
        seeds = vl_mser(image_input, ...
            'Delta', p.Results.delta, ...
            'MaxArea', p.Results.max_area, ...
            'MinArea', min_area, ...
            'MaxVariation', p.Results.max_variation, ...
            'MinDiversity', p.Results.min_diversity, ...
            'BrightOnDark', bright_on_dark, ...
            'DarkOnBright', dark_on_bright);
        binary_ = reduce_mser_features(image_input, seeds, ...
            p.Results.binary_processing);
    case 'fastpsv'
        binary_ = fastpsv(image_input, ...
            p.Results.num_levels, ...
            p.Results.min_level, ...
            p.Results.max_level, ...
            p.Results.binary_processing);
    otherwise
        error(['Unknown method was specified. Supported methods are: ' ...
            '''mser'' and ''fastpsv''. Please specify a valid method.']);
end

if p.Results.delete_boundary_objects
    for i = 1:size(binary_, 3)
        binary_(:,:,i) = filtering.delete_boundary_objects(binary_(:,:,i));
    end
end


function binary_ = reduce_mser_features(image_input, seeds, ...
    binary_processing)
ints = arrayfun(@(x)image_input(x), seeds);
unique_ints = unique(ints);
num_ints = numel(unique_ints);
binary_ = false(size(image_input, 1), size(image_input, 2), num_ints);
for i = 1:num_ints
    int_current = unique_ints(i);
    objects_current = seeds(ints == int_current);
    detection_current = bwconncomp(image_input <= int_current);
    blank = false(size(image_input));
    for j = 1:numel(objects_current)
        for k = 1:detection_current.NumObjects
            if ismember(objects_current(j), ...
                    detection_current.PixelIdxList{k})
                blank(detection_current.PixelIdxList{k}) = true;
            end
        end
    end
    binary_(:,:,i) = binary_processing(blank);
end


function binary_ = fastpsv(image_input, numLevels, minLevel, maxLevel, ...
    binary_processing)
levels = linspace(maxLevel, minLevel, numLevels);
w = size(image_input, 1); h = size(image_input, 2);
binary_ = false(w, h, numLevels);
max_int = max(image_input(:));
for i = 1:numLevels
    binary = image_input <= (max_int * levels(i));
    binary = binary_processing(binary);
    binary_(:,:,i) = binary;
end