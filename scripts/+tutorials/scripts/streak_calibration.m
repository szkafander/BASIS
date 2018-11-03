%% streak calibration code
% hit ctrl+enter while highlighting a cell to run it.
% comments explain the code.

%% the following demonstrates an example calibration pipeline for streak
% image processing. this tutorial assumes proper knowledge of the
% underlying theory: radiative heat transfer, optics and stereo vision.

%% stereo calibration
% refer to the documentation of the Camera Calibration Toolbox (CCT) for 
% Matlab. the toolbox is available here:
% http://www.vision.caltech.edu/bouguetj/calib_doc/ and is bundled with
% this package as a thirdparty application.
% all functions of the streak processing package have been built around
% CCT-format calibration data. this cell simply shows how to export data
% from a calibration session in CCT to .mat files that hold variable names
% that are compatible with streak_demo.m.
% note: most of this code is part of CCT. please see the license file of
% CCT for licensing questions.

% carry out stereo calibration following the documentation for CCT here,
% preferrably starting with an empty Matlab workspace. this will result in
% a workspace that has the necessary variables to run the following script.

% note: it is entirely possible to use another method for stereo
% calibration. as long as the rectification and stereo calibration data is
% consistent with streak processing functions, everything will work. if
% not, streak processing functions must be modified so that they can handle
% the new format.

% note: unfortunately it is not possible to include a completely automated
% script for camera calibration as a tutorial. in the original work, we
% used CCT and that requires manual work. however, some calibration images
% have been bundled as examples. the following are some general
% guidelines for stereo calibration:
%   1. follow CCT's guidelines on creating and printing out checkerboard
%       patterns or download their pre-made pattern (see CCT documentation)
%   2. use the exact same stereo rig for calibration and measurements
%   3. pay special attention to use the same image preprocessing pipeline
%       when processing calibration images and streak images
%   4. minimize image noise in calibration images. unlike streak images,
%       you have good control over the imaging conditions that are used to
%       acquire stereo calibration images. mount the checkerboard and use
%       long exposure if possible. use supplementary lighting to improve
%       image quality.
%   5. it is not necessary to use the exact same camera settings for stereo
%       calibration and streak imaging. leverage this to further improve
%       stereo calibration images: i.e., use a higher f-stop to improve the
%       depth of field so that no defocusing occurs in calibration images.

% after running the complete stereo calibration session, run the following
% code:

% calculation from CCT begins here
R = rodrigues(om);

% Bring the 2 cameras in the same orientation by rotating them "minimally": 
r_r = rodrigues(-om/2);
r_l = r_r';
t = r_r * T;

% Rotate both cameras so as to bring the translation vector in alignment 
% with the (1;0;0) axis:
if abs(t(1)) > abs(t(2))
    type_stereo = 0;
    uu = [1;0;0]; % Horizontal epipolar lines
else
    type_stereo = 1;
    uu = [0;1;0]; % Vertical epipolar lines
end;
if dot(uu,t)<0
    uu = -uu; % Swtich side of the vector 
end;
ww = cross(t,uu);
ww = ww/norm(ww);
ww = acos(abs(dot(t,uu))/(norm(t)*norm(uu)))*ww;
R2 = rodrigues(ww);

% Global rotations to be applied to both views:
R_R = R2 * r_r;
R_L = R2 * r_l;

% The resulting rigid motion between the two cameras after image rotations 
% (substitutes of om, R and T):
R_new = eye(3);
om_new = zeros(3,1);
T_new = R_R*T;

% Computation of the *new* intrinsic parameters for both left and right 
% cameras:

% Vertical focal length *MUST* be the same for both images (here, we are 
% trying to find a focal length that retains as much information contained
% in the original distorted images):
if kc_left(1) < 0
    fc_y_left_new = fc_left(2) ...
        * (1 + kc_left(1)*(nx^2 + ny^2)/(4*fc_left(2)^2));
else
    fc_y_left_new = fc_left(2);
end;
if kc_right(1) < 0
    fc_y_right_new = fc_right(2) ...
        * (1 + kc_right(1)*(nx^2 + ny^2)/(4*fc_right(2)^2));
else
    fc_y_right_new = fc_right(2);
end;
fc_y_new = min(fc_y_left_new,fc_y_right_new);

% For simplicity, let's pick the same value for the horizontal focal 
% length as the vertical focal length (resulting into square pixels):
fc_left_new = round([fc_y_new;fc_y_new]);
fc_right_new = round([fc_y_new;fc_y_new]);

% Select the new principal points to maximize the visible area in the 
% rectified images

cc_left_new = [(nx-1)/2;(ny-1)/2] - mean(project_points2( ...
    [normalize_pixel([0  nx-1 nx-1 0; 0 0 ny-1 ny-1],fc_left,cc_left, ...
    kc_left,alpha_c_left);[1 1 1 1]],rodrigues(R_L),zeros(3,1), ...
    fc_left_new,[0;0],zeros(5,1),0),2);
cc_right_new = [(nx-1)/2;(ny-1)/2] - mean(project_points2( ...
    [normalize_pixel([0  nx-1 nx-1 0; 0 0 ny-1 ny-1],fc_right,cc_right, ...
    kc_right,alpha_c_right);[1 1 1 1]],rodrigues(R_R),zeros(3,1), ...
    fc_right_new,[0;0],zeros(5,1),0),2);

% For simplicity, set the principal points for both cameras to be the 
% average of the two principal points.
if ~type_stereo
    %-- Horizontal stereo
    cc_y_new = (cc_left_new(2) + cc_right_new(2))/2;
    cc_left_new = [cc_left_new(1);cc_y_new];
    cc_right_new = [cc_right_new(1);cc_y_new];
else
    %-- Vertical stereo
    cc_x_new = (cc_left_new(1) + cc_right_new(1))/2;
    cc_left_new = [cc_x_new;cc_left_new(2)];
    cc_right_new = [cc_x_new;cc_right_new(2)];
end;

% Of course, we do not want any skew or distortion after rectification:
alpha_c_left_new = 0;
alpha_c_right_new = 0;
kc_left_new = zeros(5,1);
kc_right_new = zeros(5,1);

% The resulting left and right camera matrices:
KK_left_new = [fc_left_new(1) fc_left_new(1)*alpha_c_left_new ...
    cc_left_new(1);0 fc_left_new(2) cc_left_new(2); 0 0 1];
KK_right_new = [fc_right_new(1) fc_right_new(1)*alpha_c_right ...
    cc_right_new(1);0 fc_right_new(2) cc_right_new(2); 0 0 1];

% The sizes of the images are the same:
nx_right_new = nx;
ny_right_new = ny;
nx_left_new = nx;
ny_left_new = ny;

% Let's rectify the entire set of calibration images:
% Pre-compute the necessary indices and blending coefficients to enable 
% quick rectification: 
[~,ind_new_left,ind_1_left,ind_2_left,ind_3_left, ...
    ind_4_left,a1_left,a2_left,a3_left,a4_left] = ...
    rect_index(zeros(ny,nx),R_L,fc_left,cc_left,kc_left,alpha_c_left, ...
    KK_left_new);
[Irec_junk_left,ind_new_right,ind_1_right,ind_2_right,ind_3_right, ...
    ind_4_right,a1_right,a2_right,a3_right,a4_right] =  ...
    rect_index(zeros(ny,nx),R_R,fc_right,cc_right,kc_right, ...
    alpha_c_right,KK_right_new);

% here starts the code that wraps all data in a format that is compatible
% with streak_demo.m

% split parameter - stereo images used for streak_demo are single-sensor
% stereo images. this means that two views were recorded on a single image
% sensor using a stereo beamsplitter system. the following parameter is the
% X coordinate that separates the two views, **after the resizing of the
% images**
split = 1263;

% resize - this is the resize factor that was used for calibration in with
% the data used in streak_demo.m
resize = 0.5;

% this is the rectification data wrapped in a Matlab struct
rectification_data = struct('nx',{},'ny',{},'ind_new_left',{},'ind_new_right', {}, ...
    'ind_1_left',{},'ind_2_left',{},'ind_3_left',{},'ind_4_left',{}, ...
    'ind_1_right',{},'ind_2_right',{},'ind_3_right',{},'ind_4_right',{}, ...
    'a1_left',{},'a2_left',{},'a3_left',{},'a4_left',{},'a1_right',{}, ...
    'a2_right',{},'a3_right',{},'a4_right',{},'resize',{},'split',{});
rectification_data(1).nx = nx;
rectification_data(1).ny = ny;
rectification_data(1).ind_1_left = ind_1_left;
rectification_data(1).ind_1_right = ind_1_right;
rectification_data(1).ind_2_left = ind_2_left;
rectification_data(1).ind_2_right = ind_2_right;
rectification_data(1).ind_3_left = ind_3_left;
rectification_data(1).ind_3_right = ind_3_right;
rectification_data(1).ind_4_left = ind_4_left;
rectification_data(1).ind_4_right = ind_4_right;
rectification_data(1).a1_left = a1_left;
rectification_data(1).a1_right = a1_right;
rectification_data(1).a2_left = a2_left;
rectification_data(1).a2_right = a2_right;
rectification_data(1).a3_left = a3_left;
rectification_data(1).a3_right = a3_right;
rectification_data(1).a4_left = a4_left;
rectification_data(1).a4_right = a4_right;
rectification_data(1).ind_new_left = ind_new_left;
rectification_data(1).ind_new_right = ind_new_right;
rectification_data(1).resize = resize;
rectification_data(1).split = split;

% this is the stereo data that streak_demo.m uses
stereo_calibration = struct( ...
    'R_new', R_new, ...
    'om_new', om_new, ...
    'T_new', T_new, ...
    'fc_left_new', fc_left_new, ...
    'fc_right_new', fc_right_new, ...
    'cc_left_new', cc_left_new, ...
    'cc_right_new', cc_right_new, ...
    'kc_left_new', kc_left_new, ...
    'kc_right_new', kc_right_new, ...
    'KK_left_new', KK_left_new, ...
    'KK_right_new', KK_right_new, ...
    'alpha_c_left_new', alpha_c_left_new, ...
    'alpha_c_right_new', alpha_c_right_new, ...
    'nx_right_new', nx_right_new, ...
    'ny_right_new', ny_right_new, ...
    'nx_left_new', nx_left_new, ...
    'ny_left_new', ny_left_new);

% this is the 'misc' datafield streak_demo.m uses
misc = struct('resize', resize, 'split', split);

%% intensity calibration
% the following demonstrates the basics of intensity calibration necessary
% for streak image processing.
% the pipeline followed here was the following:
%   1. obtain calibration images using a tungsten ribbon filament lamp
%   2. extract counts from those images
%   3. calculate calibration curves for relating counts to radiant power
%       and counts to incident radiant energy
%   4. calculate a calibration curve to relate a color ratio (red/green 
%       used here) to graybody temperature
% regarding how streak temperature and size are computed, please refer to
% the pyrometry paper (papers\pyrometry.pdf)

% note: some image sensors output image data that are encoded or
% compressed. it depends on the camera and sensor model. in the original
% work, a Nikon D5100 was used. the sensor of the D5100 outputs raw images
% that are 16-bit linear data encoded into 12-bit nonlinear data using a
% nonlinear mapping. this mapping can normally be extracted from raw TIF
% data as it is done here. the following are general items to consider when
% carrying out intensity calibration for streak pyrometry:
%   1. use a linear image sensor or linearize the image data using
%       trusted linearization mapping.
%   2. never use a rolling shutter sensor for streak imaging. doing so
%       produces images that are not usable for velocimetry, unless a
%       complicated reverse engineering process is carried out to
%       de-distort the images.
%   3. preferrably use a camera that comes with trusted spectral response
%       data, or measure spectral response yourself.
%   4. use a sensor with high dynamic range and never allow saturation in
%       the images.
%   5. streak images must be fully focused. set an f-stop that allows for
%       imaging the entire flow regime within the depth of field. if
%       defocused features are present in the images, those must be
%       filtered out. this filtering process is not included in
%       streak_demo.m.
%   6. read and understand papers\pyrometry.pdf. this type of pyrometry is
%       very complicated and a thorough understanding of the sources of
%       errors is necessary.
%   7. mask the calibration images so that the view factors are well
%       controlled. if view factors cannot be computed in a closed form,
%       use raytracing to estimate them. most of the uncertainty in
%       pyrometric streak sizing originates from uncertainty in view
%       factors, therefore it is necessary to control them at least in the
%       calibration step.

% we compute some constants
% the area of the visible part of the tungsten ribbon filament
area = (8.5/1000 * 3/1000);

% the radiation view factor from the masked filament part to the chosen
% mirror in the stereo rig (left is used here). for the meaning of
% parameters here, please see the implementation of the view factor
% function and the paper cited in its documentation. all units here are in
% mm, although the units must only be self-consistent.
F12rect = techniques.streak.viewfactors.rect_rect( ...
    [7.54 16.04], [-3.36 -0.36], [-21.5 21.5], [-21.5 21.5], 583.5);

% the integration time of the camera, s
% this was set by the user of the D5100
integration_time = 1/1000;

% the number of pixels over which the incident radiation from the filament
% was above the detection limit
n = 4323;

% absorbtivity from an additional ND filter used in the calibration
t = 1.563/100;

% a calibration constant formed by the above
s = area * F12rect * integration_time * t / n;

% adjust spectral response - the spectral response of the used camera was
% quite uncertain. this adjustment was suggested by Nikon. in general, it
% is advised to use cameras that have very well defined and accurately
% measured spectral response so that tricks like this are not needed.
s1 = 0.9294;
s2 = 1.1998;

% tungsten temperatures that have been used for calibration, K
T = [1400 1500 1600 1700 1800 1900 2000];

% in the following, we integrate the Planck distribution to get effective
% responses and powers. the tungsten ribbon emissivity data is bundled
% (data\other\emissivity_tungsten.mat). data are from
% J. C. De Vos, "A new determination of the emissivity of tungsten ribbon"
% Physica 20, 690–712 (1954).
load([get_basis_path '..\data\other\tungsten_emissivity.mat']);
ind_temp = find(ismember(ti, T));
li_subset = li(31:144);

% here we load camera response data
% this is from an unofficial source, therefore this response data here is
% not very well trusted. in this measurement, we could not do any better.
load([get_basis_path '..\data\other\nikon_d5100_sensor_response.mat']);
response_red_subset = interp1(lambda, response_red, li_subset.*1000, ...
    'pchip', 'extrap');
response_green_subset = interp1(lambda, response_green, ...
    li_subset.*1000, 'pchip', 'extrap');
response_blue_subset = interp1(lambda, response_blue, li_subset.*1000, ...
    'pchip', 'extrap');
max_response = max([response_red_subset; response_green_subset; ...
    response_blue_subset]);
response_red_subset = s1 .* response_red_subset ./ max_response;
response_green_subset = response_green_subset ./ max_response;
response_blue_subset = s2 .* response_blue_subset ./ max_response;

% here we compute tungsten and corresponding black body powers as a
% function of temperature
powers_red = zeros(1, numel(T));
powers_blue = zeros(1, numel(T));
powers_green = zeros(1, numel(T));
bb_red = zeros(1, numel(T));
bb_blue = zeros(1, numel(T));
bb_green = zeros(1, numel(T));

for i = 1:numel(T)    
    planck = techniques.streak.misc.planck_spectrum(T(i), li_subset);
    emissivity = ei(31:144, ind_temp(i));
    
    power_red = trapz(li_subset./1000000, planck .* emissivity ...
        .* response_red_subset);
    power_green = trapz(li_subset./1000000, planck .* emissivity ...
        .* response_green_subset);
    power_blue = trapz(li_subset./1000000, planck .* emissivity ...
        .* response_blue_subset);    
      
    powers_red(i) = power_red;
    powers_green(i) = power_green;
    powers_blue(i) = power_blue;
    
    power_red = trapz(li_subset./1000000, planck ...
        .* response_red_subset);
    power_green = trapz(li_subset./1000000, planck ...
        .* response_green_subset);
    power_blue = trapz(li_subset./1000000, planck ...
        .* response_blue_subset);    
      
    bb_red(i) = power_red;
    bb_green(i) = power_green;
    bb_blue(i) = power_blue;
end

% here we load the counts from the intensity calibration. the counts are
% simply the mean of the pixel counts over the image area that corresponds
% to the emitting part of the tungsten filament. they are linearized.
load([get_basis_path ...
    '..\data\other\streak_intensity_calibration_counts.mat']);
counts = zeros(7, numel(intcal_lin));

% this is from the number of samples, to calculate standard error - not
% used in further calculations
Nc = 51.17;
for i = 1:numel(intcal_lin)
    counts(:, i) = [intcal_lin(i).red.mean; intcal_lin(i).green.mean; ...
        intcal_lin(i).blue.mean; ...
        intcal_lin(i).red.std/Nc; intcal_lin(i).green.std/Nc; ...
        intcal_lin(i).blue.std/Nc; intcal_lin(i).temp];
end

% plot some results
figure,
plot(counts(1,:), powers_red, ...
    counts(2,:), powers_green, ...
    counts(3,:), powers_blue);
xlabel('counts');
ylabel('radiant power');

% fit curves, subtract offset
m = 2;
p_red = polyfit(powers_red, counts(1,:), m);
p_green = polyfit(powers_green, counts(2,:), m);
p_blue = polyfit(powers_blue, counts(3,:), m);
temp_ = counts;
counts(1:3, :) = counts(1:3, :) - repmat([p_red(end); p_green(end); ...
    p_blue(end)], 1, size(counts, 2));

% linearize response
fitzcline = @(slope, x, y)(x.*slope) - y;
s_red = lsqnonlin(@(sl)fitzcline(sl, powers_red, counts(1,:)), 38);
s_green = lsqnonlin(@(sl)fitzcline(sl, powers_green, counts(2,:)), 38);
s_blue = lsqnonlin(@(sl)fitzcline(sl, powers_blue, counts(3,:)), 38);

c_red = powers_red .* s_red;
c_green = powers_green .* s_green;
c_blue = powers_blue .* s_blue;

% plot theoretical color curve and data to check
plot(T, powers_red./powers_green); hold on;
plot(T, bb_red./bb_green, 'r');
plot(T, temp_(1,:)./temp_(2,:), 'o');
plot(T, (c_red./c_green), 's');
xlabel('T, K');
ylabel('R/G');
legend('theoretical W', 'theoretical BB', 'raw measured', ...
    'after transformation');

figure,
plot(T, powers_red./powers_blue); hold on;
plot(T, bb_red./bb_blue, 'r');
plot(T, temp_(1,:)./temp_(3,:), 'o');
plot(T, (c_red./c_blue), 's');
xlabel('T, K');
ylabel('R/G');
legend('theoretical W', 'theoretical BB', 'raw measured', ...
    'after transformation');

% linear vs raw
figure,
plot(powers_red, temp_(1,:), 'o', powers_green, temp_(2,:), 'o'); hold on;
errorbar(powers_red, temp_(1,:), temp_(4,:), 'LineStyle', 'none', ...
    'MarkerEdgeColor', 'b', 'Color', 'b');
errorbar(powers_green, temp_(2,:), temp_(5,:), 'LineStyle', 'none', ...
    'MarkerEdgeColor', 'g', 'Color', 'g'); xlim([0 250]);
plot(powers_red, c_red, powers_green, c_green); hold off;
xlabel('power');
ylabel('counts');
legend('raw measured', 'after transformation');

% mapping between counts and corrected counts
figure,
subplot(3,1,1);
plot(temp_(1,:), c_red, temp_(2,:), c_green, temp_(1,:), temp_(1,:), 'k');
xlabel('old counts'); ylabel('new counts');
legend('red', 'green');
subplot(3,1,2);
bar(temp_(1,:), c_red - temp_(1,:));
xlabel('old counts, red'); ylabel('adjustment');
subplot(3,1,3);
bar(temp_(2,:), c_green - temp_(2,:));
xlabel('old counts, green'); ylabel('adjustment');

rg = bb_red ./ bb_green;
ps_red = polyfit(T, bb_red, 6);
ps_green = polyfit(T, bb_green, 6);
ps_blue = polyfit(T, bb_blue, 6);
slope = s_red;

% this is the intensity_calibration field that streak_demo.m uses
intensity_calibration = struct( ...
    'color_ratio_curve', rg, ...
    'integration_time', integration_time, ...
    'calibration_constant', s, ...
    'power_curve_red', ps_red, ...
    'power_curve_green', ps_green, ...
    'power_curve_blue', ps_blue, ...
    'slope_red', s_red, ...
    'slope_green', s_green, ...
    'slope_blue', s_blue);