function [filtered_image_matrix_with_pad, generated_filter_window] =...
    image_gaussian_filter(Row, Col, new_image, pixels_in_window, ...
    window_size, std_dev, generated_filter_window)
%==========================================================================
% perform gaussian filtering, returning filtered image matrix, padded
% 
%
% Arguments:
%   Row                         current original padded image row        
%   Col                         current original padded image column
%   new_image                   matrix containing new image pixels       
%   pixels_in_window            current pixels inside window position
%   window_size                 window size
%   generated_filter_window     gaussian filter window weights
%
% Returns:
%   filtered_image_matrix_with_pad      padded filtered image matrix
%   generated_filter_window             return gaussian filter weights 
%
%==========================================================================

% Generate mask on first window position only to speed up filter
if Row == (1+floor(window_size/2)) && Col == (1+floor(window_size/2))
    
    % create filter window of defined size and generate gaussian weights
    % zeros matrix created 
    filter_window_dist = zeros(window_size,window_size);
    % replace central weight with weight 1
    filter_window_dist(((window_size+1)/2),((window_size+1)/2)) = 1;
    % replace remaining 0s with gaussian weight from gaussian equation
    window_centre = ((window_size+1)/2);
    for row = 1:window_size             % for every row
        for column = 1:window_size      % for every column
            % Gaussian equation to calculate the value for pixel depending
            % on distance from windoc central pixel
            filter_window_dist(row,column) = ...
                exp(-(((window_centre-column)^2 +...
                (window_centre-row)^2)/(2*std_dev^2)));
        end
    end
    
    % Correct for DC distortion by normalising filter window dividing by
    % number of weights
    dist_correction = zeros(window_size,window_size) + ...
        1/sum(filter_window_dist, 'all');
    filter_window = filter_window_dist.*dist_correction;

% if not first position filter window is used in
else
   % use pre created filter window from abouve
   filter_window = generated_filter_window; 
end

% perform multiplication of each pixel in mask with weighted filter
filtered_image_pixels = pixels_in_window.*filter_window;
    
% Sum all the pixels to obtain the final pixel value, and add back
% to the corresponding central position
final_pixel_value = sum(filtered_image_pixels, 'all');

% round to nearest intiger intensity value
final_pixel_value = round(final_pixel_value);

% return updated new image
new_image(Row,Col) = final_pixel_value;
filtered_image_matrix_with_pad = new_image;

% return filter window for use in next position of window
generated_filter_window = filter_window;
end
