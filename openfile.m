function file_ID = openfile(filename,access)
%===========================================================================
%                   Matt Bowers - University of Bath
%
%                        Copyright (c) 1996
%===========================================================================
%
% Open file with error checking
%
% Arguments:
%   filename
%   access      string sets permissions - see MATLAB 'fopen' help
%
% Returns:
%   file_ID     file identifier
%
%===========================================================================

[file_ID, message] = fopen(filename,access);  % Open file

if file_ID==-1
    error (message) % Report errors
else
    disp (['File: ' filename ' opened.'])
end