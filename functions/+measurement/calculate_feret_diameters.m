function feret_diameters = calculate_feret_diameters(properties_, varargin)
% measures the maximum Feret diameter of a number of binary image objects.
% note that the calculation is somewhat expensive, so try to factor it
% after all filtering.
%
% inputs:
%   properties_ (table, struct or cell) - list of binary images to
%       quantify. if properties_ is a table or struct,
%       measure_feret_diameter will look for a field or column name
%       'images' that contain the binary images. by default, 'images'
%       is 'image'. it is assumed that each element in properties_ is a
%       binary image with exactly one connected component formed by true 
%       values in it.
%   thetas (optional parameter, numeric array) - angles in degrees at which
%       the Feret diameter is calculated. default: 0, 1, 2 ... 180.
%   images (optional parameter, string) - if properties_ is a table or
%       struct, the string passed with the images parameter is the field or
%       column by which the binary images to be measured are stored.
%
% outputs:
%   feret_diameters (numeric column vector) - maximum Feret diameters for
%       the passed binary images.

p = inputParser;
addParameter(p, 'thetas', linspace(0, 180, 181), ...
    @(x)validateattributes(x, {'numeric'}, {}));
addParameter(p, 'images', 'image', @ischar);
parse(p, varargin{:});

if istable(properties_)
    if ismember('image', properties_.Properties.VariableNames)
        properties_ = properties_.image;
    end
elseif isstruct(properties_)
    if isfield(properties_, 'image')
        properties_ = properties_.image;
    end
end

feret_diameters = zeros(size(properties_, 1), 1);
for ind_subimage = 1:size(properties_, 1)
    feret_diameters(ind_subimage) = max( ...
        imFeretDiameter(properties_{ind_subimage}, ...
        p.Results.thetas));
end