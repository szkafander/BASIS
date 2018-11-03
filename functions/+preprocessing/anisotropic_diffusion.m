function image_filtered = anisotropic_diffusion(image_input, varargin)
% carries out denoising using anisotropic diffusion. this is a wrapper to
% Peter Kovesi's anisodiff function. works with multi-channel images as
% well. default values are provided for all parameters. otherwise see
% thirdparty\kovesi\anisodiff.
%
% inputs:
%   image_input (image) - the image to be denoised. can be a multi-channel
%       image, in which case anisotropic_diffusion operates channelwise.
%   num_iter, kappa, lambda, option - parameters of Kovesi's anisodiff.
%       please see thirdparty\kovesi\anisodiff for a description. default
%       values are 200, 1, 0.15 and 2, respectively. these values work well
%       for shadowgraph preprocessing.
%
% outputs:
%   image_filtered (image) - the denoised image. retains the class of
%       image_input.

p = inputParser;
addParameter(p, 'num_iter', 200, ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'integer', 'positive'}));
addParameter(p, 'kappa', 1, ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'positive'}));
addParameter(p, 'lambda', 0.15, ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'positive'}));
addParameter(p, 'option', 2, ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'integer', 'positive'}));
parse(p, varargin{:});

num_channels = size(image_input, 3);
image_filtered = data.cast_image(zeros(size(image_input)), ...
    'target_class', class(image_input), 'scale', false);

for ind_channel = 1:num_channels
    image_filtered(:,:,ind_channel) = anisodiff( ...
        image_input(:,:,ind_channel), ...
        p.Results.num_iter, p.Results.kappa, p.Results.lambda, ...
        p.Results.option);
end