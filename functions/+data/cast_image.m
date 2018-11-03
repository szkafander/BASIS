function image_output = cast_image(image_input, varargin)
% casts an image into an output format. this is used to rescale and display
% e.g., double, uint16, uint32, etc. images.
%
% inputs:
%   image_input (image) - the image to cast and/or rescale.
%   target_class (string) - name-value pair that specifies the class of the
%       output image. the default is 'uint8'. accepted values are valid
%       Matlab variable types or custom types reachable on the Matlab path.
%   scale (logical) - if true, cast_image tries to rescale the output image
%       so that it stretches across the valid range of its class. the
%       default is true.
%
% outputs:
%   image_output (image) - the cast image.

p = inputParser;
addParameter(p, 'target_class', 'uint8', @ischar);
addParameter(p, 'scale', true, @islogical);
parse(p, varargin{:});

target_class = p.Results.target_class;
scale = p.Results.scale;

if ismember('int', target_class)
    max_target = double(intmax(target_class));
elseif strcmpi(target_class, 'double')
    target_class = 'double';
    max_target = 1;
end

if isinteger(image_input)
    max_original = double(intmax(class(image_input)));
elseif isfloat(image_input)
    max_original = 1;
end

image_output = double(image_input);

if scale
    image_output = ...
        preprocessing.normalization.scale_to_range(image_output, [0 1]);
    image_output = image_output .* max_target;
else
    image_output = image_output ./ max_original .* max_target;
end

image_output = cast(image_output, target_class);