function phase_ = extract_phase(image_input, varargin)
% extracts monogenic phase. monogenic phase is a good feature to be used
% when an intensity-independent gradient magnitude descriptor is needed. in
% other words, when you want to detect edges in an image that has an uneven
% background, use this. extract_phase uses the phasecongmono function of
% Peter Kovesi. type open phasecongmono in the command line to see the
% details and license.
%
% inputs:
%   image_input (image) - the image from which monogenic phase is
%      extracted.
%   varargin - various optional arguments to be passed to phasecongmono.

[phase_, ~, ~, ~] = phasecongmono(image_input, varargin{:});