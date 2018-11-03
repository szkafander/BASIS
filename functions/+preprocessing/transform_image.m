function image_transformed = transform_image(image_input, ...
    transformation_matrix, varargin)
% applies a spatial transformation to the image image_input. enforces
% the spatial referencing of the frame of image_input by default.
%
% inputs:
%   image_input (image) - the image to be transformed
%   spatial_referencing (logical) - name-value pair. if true, the spatial
%       reference frame of image_input is retained in image_transformed.
%       this is normally the way you want to use Matlab's imwarp.
%
% outputs:
%   image_transformed (image) - the transformed image.
%
% note: for information about image transformations and imwarp, type help
% imwarp in the command line.

p = inputParser;
addParameter(p, 'spatial_referencing', true, @islogical);
parse(p, varargin{:});

if p.Results.spatial_referencing
    spatial_reference = imref2d(size(image_input));
    image_transformed = imwarp(image_input, transformation_matrix, ...
        'OutputView', spatial_reference);
else
    image_transformed = imwarp(image_input, transformation_matrix);
end