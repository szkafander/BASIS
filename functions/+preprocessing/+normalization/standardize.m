function image_standardized = standardize(image_input)
% performs standardization by subtracting the mean and dividing by the 
% standard deviation. the returned image image_standardized does not retain
% the class of image_input. the class of image_standardized is double.
%
% inputs:
%   image_input (image) - the input image
%
% outputs:
%   image_standardized (image) - the standardized image

if ~isimg(image_input)
    error('Input is not an image.');
end

image_standardized = double(image_input);
image_standardized = image_standardized - mean(image_standardized(:));
image_standardized = image_standardized ./ std(image_standardized(:));