function binary_output = single_threshold(image_input, varargin)
% thresholds an image and produces a binary output image binary_output.
% thresholding is a binary operation where all pixels are converted to
% logical values based on whether they are below or above a set threshold
% intensity.
% 
% inputs:
%   image_input (image) - the image to be thresholded.
%   threshold (numeric) - name-value pair that specifies the threshold
%       intensity. single_threshold interprets the passed threshold value
%       as follows:
%           - if threshold_type is 'absolute', it is interpreted as an
%           absolute pixel intensity. if image_input is a double image
%           scaled between 0-1, single_threshold throws an error.
%           - if threshold_type is 'relative', single_threshold
%           interprets it as a ratio of the highest intensity. the highest
%           intensity is either the maximum value allowed by the class of
%           image_input or the actual maximum value in image_input.
%   threshold_type (string) - name-value pair. accepted values: 'absolute'
%       and 'relative'. if 'absolute', the threshold is interpreted as an
%       absolute pixel intensity. if 'relative', the threshold is
%       interpreted as a ratio of a maximum value.
%   maximum (string) - name-value pair that specifies whether the maximum
%       intensity used to calculate a relative threshold is the maximum
%       allowed value by the class of image_input ('class') or the current
%       maximum value in image_input ('current'). if 'class' and
%       image_input is a float, an error is thrown.
%   direction (string) - name-value pair that specifies whether pixel
%       intensities above or below the threshold will be true. accepted
%       values are: 'object_below_threshold' and 'object_above_threshold'.
%       the default is 'object_below_threshold'.
%   delete_boundary_objects (logical) - name-value pair, if true, objects
%       that touch the image boundary are removed from the detection. the
%       default is true.
%
% outputs:
%   binary_output (logical image) - the thresholded binary image.

p = inputParser;
addRequired(p, 'image_input', @isimg);
addParameter(p, 'threshold', 128, ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'nonnegative', 'scalar'}));
addParameter(p, 'threshold_type', 'absolute', @ischar);
addParameter(p, 'maximum', 'current', @ischar);
addParameter(p, 'direction', 'object_below_threshold', @ischar);
addParameter(p, 'delete_boundary_objects', true, @islogical);
parse(p, image_input, varargin{:});

image_input = p.Results.image_input;
threshold_ = p.Results.threshold;
direction_ = p.Results.direction;
threshold_type = p.Results.threshold_type;
maximum_ = p.Results.maximum;

switch threshold_type
    case 'relative'
        switch maximum_
            case 'current'
                threshold_ = double(max(image_input(:))) * threshold_;
            case 'class'
                if isinteger(image_input)
                    threshold_ = double(intmax(class(image_input))) ...
                        * threshold_;
                else
                    error(['A threshold relative to the class maximum ' ...
                        'value was specified and a float image was ' ...
                        'passed. It makes little sense to request a ' ...
                        'threshold relative to the maximum of a float ' ...
                        'type. Please use the ''current'' maximum ' ...
                        'setting or specify an absolute threshold']);
                end
        end
end    

validate_mode(direction_);

switch direction_
    case 'object_below_threshold'
        binary_output = image_input <= threshold_;
    case 'object_above_threshold'
        binary_output = image_input >= threshold_;
end

if p.Results.delete_boundary_objects
    binary_output = filtering.delete_boundary_objects(binary_output);
end
        

function validate_mode(mode)
valid_modes = {'object_below_threshold', 'object_above_threshold'};
if ~ismember(mode, valid_modes)
    error(['Invalid direction. Valid direction values are: ' ...
        strjoin(valid_modes, ', ') '.']);
end