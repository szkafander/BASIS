function status = show_detection(image, varargin)
% shows the results of binary detection overlaid on an image
%
% inputs:
%   image (image) - the image on which the detection results will be
%       overlaid
%   properties_ (table or struct) - optional, the result of e.g.,
%       measurement.measure_particles. there must be a column or field that
%       contains linear pixel indices of the detected objects.
%   pixelidxlist (string) - name-value pair, the name of the column or
%       field in properties_ that contains the linear pixel indices of the
%       detected objects. the default is 'pixelidxlist'.
%   mode (string) - name-value pair, specifies the overlay mode. accepted
%       values are 'outline' and 'overlay'. the default is 'outline'. the
%       outline mode highlights the boundary of the detected objects. the
%       overlay mode uses Matlab's imoverlay to display the detection.
%   figure (integer-valued scalar) - the number of figure window to use for
%       plotting
% 
% outputs:
%   status (logical) - true if plotting is successful

p = inputParser;
addRequired(p, 'image', @isimg);
addOptional(p, 'properties', [], @istable);
addParameter(p, 'pixelidxlist', 'pixelidxlist', @ischar);
addParameter(p, 'mode', 'outline', @ischar);
addParameter(p, 'figure', 1, ...
    @(x)validateattributes(x, {'numeric'}, ...
    {'scalar', 'integer', 'nonnegative'}));
parse(p, image, varargin{:});
properties_ = p.Results.properties;
pixelidxlist = lower(p.Results.pixelidxlist);

mode_ = p.Results.mode;

valid_modes = {'outline', 'overlay'};
if ~ismember(mode_, valid_modes)
    error(['Invalid mode specified. Valid modes are: ' ...
        strjoin(valid_modes, ' ,') '.']);
end

figure(p.Results.figure);

if ~isempty(properties_)
    if ~ismember(pixelidxlist, properties_.Properties.VariableNames)
        error(['A detection table was passed, but no detected pixel ' ...
            'ID''s were found. Please specify the name of the field ' ...
            'that contains the pixel ID''s by using the ' ...
            '''pixelidxlist_fieldname'' name-value pair.']);
    else
        mask = get_mask();
        switch mode_
            case 'overlay'
                imshowpair(image, mask, 'scaling', 'independent');
            case 'outline'
                imshow(imoverlay(image, ...
                    bwmorph(bwperim(mask), 'dilate'), 'cyan'));
        end
    end
else
    imshow(image, []);
end

drawnow;
status = true;

    function mask = get_mask()
        mask = false(size(image));
        for ind_object = 1:size(properties_, 1)
            pixelids = properties_.(pixelidxlist)(ind_object);
            if iscell(pixelids)
                pixelids = pixelids{:};
            end
            mask(pixelids) = true;
        end
    end

end