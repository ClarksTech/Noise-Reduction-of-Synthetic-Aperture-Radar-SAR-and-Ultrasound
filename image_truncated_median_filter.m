function filtered_image_matrix_with_pad = image_truncated_median_filter(Row, Col, new_image, pixels_in_window, window_size)
%==========================================================================
% perform truncated median filtering, returning filtered image matrix, padded
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

% reshape pixels in window from 2d matrix to 1d list for sorting
pixels_in_window_1d = reshape(pixels_in_window,1,numel(pixels_in_window));

% sort pixels in ascending order
sorted_pixels_in_window = sort(pixels_in_window_1d);

% find median position in list
median_pos = (numel(sorted_pixels_in_window)+1)/2;

% get value for median pixel, and add into the new image
original_median_value = sorted_pixels_in_window(median_pos);

% histogram for all intensities
trunk_hist = zeros(1,256);

% for all pixels in window increse histogram value
for R = 1:window_size                       % for every row
    for C = 1:window_size                   % for every column
        intensity = pixels_in_window(R,C);
        trunk_hist(intensity+1) = trunk_hist(intensity+1) + 1;
    end
end

% Find direction to truncate the median histogram
% find difference between median and min/max intensity
min_intense = find(trunk_hist~=0, 1, "first") - 1;
min_dif = original_median_value - min_intense;
% find maximum intensity 
max_intense = find(trunk_hist~=0, 1, "last") - 1;
max_dif = max_intense - original_median_value;

if min_dif == 0 || max_dif == 0
    truncated_median_value = original_median_value;
else

    % Apply truncation to the histogram so median bisects
    % determine direction to truncate by comparing size differences from
    % median value for max and min intensities
    % truncate top side
    if min_dif <= max_dif
        % for all values above new trucated threshold
        for trunk_hist_val = ((original_median_value + min_dif)+1):256
            % set all non 0 values to 0 to truncate median
            if trunk_hist(trunk_hist_val) > 0
                trunk_hist(trunk_hist_val) = 0;
            end
        end
    % otherwise truncate bottom side
    elseif min_dif > max_dif
        % for all values below new trucated threshold
        for trunk_hist_val = ((original_median_value - max_dif)-1):-1:1
            % Set all non 0 values to 0 to truncate median
            if trunk_hist(trunk_hist_val+1) > 0
                trunk_hist(trunk_hist_val+1) = 0;
            end
        end
    end
    
    % calculate the new truncated median (approximates the mode)
    trunkmedian = (sum(trunk_hist, "all")+1)/2;
    hist_count = 0;
    % step through entire histogram
    for trunk_hist_val = 1:256
        % if value is above 0 increment the counter
        if trunk_hist(trunk_hist_val) > 0
            hist_count = hist_count + trunk_hist(trunk_hist_val);
        end
        % when counter is above median point set as final pixel value
        if hist_count >= trunkmedian
            truncated_median_value = trunk_hist_val;
            trunk_hist_val = 256;
            break
        end
    end    
end

new_image(Row,Col) = truncated_median_value;

% return updated new image
filtered_image_matrix_with_pad = new_image;
end


