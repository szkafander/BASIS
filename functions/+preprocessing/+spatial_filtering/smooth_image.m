function image_smoothed = smooth_image(image_input, varargin)
% smooths the image using Gaussian low-pass filtering. figures out kernel
% size based on the provided filter scale in terms of the standard
% deviation of the Gaussian kernel.
%
% inputs:
%   image_input (image) - the image to be smoothed
%   scale (numeric scalar) - the scale of smoothing, expressed as the
%       standard deviation of the Gaussian kernel
%
% outputs:
%   image_smoothed (image) - the smoothed image. the class of image_input
%       is retained.

p = inputParser;
addParameter(p, 'scale', 1, @(x)validateattributes(x, {'numeric'}, ...
    {'nonnegative', 'scalar'}));
parse(p, varargin{:});

scale_ = p.Results.scale;

filtersize = ceil(6 * scale_);
if mod(filtersize, 2) == 0
    filtersize = filtersize + 1;
end

image_smoothed = imfilter(image_input, ...
    fspecial('gaussian', filtersize, scale_), 'replicate');