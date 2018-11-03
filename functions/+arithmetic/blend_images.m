function blended_image = blend_images(blending_function, varargin)
% "blends" images by applying a blending function to subsequent image
% arguments. this function operates similarly to e.g., Python's reduce
% function. if the blending function is f(a,b), then blend_images(@f,
% x, y, z) outputs f(f(x, y), z).
%
% inputs:
%   blending_function (function handle) - the function to apply to
%       subsequent images.
%   images - a variable number of input images or other data.
%
% outputs:
%   blended_image - the result of subsequent applications of
%       blending_function.

for i = 1:numel(varargin)
    if i == 1
        blended_image = varargin{i};
    else
        blended_image = blending_function(blended_image, varargin{i});
    end
end