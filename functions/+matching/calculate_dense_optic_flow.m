function displacement = calculate_dense_optic_flow(image_1, image_2, ...
    varargin)
% calculates dense optic flow between image_1 and image_2. uses C. Liu's
% optic flow algorithm that is based on T Brox, A Bruhn, N Papenberg, 
% J Weickert: High accuracy optical flow estimation based on a theory for 
% warping, European conference on computer vision, pp. 25-36, 2004.
% default parameters optimized for flame emission and absorption images.
%
% inputs:
%   image_1, image_2 (images) - two images between which the optic flow
%       will be calculated. must be grayscale. if color images are passed,
%       calculate_dense_optic_flow converts them to grayscale. if
%       multi-channel images are passed, calculate_dense_optic_flow selects
%       the channel channel and uses that from each image. image sizes must
%       match.
%   alpha, ratio, min_width, num_outer_iterations, num_inner_iterations,
%       num_SOR_iterations - parameters of the optic flow algorithm. please 
%       see Coarse2FineTwoFrames for details.
%   channel (integer-valued scalar) - the index of the channel to use from
%       multi-channel images.
%
% outputs:
%   displacement (2-channel float image) - an array of size wXhX2, where w
%       and h are the width and height of image_1 and image_2.
%       displacement(:,:,1) stores x displacements and displacement(:,:,2)
%       stores y displacement.

check_arg = @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'nonnegative'});
check_integer_arg = @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'integer', 'nonnegative'});

p = inputParser;
addParameter(p, 'alpha', 0.075, check_arg);
addParameter(p, 'ratio', 0.75, check_arg);
addParameter(p, 'min_width', 20, check_integer_arg);
addParameter(p, 'num_outer_iterations', 5, check_integer_arg);
addParameter(p, 'num_inner_iterations', 1, check_integer_arg);
addParameter(p, 'num_SOR_iterations', 3, check_integer_arg);
addParameter(p, 'channel', 1, check_integer_arg);
parse(p, varargin{:});

if size(image_1, 3) == 3
    image_1 = rgb2gray(image_1);
elseif size(image_1) ~= 1
    image_1 = image_1(:,:,p.Results.channel);
end

if size(image_2, 3) == 3
    image_2 = rgb2gray(image_2);
elseif size(image_2) ~= 1
    image_2 = image_2(:,:,p.Results.channel);
end

parameters = [p.Results.alpha, p.Results.ratio, p.Results.min_width, ...
    p.Results.num_outer_iterations, p.Results.num_inner_iterations, ...
    p.Results.num_SOR_iterations];

[dx, dy, ~] = Coarse2FineTwoFrames(image_1, image_2, parameters);

displacement = cat(3, dx, dy);