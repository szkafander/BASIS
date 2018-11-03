function varargout = shout(message, varargin)
% this is a convenience function for debugging Nodes.
% it prints the current time and a passed message and returns the input 
% unchanged.

disp([datestr(datetime) ' - ' message]);
varargout = varargin;