function filtered_image_matrix_with_pad = image_trimmed_mean_filter(Row, Col, new_image, pixels_in_window, window_size)
%==========================================================================
% perform trimmed mean filtering, returning filtered image matrix, padded
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

% create trimming mask of binary values length of pixels in window for
% outlier rejection depending on mask size
trim_mask = ones(1, window_size^2);
% trim by half the window size on either end of histogram (min and max
% values)
trim_mask(1, 1:floor(window_size/2)) = 0;
trim_mask(1, (end-(floor(window_size/2)-1)):end) = 0;

% reshape pixels in window from 2d matrix to 1d list for sorting
pixels_in_window_1d = reshape(pixels_in_window,1,numel(pixels_in_window));

% sort pixels in ascending order
sorted_pixels_in_window = sort(pixels_in_window_1d);

% multiply by weights to trimm the values
trimmed_pixels_in_window = sorted_pixels_in_window.*trim_mask;

% calculate sum of all remaining pixels and weights
sum_trimmed = sum(trimmed_pixels_in_window, 'all');
sum_weights = sum(trim_mask, 'all');

% divide by sum of weights to atempt DC distortion prevention - not perfect
final_pixel_value = sum_trimmed / sum_weights;

% return updated new image
new_image(Row,Col) = final_pixel_value;
filtered_image_matrix_with_pad = new_image;

end