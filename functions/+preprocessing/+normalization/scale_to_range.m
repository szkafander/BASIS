function image_rescaled = scale_to_range(image_input, varargin)
% rescales image_input linearly to stretch across an intensity range. the
% rescaled image retains image_input's class. values are rounded by the
% type casting conventions of Matlab.
%
% inputs:
%   image_input (image) - the input image to rescale.
%   range (numeric 2-vector) - the intensity range that image_input will
%       stretch across. if omitted, scale_to_range scales between [0 max]
%       where max is the maximum value allowed by the class of image_input.
%       if image_input is float, a maximum of 1 is assumed.
%
% outputs:
%   image_rescaled (image) - the rescaled image.

p = inputParser;
addRequired(p, 'image_input');
addOptional(p, 'range', []);
parse(p, image_input, varargin{:});

image_input = p.Results.image_input;
range = p.Results.range;

if isempty(range)
    if isinteger(image_input)
        range = intmax(class(image_input));
    else
        range = 1;
    end
end

if ~isimg(image_input)
    error('Input is not an image.');
end

image_rescaled = double(image_input);
image_rescaled = image_rescaled - min(image_rescaled(:));
image_rescaled = image_rescaled ./ max(image_rescaled(:));
image_rescaled = image_rescaled .* (range(2) - range(1));
image_rescaled = image_rescaled + range(1);
image_rescaled = cast(image_rescaled, class(image_input));