function saveimg(I,filename)
%===========================================================================
%                   Matt Bowers - University of Bath
%
%                        Copyright (c) 1996
%===========================================================================
%
% Save a MATLAB matrix as a P5 format image file.
%
% Arguments:
%   filename    destination filename including extension
%   I           image matrix
%
%===========================================================================

file_ID=openfile(filename,'w');         % Open file

fprintf(file_ID,'P5\n');                % Write header info
fprintf(file_ID,'# Created by saveimg.m\n');

% rows = height
% cols = width
% 
[rows, cols] = size(I);
fprintf(file_ID,'%d %d\n',[cols rows]);
fprintf(file_ID,'%d\n',255);

% Matlab writes in column order, so we must transpose the data first
%
fwrite(file_ID, I', 'uchar');

shutfile(file_ID);                      % Close file

