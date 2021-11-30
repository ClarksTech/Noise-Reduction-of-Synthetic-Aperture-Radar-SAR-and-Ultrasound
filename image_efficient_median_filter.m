function [filtered_image_matrix_with_pad, first_col, previous_hist] = image_efficient_median_filter(Row, Col, new_image, pixels_in_window, window_size, previous_first_col, previous_hist)
%==========================================================================
% perform efficient median filtering, returning padded filtered image matrix
% 
%
% Arguments:
%   Row                         current original padded image row        
%   Col                         current original padded image column
%   new_image                   matrix containing new image pixels      
%   window_size                 window size
%   previous_first_col          column from last window to be removed
%   previous_hist               previous_hist for efficient LTM
%
% Returns:
%   filtered_image_matrix_with_pad      padded filtered image matrix
%   first_col                           first column of current window
%   previous_hist                       previous_hist for efficiant LTM
%
%==========================================================================

% must be re-done every new row as entire histogram changes
if Col == (1 + floor(window_size/2))

    % create histogram of pixels in window
    hist = zeros(1,256);
    % for all pixels in the window, increment value of historgram
    for row = 1:window_size
        for col = 1:window_size
            % get intensity of pixel
            intensity = pixels_in_window(row,col);
            % increment corresponding pixel in histogram
            hist(intensity + 1) = hist(intensity + 1) + 1;
        end
    end
    
    % median threshold
    th = [window_size*window_size/2];
    % current value less than median
    fmdn = 0;
    % find median by increading position in histogram until current
    % position is equal or larger than median threshold
       for val = 1:size(hist,2)
            num_at_intensity = hist(1,val);
            fmdn = fmdn + num_at_intensity;
            if fmdn >= th
                fmdn = val - 1;
                break
            end
       end 

% return hist as previous for the next position of filter window
previous_hist = hist;
% return first column of current PIW for efficient implementation
first_col = pixels_in_window(:,1);
% add median into the new image
new_image(Row,Col) = fmdn;      
% return updated new image
filtered_image_matrix_with_pad = new_image;

% If has moved along on the same row - no need to create from scratch use
% efficient method of finding new median
else
    % read in the previous histogram
    new_hist = previous_hist;
  
    % remove last column of previous pixel window from histogram
    for val = 1:window_size
        intensity = previous_first_col(val,1);
        % decrement the intensity removed
        new_hist(intensity+1) = new_hist(intensity+1) - 1;
    end

    % add new column from current windoow to histogram 
    for val = 1:window_size
        intensity = pixels_in_window(val,window_size);
        % increment the intensity added
        new_hist(intensity+1) = new_hist(intensity+1) + 1;
    end

    % median threshold
    th = [window_size*window_size/2];
    % current value less than median
    fmdn = 0;
    % find median by increading position in histogram until current
    % position is equal or larger than median threshold
       for val = 1:size(new_hist,2)
            num_at_intensity = new_hist(1,val);
            fmdn = fmdn + num_at_intensity;
            if fmdn >= th
                fmdn = val - 1;
                break
            end
       end 

% return hist as previous for the next position of filter window
previous_hist = new_hist;
% return first column of current PIW for efficient implementation
first_col = pixels_in_window(:,1);
% add median into the new image
new_image(Row,Col) = fmdn;      
% return updated new image
filtered_image_matrix_with_pad = new_image;

end




