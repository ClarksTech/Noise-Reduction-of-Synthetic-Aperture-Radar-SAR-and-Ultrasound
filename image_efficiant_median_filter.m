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
%
% Returns:
%   filtered_image_matrix_with_pad     padded filtered image matrix
%
%==========================================================================

% must be re done every new row as entire pixel matrix changes
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
    for hist_val = 1:256
        if hist(hist_val) > 0
            hist_count = hist_count + hist(hist_val);
        end
        if hist_count >= median
            final_pixel_value = hist_val;
            previous_median = hist_val;
            hist_val = 256;
            break
        end
    end
%return hist
previous_hist = hist;

else
    % remove old
    th = (window_size^2)/2;
    less_than_median = th;
    for col = 1:window_size
        previous_hist(pixels_in_window(1,col)) = previous_hist(pixels_in_window(1,col)) - 1;
        if pixels_in_window(1,col) < previous_median
            less_than_median = less_than_median - 1;
        end
    end

    hist = previous_hist;

    % add new
    for col = 1:window_size
        hist(pixels_in_window(window_size,col)) = hist(pixels_in_window(window_size,col)) + 1;
        if pixels_in_window(window_size,col) < previous_median
            less_than_median = less_than_median + 1;
        end
    end

    previous_hist = hist;
    
    % find new median
    if less_than_median == th
        final_pixel_value = previous_median;
        previous_median = final_pixel_value;
    elseif less_than_median < th
        for hist_val = previous_median:256
            if hist(hist_val) > 0
                less_than_median = less_than_median + hist(hist_val);
            end
            if less_than_median >= th
                final_pixel_value = hist_val;
                previous_median = hist_val;
            end
        end
    elseif less_than_median > th
        for hist_val = previous_median:-1:0
            if hist(hist_val) > 0
                less_than_median = less_than_median + hist(hist_val);
            end
            if less_than_median <= th
                final_pixel_value = hist_val;
                previous_median = hist_val;
            end
        end
    end
end

% get value for median pixel, and add into the new image
new_image(Row,Col) = final_pixel_value;      
    
% return updated new image
filtered_image_matrix_with_pad = new_image;
previous_row = previous_row + 1;
end




