function I=readimg(filename)
%===========================================================================
%                   Matt Bowers - University of Bath
%
%                        Copyright (c) 1999
%===========================================================================
%
% Read a P2/P5 format image file into a MATLAB matrix
%
% Arguments:
%   filename   image filename including extension
%
% Returns:
%   I          image matrix
%
%===========================================================================

failed=0;
msg=' ';

file_ID=openfile(filename,'r');     % Open file

code=sscanf(readtokn(file_ID),'%s',1);

if ~(strcmp(code,'P2') | strcmp(code,'P5'))
  failed=1;
  tmp=sprintf('Error: File is not a valid pgm file.\n');
  msg=strcat(msg,tmp);
end
cols=sscanf(readtokn(file_ID),'%d',1);
rows=sscanf(readtokn(file_ID),'%d',1);
if rows<1 | cols<1
  failed=1;
  tmp=sprintf('Error: Invalid image dimensions (%d,%d).\n',cols,rows);
  msg=strcat(msg,tmp);
end
greyScales=sscanf(readtokn(file_ID),'%d',1);
if greyScales~=255
  failed=1;
  tmp=sprintf('Error: greyLevels must be 255, not %d.',greyScales);
  msg=strcat(msg,tmp);
end

if failed
  shutfile(file_ID);
  error(msg);
end

% Swap rows and cols here to account for MATLAB reading column by column
%
if (strcmp(code,'P5'))
  I=fread(file_ID,[cols,rows],'uchar');   % Read image data into matrix
else
  I=fscanf(file_ID, '%d ', [cols,rows]);
end

% We must transpose the image here to account for the fread scan order
%
I = I';

shutfile(file_ID);                      % Close file
