function image_ = read_image(path_and_filename, varargin)
% function to read image files. apart from formats read by imread,
% read_image supports reading dm3, im7 and dng formats. read_image
% determines the image format and calls the appropriate read method.
%
% inputs:
%   path_and_filename (string) - full path to image file to read.
%   optional input arguments can be passed that are passed to the called
%   read method.
%
% outputs:
%   image_ (image) - the read image.

[~, ~, extension] = fileparts(path_and_filename);

switch extension
    case '.dm3'
        image_ = DM3Import(path_and_filename, varargin{:});
        image_ = image_.image_data;
    case '.im7'
        image_ = readimx(path_and_filename, varargin{:});
        image_ = image_.Data;
    case '.dng'
        image_ = ReadNEF(path_and_filename);
    otherwise
        image_ = imread(path_and_filename);
end