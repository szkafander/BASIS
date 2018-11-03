function properties_ = measure_particles(particles, varargin)
% measures properties of particles
% operates on either the passed binary mask or any of the passed scalars
% can calculate anything regionprops can, plus means and standard
% deviations of the underlying scalars either under the area of perimeter
% of objects in the mask.
%
% inputs:
%   particles - 2D or n-d binary image or label map. if an n-d logical
%       array is passed, measure_particles treats it as hiearchic
%       detection, probably produced by detection.hierarchic_detection. in
%       this case, the output will be measurements from all detection
%       levels, with the addition of overlap indices.
%   scalars - struct of underlying scalar maps
%
% optional inputs:
%   properties to be measured are passed as strings with the following
%   format:
%       <which field>:<which property>
%       where <which field> can be:
%           binary - a property of a binary object
%           <name of any field in scalars> - a named scalar map in the
%           struct scalars
%       and <which property> can be:
%           <anything regionprops can measure> - any property that
%           regionprops accepts or
%           <mask type>_<statistic> - where
%               mask_type - specifies whether to look at scalar
%                   values underlying the particle mask area or perimeter.
%                   can be 'bulk' or 'boundary'
%               statistic - specifies the aggregation method of scalar
%                   values. can be
%                   'min', 'max', 'mean', 'std' - behavior follows those of
%                       the matlab functions of the same name
%
% outputs:
%   properties_ - a table of measured properties.

if isempty(varargin)
    varargin = {'area'};
end

if ~ismember(class(particles), {'double', 'logical'}) ...
        && ~isinteger(particles)
    error(['The binary detections must be passed as a 2D or n-d ' ...
        'logical array or an integer or float label map. The passed ' ...
        'variable was not of these types. Please revise the passed ' ...
        'particles variable.']);
end

[scalars, binary_props, scalar_props, scalar_names, prop_names] = ...
    check_args(varargin);

unique_scalar_names_requested = unique(scalar_names);

if isempty(scalars)
    if ~isempty(unique_scalar_names_requested)
        error(['No scalars were passed but some were requested. ' ...
            'Please pass the appropriate scalars as a struct or ' ...
            'pass a single scalar as a numeric variable and request ' ...
            'a single scalar.']);
    else
        scalar_names_passed = [];
    end
elseif isstruct(scalars)
    scalar_names_passed = fieldnames(scalars);
else
    if numel(fieldnames(scalar_props)) == 0
        scalar_names_passed = [];
    elseif numel(fieldnames(scalar_props)) == 1
        scalar_names_passed = fieldnames(scalar_props);
        scalars = struct(scalar_names_passed{1}, scalars);
    elseif ~isempty(unique_scalar_names_requested)
        error(['A non-struct variable was passed with the argument ' ...
            'scalars and multiple scalar fieldnames were requested in ' ...
            'through optional argument. When passing a non-struct ' ...
            'variable for the scalars argument, only one fieldname ' ...
            'can be requested. Please revise the requested scalar ' ...
            'fieldnames or pass a struct variable with the scalars ' ...
            'argument.']);
    end
end

if iscell(unique_scalar_names_requested) ...
        && isempty(unique_scalar_names_requested)
    unique_scalar_names_requested = [];
end

scalar_memberships = ismember( ...
    unique_scalar_names_requested, scalar_names_passed);
if ~all(scalar_memberships)
    error(['Statistics from the following scalar fields were ' ...
        'requested, but no scalars of these names were found: ' ...
        strjoin(unique_scalar_names_requested( ...
        ~scalar_memberships), ', ') '.']);
end

if isfloat(particles)
    if ~all(round(particles(:)) == particles(:))
        error(['A double matrix was passed as particles, ' ...
            'therefore a label matrix was assumed, but the ' ...
            'matrix is not integer-valued.']);
    end
else
    if size(particles, 3) == 1
        properties_ = flat_protocol(particles, scalars, binary_props, ...
            scalar_props, scalar_names, prop_names);
    else
        if ~ismember('pixelidxlist', binary_props)
            warning(['The results of hierarchic detection were ' ...
                'probably passed with the argument ''particles'', ' ...
                'however, the ''pixelidxlist'' property was not ' ...
                'requested. measure_particles now adds this field to ' ...
                'requested fields since it is required to compute ' ...
                'overlapping indices for the passed hierarchic ' ...
                'detection.']);
            binary_props{end+1} = 'pixelidxlist';
        end
        properties_ = hierarchic_protocol(particles, scalars, ...
            binary_props, scalar_props, scalar_names, prop_names);
    end
end


function properties_ = hierarchic_protocol(particles, scalars, ...
    binary_props, scalar_props, scalar_names, prop_names)

num_channels = size(particles, 3);
for ind_channel = 1:num_channels
    binary_ = particles(:,:,ind_channel);
    if ind_channel == 1
        properties_ = flat_protocol(binary_, scalars, binary_props, ...
            scalar_props, scalar_names, prop_names);
    else
        props_current = flat_protocol(binary_, scalars, ...
            binary_props, scalar_props, scalar_names, prop_names);
        properties_ = [properties_; props_current];
    end
    properties_.id = (1:size(properties_, 1))';
end


function properties_ = flat_protocol(particles, scalars, binary_props, ...
        scalar_props, scalar_names, prop_names)
    
num_particles = bwconncomp(particles);
num_particles = num_particles.NumObjects;

properties_ = table((1:num_particles)', 'VariableNames', {'id'});

if ~isempty(binary_props)
    binary_props_ = regionprops(particles, binary_props{:});
    if numel(binary_props_) == 1
        for fn_ind = 1:numel(binary_props)
            current_field = getfieldi(binary_props_, ...
                binary_props{fn_ind});
            if ~iscell(current_field) && numel(current_field) ~= 1
                binary_props_ = setfieldi(binary_props_, ...
                    binary_props{fn_ind}, ...
                    {getfieldi(binary_props_, binary_props{fn_ind})});
            end
        end
    end
    properties_ = [properties_ struct2table(binary_props_)];
end

if ~isempty(scalar_names)
    if islogical(particles) && numel(size(particles)) == 2
        if numel(scalar_names) ~= numel(prop_names)
            error(['Number of scalar names does not match number of ' ...
                'property names. This indicates an error in argument ' ...
                'parsing. Check if the optional arguments have been ' ...
                'correctly listed.']);
        end
        % will there be perimeter properties?
        if sum(cellfun(@(x)~isempty(strfind(x, 'boundary')), ...
                prop_names)) > 0
            particle_perimeters = bwperim(imfill(particles, 'holes'));
        end
        scalar_fns = fieldnames(scalar_props);
        for scalar_id = 1:numel(scalar_fns)
            aop_fns = fieldnames(scalar_props.(scalar_fns{scalar_id}));
            for aop_id = 1:numel(aop_fns)
                switch aop_fns{aop_id}
                    case 'bulk'
                        scalar_values = struct2cell( ...
                            regionprops(particles, ...
                            scalars.(scalar_fns{scalar_id}), ...
                            'PixelValues'));
                    case 'boundary'
                        scalar_values = struct2cell(regionprops( ...
                            particle_perimeters, ...
                            scalars.(scalar_fns{scalar_id}), ...
                            'PixelValues'));
                    otherwise
                        error(['Unrecognized particle mask. Valid ' ...
                            'masks are: ''bulk'' and ''boundary''.']);
                end
                statistics = ...
                    scalar_props.(scalar_fns{scalar_id}).(aop_fns{aop_id});
                scalar_values = cellfun(@(x)double(x), scalar_values, ...
                    'UniformOutput', false);
                for stat_id = 1:numel(statistics)
                    statistic = statistics{stat_id};
                    scalar_statistics = cellfun(str2func(statistic), ...
                        scalar_values, 'UniformOutput', false);
                    new_props = cell2table(scalar_statistics(:), ...
                        'VariableName', ...
                        {[scalar_fns{scalar_id} '__' ...
                        aop_fns{aop_id} '_' ...
                        statistics{stat_id}]});
                    properties_ = [properties_ ...
                        new_props];
                end
            end
        end
    end
end

properties_.Properties.VariableNames = ...
    cellfun(@lower, properties_.Properties.VariableNames, ...
    'UniformOutput', false);


function [scalars, binary_props, scalar_props, scalar_names, ...
    prop_names] = check_args(cells)

if ~ischar(cells{1})
    scalars = cells{1};
    cells = cells(2:end);
else
    scalars = [];
end

string_args = cells(cellfun(@isstr, cells));
string_args = cellfun(@lower, string_args, 'UniformOutput', false);

accepted_props = { ...
    'bulk_min', ...
    'bulk_max', ...
    'bulk_mean', ...
    'bulk_std', ...
    'boundary_mean', ...
    'boundary_std', ...
    'boundary_min', ...
    'boundary_max'};

if numel(string_args) < numel(cells)
    warning(['Non-string arguments were passed. measure_particles ' ...
        'only accepts strings as optional arguments. Accepted string ' ...
        'arguments are: ' strjoin( ...
        strcat('<underlying scalar>_', accepted_props), ', ') '.']);
end

% deal with binary props
accepted_props_regionprops = { ...
    'area', ...
    'boundingbox', ...
    'centroid', ...
    'convexarea', ...
    'convexhull', ...
    'conveximage', ...
    'eccentricity', ...
    'equivdiameter', ...
    'eulernumber', ...
    'extent', ...
    'extrema', ...
    'filledarea', ...
    'filledimage', ...
    'image', ...
    'majoraxislength', ...
    'minoraxislength', ...
    'orientation', ...
    'perimeter', ...
    'pixelidxlist', ...
    'pixellist', ...
    'solidity', ...
    'subarrayidx'};
valid_arg_ids = ismember(string_args, accepted_props_regionprops);
binary_props = string_args(valid_arg_ids);
string_args(valid_arg_ids) = [];

% deal with scalar props
scalar_names = {};
prop_names = {};
k = 0;
valid_arg_ids = false(1, numel(string_args));
for i = 1:numel(string_args)
    current_arg = strsplit(string_args{i}, ':');
    if numel(current_arg) > 1
        if ismember(current_arg{end}, accepted_props)
            k = k + 1;
            scalar_names{k} = strjoin(current_arg(1:end-1), '');
            prop_names{k} = current_arg{end};
            valid_arg_ids(i) = true;
        end
    end
end

unique_field_names = unique(scalar_names);
scalar_props = struct();
for i = 1:numel(unique_field_names)
    scalar_ids = find(cellfun(@(x)strcmpi(x, unique_field_names{i}), ...
        scalar_names));
    for scalar_id = scalar_ids(:)'
        current_prop = prop_names{scalar_id};
        [area_or_perimeter, statistic] = parse_prop(current_prop);
        if ~isfield(scalar_props, unique_field_names{i})
            scalar_props(1).(unique_field_names{i}) = struct();
        end
        if ~isfield(scalar_props.(unique_field_names{i}), ...
                area_or_perimeter)
            scalar_props(1).(unique_field_names{i}).(area_or_perimeter) = ...
                {statistic};
        else
            scalar_props(1).(unique_field_names{i}). ...
                (area_or_perimeter){end + 1} = statistic;
        end
    end
end

if sum(~valid_arg_ids) > 0
    warning(['The following string arguments were unmatched: ' ...
        strjoin(string_args(~valid_arg_ids), ', ') '.']);
end


function [what, how] = parse_prop(prop)

prop = strsplit(prop, '_');
if numel(prop) ~= 2
    error(['Property name incorrect. Acceptable property names: ' ...
        strjoin(accepted_props, ', ') '.']);
end
what = prop{1};
how = prop{2};