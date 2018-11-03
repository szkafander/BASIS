function image_inverted = invert_image(image_input, varargin)
% inverts an image while staying class-consistent. this function is more of
% a demonstration, not a really useful method.
%
% inputs:
%   image_input (image) - the image to be inverted
%   maximum (string) - name-value pair. accepted values: 'class' and
%       'current'. when 'class', invert_image produces max - image_input,
%       where max is the maximum value allowed by the class of image_input.
%       if image_input is a float or logical image, maximum is taken as 1.
%       the default is 'class'. when 'current', the maximum is the current
%       maximum value in image_input.
%
% outputs:
%   image_inverted (image) - the inverted image.

p = inputParser;
addRequired(p, 'image_input', @isimg);
addParameter(p, 'maximum', 'class', ...
    @(x)validateattributes(x, {'char'}, {'nonempty'}));
parse(p, image_input, varargin{:});

image_input = p.Results.image_input;
maximum = p.Results.maximum;

switch maximum
    case 'class'
        if isinteger(image_input)
            maximum = intmax(class(image_input));
        elseif isfloat(image_input) || islogical(image_input)
            maximum = 1;
        else
            error(['Image type not recognized. Accepted types are: ' ...
                'integer, float and logical types']);
        end
    case 'current'
        maximum = max(image_input(:));        
    otherwise
        error(['Incorrect value was passed for parameter ''maximum''. ' ...
            'Accepted values are: ''class'' and ''current''.']);
end

image_inverted = maximum - image_input;