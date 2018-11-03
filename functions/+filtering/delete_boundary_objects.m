function filtered_output = delete_boundary_objects(binary_input)
% removes objects that touch the boundary in binary images.
%
% inputs:
%   binary_input (logical image) - binary image
% 
% outputs:
%   filtered_output (logical image) - the same binary image, but with
%       objects that touch the boundary removed

props = measurement.measure_particles(binary_input, 'pixelidxlist');
r = size(binary_input, 1);
c = size(binary_input, 2);
boundary_pixels = sub2ind([r c], [1:r 1:r ones(1,c) ones(1,c).*r], ...
    [ones(1,r) ones(1,r).*c 1:c 1:c]);
filtered_output = binary_input;
for i = 1:size(props, 1)
    if any(ismember(props(i,:).pixelidxlist{:}, boundary_pixels))
        filtered_output(props(i,:).pixelidxlist{:}) = false;
    end
end