function [filtered_image_matrix_with_pad, previous_row, previous_median, previous_hist] = image_efficiant_median_filter(Row, Col, new_image, pixels_in_window, window_size, previous_row, previous_median, previous_hist)
%==========================================================================
% perform efficiant median filtering, returning padded filtered image matrix
% 
%
% Arguments:
%   Row                         current origional padded image row        
%   Col                         current origional padded image column
%   new_image                   matrix containing new image pixels      
%   pixels_in_window            current pixels inside window position
%   window_size                 window size
%   previous_row                previous row to see if row has changed
%   previous_median             previous median for efficiant LTM
%   previous_hist               previous_hist for efficiant LTM
%
% Returns:
%   filtered_image_matrix_with_pad      padded filtered image matrix
%   previous_row                        previous row to see if row has changed
%   previous_median                     previous median for efficiant LTM
%   previous_hist                       previous_hist for efficiant LTM
%
%==========================================================================

% must be re done every new row as entire histogram changes
if (Row ~= previous_row)

    % create histogram of pixels in window
    hist = zeros(1,256);
    % for all pixels in the window, increment value of historgram
    for row = 1:window_size
        for col = 1:window_size
            hist(pixels_in_window(row,col)) = hist(pixels_in_window(row,col)) +1;
        end
    end
    
    % find the median value from historgram
    median = (numel(pixels_in_window)+1)/2;
    hist_count = 0;
    % step through entire histogram
    for hist_val = 1:256
        % if value is above 0 increment the counter
        if hist(hist_val) > 0
            hist_count = hist_count + hist(hist_val);
        end
        % when counter is above median point set as final pixel value, save
        % as previous median for use on same row and break out of loop
        if hist_count >= median
            final_pixel_value = hist_val;
            previous_median = hist_val;
            hist_val = 256;
            break
        end
    end

% return hist as previous for the next position of filter window
previous_hist = hist;

% If has moved along on the same row - no need to create from scratch use
% efficient method of finding new median
else
    % remove old column values from histogram comparing to median
    th = (window_size^2)/2;
    less_than_median = th;
    for col = 1:window_size
        previous_hist(pixels_in_window(1,col)) = previous_hist(pixels_in_window(1,col)) - 1;
        % decrement less than median count if the value removed was less
        if pixels_in_window(1,col) < previous_median
            less_than_median = less_than_median - 1;
        end
    end
    
    % update current histogram now old values removed
    hist = previous_hist;

    % add new column values to the histogram comparing to median
    for col = 1:window_size
        hist(pixels_in_window(window_size,col)) = hist(pixels_in_window(window_size,col)) + 1;
        % if the newly added value is less than previous median increment
        % the less than median counter
        if pixels_in_window(window_size,col) < previous_median
            less_than_median = less_than_median + 1;
        end
    end

    % update final historgram to be returned for the next window position
    previous_hist = hist;
    
    % find new median in the histogram
    % if less than median shows no change - median remains same as last 
    if less_than_median == th
        final_pixel_value = previous_median;
        previous_median = final_pixel_value;
    % if less than median counter has reduced - median needs to be moved up
    % by the difference 
    elseif less_than_median < th
        for hist_val = previous_median:256
            % for values in histogram above previous median increment less
            % than median counter
            if hist(hist_val) > 0
                less_than_median = less_than_median + hist(hist_val);
            end
            % when less than median goes abouve threshold, new median found
            if less_than_median >= th
                final_pixel_value = hist_val;
                previous_median = hist_val;
            end
        end
    % if less than median counter has increased - median needs to be moved
    % down by the difference         
    elseif less_than_median > th
        for hist_val = previous_median:-1:0
            % for values in histogram below previous median increment less
            % than median counter
            if hist(hist_val) > 0
                less_than_median = less_than_median + hist(hist_val);
            end
            % when less than median goes below threshold, new median found
            if less_than_median <= th
                final_pixel_value = hist_val;
                previous_median = hist_val;
            end
        end
    end
end

% add median into the new image
new_image(Row,Col) = final_pixel_value;      
    
% return updated new image
filtered_image_matrix_with_pad = new_image;
previous_row = previous_row + 1;
end




