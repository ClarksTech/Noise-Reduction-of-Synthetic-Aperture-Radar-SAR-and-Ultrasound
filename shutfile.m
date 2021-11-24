function shutfile(file_ID)
%===========================================================================
%                   Matt Bowers - University of Bath
%
%                        Copyright (c) 1996
%===========================================================================
%
% Close file 'file_ID' with error checking
%
%===========================================================================

[filename, permission]=fopen(file_ID);        % Get filename

if (fclose(file_ID)==-1)
  error (['Error closing file: ' filename])   % Report error
else
  disp (['File: ' filename ' closed.'])
end