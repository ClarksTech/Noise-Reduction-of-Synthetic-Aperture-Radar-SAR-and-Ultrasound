function filtered_image_matrix_with_pad = image_median_filter(Row, Col, new_image, pixels_in_window)
%==========================================================================
% perform median filtering, returning filtered image matrix, padded
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
final_pixel_value = sorted_pixels_in_window(median_pos);
new_image(Row,Col) = final_pixel_value;

% return updated new image
filtered_image_matrix_with_pad = new_image;
end


