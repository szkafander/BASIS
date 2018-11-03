function image_cropped = crop_image(image_input, bounding_box_corners, ...
    varargin)
% crops input image
%
% inputs:
%   image_input (image) - the input image. can have an arbitrary number of
%       channels and can be any type.
%   bounding_box_corners (1X4 numeric vector) - the bounding box
%       coordinates of the cropped image part. the order is [x0 x1 y0 y1].
%       NaN values are interpreted as the extrema image dimensions.
%   units (optional, 'absolute' or 'relative') - a mode string specifying
%       whether bounding box coordinates are absolute pixel coordinates or
%       relative to the image dimensions. if relative, 0 means the 1st
%       pixel and 1 means the last pixel of the given dimension.
%
% outputs:
%   image_cropped - the cropped image. retains all input image channels.

p = inputParser;
addParameter(p, 'units', 'absolute', @ischar);
parse(p, varargin{:});

if ~ismember(p.Results.units, {'absolute', 'relative'})
    error(['The ''units'' parameter must be either ''absolute'' or ' ...
        '''relative''.']);
end

num_rows = size(image_input, 1);
num_cols = size(image_input, 2);

if strcmpi(p.Results.units, 'relative')
    bounding_box_corners = round(bounding_box_corners .* ...
        [num_cols num_cols num_rows num_rows]);
end

defaults = [1 num_cols 1 num_rows];

ind_nan = isnan(bounding_box_corners);
bounding_box_corners(ind_nan) = defaults(ind_nan);

bounding_box_corners = max(1, bounding_box_corners);
bounding_box_corners(2) = min(num_cols, bounding_box_corners(2));
bounding_box_corners(4) = min(num_rows, bounding_box_corners(4));

image_cropped = image_input( ...
    bounding_box_corners(3) : bounding_box_corners(4), ...
    bounding_box_corners(1) : bounding_box_corners(2), :);