function token=readtokn(fileID)
% token=readtokn(fileID)
%      Returns the next token from the file pointed to by fileID.
%      Tokens are separated by whitespace.
%      A comment starts with a '#' and ends at the end of a line, and
%      is treated like whitespace.
%      The token is returned as an array of characters.

finished=0;
while ~finished
  char=fscanf(fileID,'%c',1);
  % So, what does this char represent?
  if char=='#' % Skip to end of line
    dummy=fgetl(fileID);
  elseif ~isspace(char)
    finished=1;
    token=char;
    while ~isspace(char) & char~='#';
      char=fscanf(fileID,'%c',1);
      token=[token, char];
    end
  end
end

