function status = show_displacement(image_1, image_2, displacement, ...
    varargin)
% displays displacement a field overlaid on an image pair. this function is
% used to visualize extracted dense optic flow. the displacement field is
% displayed using Matlab's quiver function.
%
% inputs:
%   image_1, image_2 (image) - two images that will be overlaid using
%       Matlab's imoverlay function. typically, these are the two images
%       from which the optic flow displacement is extracted.
%   displacement (2-channel numeric array) - the displacement field as a
%       numeric array with a size of wXhX2, where w and h are the size of
%       image_1 and image_2. the first channel contains the x coordinate of
%       the displacement and the second channel contains the y coordinate
%       of the displacement.
%   subsampling (integer-valued scalar) - name-value pair, specifies the
%       subsampling of the displacement field. this is used because dense
%       optic flow is computed pixelwise. one line per pixel is normally
%       too crowded. the default is 10 that corresponds to displaying every
%       10th vector.
%   figure (integer-valued scalar) - name-value pair, the number of figure 
%       window to plot to. the default is 1.
%
% outputs:
%   status (logical) - true if plotting is succesful

p = inputParser;
addParameter(p, 'subsampling', 10, ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'integer', 'positive'}));
addParameter(p, 'figure', 1, ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'integer', 'nonnegative'}));
parse(p, varargin{:});

[x, y] = meshgrid(1:size(image_1, 2), 1:size(image_1, 1));

figure(p.Results.figure);

s = p.Results.subsampling;

hold off;
imshowpair(image_1, image_2); hold on;
quiver(x(1:s:end, 1:s:end), y(1:s:end, 1:s:end), ...
    displacement(1:s:end, 1:s:end, 1), displacement(1:s:end, 1:s:end, 2));

drawnow;

status = true;