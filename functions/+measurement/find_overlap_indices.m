function overlap_inds = find_overlap_indices(properties_, varargin)
% finds overlap indices between detected binary binary features based on
% their linear pixel indices.
%
% inputs:
%   properties_ (table) - table of feature properties, normally produced by
%       measurement.measure_particles. must contain a column that stores
%       linear pixel indices. this is normally the column 'pixelidxlist'.
%   pixelidxlist (string) - name-value pair that specifies the name of the
%       column in which the linear pixel indices are stored in properties_.
%       the default is 'pixelidxlist'.
%
% outputs:
%   overlap_inds (cell) - a num_featuresX1 cell array of overlap indices.
%       the ith element in overlap_inds specifies the row indices of 
%       features in properties_ that overlap with the ith element. 
%
% note: use find_overlap_indices after filtering, since this is an
% expensive function.

p = inputParser;
addParameter(p, 'pixelidxlist', 'pixelidxlist', @ischar);
parse(p, varargin{:});

pixelidxlist = properties_.(p.Results.pixelidxlist);

for i = 1:size(properties_, 1)
    overlap_inds_ = [];
    for j = 1:size(properties_, 1)
        if any(ismember(pixelidxlist{i}, pixelidxlist{j}))
            overlap_inds_ = [overlap_inds_ j];
        end
    end
    overlap_inds{i} = overlap_inds_;
end
overlap_inds = overlap_inds';