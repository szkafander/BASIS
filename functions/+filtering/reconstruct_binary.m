function binary_reconstructed = reconstruct_binary(properties_, ...
    image_template, varargin)
% reconstructs binary image after filtering blob properties_
% inputs:
%   properties_ - the properties of the detected blobs, a table returned by
%       e.g., measurement.measure_blobs. properties_ must contain the
%       pixelidxlist, pixellist or image column.
%   image_template - an image of the same size as the image in which the
%       blobs described by properties_ were detected. if a 1X2 matrix is
%       passed for image_template, reconstruct_binary interprets it as an
%       empty image with size image_template(1) X image_template(2). if an
%       indexing exception is raised, reconstruct_binary rethrows it
%       assuming that it was caused by an intention to pass an 1X2 size
%       image as template.
%   pixelidxlist (string) - a name under which properties_ stores pixel 
%       indices for blobs.
% outputs:
%   binary_reconstructed (logical image) - the reconstructed binary image.

p = inputParser;
addParameter(p, 'pixelidxlist', [], @ischar);
parse(p, varargin{:});

if all(size(image_template) == [1 2])
    num_rows = image_template(1);
    num_cols = image_template(2);
else
    [num_rows, num_cols] = size(image_template);
end

if isempty(p.Results.pixelidxlist)
    if ismember('pixelidxlist', properties_.Properties.VariableNames)
        pixidxlist = properties_.pixelidxlist;
    elseif ismember('pixellist', properties_.Properties.VariableNames)
        pixidxlist = cellfun(@(x)sub2ind([num_rows num_cols], ...
            x(1), x(2)), properties_.pixellist, 'UniformOutput', false);
    else
        error(['A column name for pixelidxlist has not been specified ' ...
            'and no valid columns were found with any of the default ' ...
            'names (''pixelidxlist'', ''pixellist''). Please revise ' ...
            'the properties_ argument or specify a column explicitly ' ...
            'using the ''pixelidxlist'' parameter.']);
    end
else
    try
        pixidxlist = properties_.(p.Results.pixelidxlist);
    catch
        error(['The specified column, ' p.Results.pixelidxlist ' was ' ...
            'not found in properties_. Please revise the properties_ ' ...
            'argument or specify another column name using the ' ...
            '''pixelidxlist'' argument.']);
    end
end

binary_reconstructed = false(num_rows, num_cols);
for ind_row = 1:numel(pixidxlist)
    binary_reconstructed(pixidxlist{ind_row}) = true;
end