function coherence = extract_coherence(image_input, varargin)
% extracts the spatial coherence of image_input. coherence is a scalar map
% with values between 0 and 1. a value of 1 means that locally, the image
% features are all aligned along a single director vector. 0 means that the
% local image orientation does not have a preferred director vector. this
% is a useful feature when detecting oriented image features.
%
% inputs:
%   image_input (image) - the input image from which coherence is
%       extracted.
%   scale (numeric scalar) - name-value pair, specifies the scale over
%       which local orientations are analyzed. scale is in terms of the
%       standard deviation of the Gaussian kernel used to smoothed the
%       image gradient. if omitted, a default of 0.2% of the image size is
%       used. image size is calculated as the geometric mean of image width
%       and image height.
%
% outputs:
%   coherence (float array) - the coherence map. has the same dimensions
%       as image_input.

p = inputParser;
addParameter(p, 'scale', [], ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'nonnegative'}));
parse(p);
scale_ = p.Results.scale;

if isempty(scale_)
    scale_ = 0.002 * sqrt(sum(size(image_input).^2));
end

[gx, gy] = gradient(double(image_input));

filtersize = max(1, ceil(6 * scale_));
if mod(filtersize, 2) == 0
    filtersize = filtersize + 1;
end

gxgx = imfilter(gx.*gx, fspecial('gaussian', filtersize, scale_));
gygy = imfilter(gy.*gy, fspecial('gaussian', filtersize, scale_));
gxgy = imfilter(gx.*gy, fspecial('gaussian', filtersize, scale_));

lambda1 = 0.5 .* ((gxgx + gygy) + sqrt(4.*gxgy.*gxgy + (gxgx - gygy).^2));
lambda2 = 0.5 .* ((gxgx + gygy) - sqrt(4.*gxgy.*gxgy + (gxgx - gygy).^2));

coherence = ((lambda1 - lambda2) ./ (lambda1 + lambda2)).^2;