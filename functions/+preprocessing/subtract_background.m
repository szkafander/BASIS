function image_processed = subtract_background(image_input, varargin)
% subtracts image background and returns the background-subtracted image.
% the background-subtracted image normally looks inverted. image background
% is estimated as a low-pass filtered version of image_input.
%
% inputs:
%   image_input (image) - the image from which its estimated background
%       will be subtracted.
%   background_scale (numeric scalar) - the scale of the Gaussian kernel
%       of the low-pass filter that is used to estimate image background.
%
% outputs:
%   image_processed (image) - the background-subtracted image.

p = inputParser;
addRequired(p, 'image_input', @isimg);
addParameter(p, 'background_scale', 1, ...
    @(x)validateattributes(x, {'numeric'}, {'nonnegative'}));
parse(p, image_input, varargin{:});

image_input = p.Results.image_input;
bg_scale = p.Results.background_scale;

background = preprocessing.spatial_filtering.smooth_image( ...
    image_input, 'scale', bg_scale);
image_processed = background - image_input;