function filtered_image_matrix_with_pad = ...
    image_sharpen_filter(Row, Col, new_image, ...
    pixels_in_window, window_size, sharpen_max, sharpen_min)
%==========================================================================
% perform sharpen filtering, returning filtered image matrix, padded
% 
%
% Arguments:
%   Row                         current origional padded image row        
%   Col                         current origional padded image column
%   new_image                   matrix containing new image pixels       
%   pixels_in_window            current pixels inside window position
%   window_size                 window size
%   sharpen_max                 max sharpen of all possible window position
%   sharpen_min                 min sharpen of all possible window position
%
% Returns:
%   filtered_image_matrix_with_pad     padded filtered image matrix
%
%==========================================================================

% create filter window of defined size
% zeros matrix created, and -1 added to each element
filter_window = zeros(window_size,window_size) -1; 
% replace central weight with number of weights-1 to produce final
% sharpening filter with DC distortion
filter_window(((window_size+1)/2),((window_size+1)/2)) = (window_size^2)-1;

% perform multiplication of each pixel in mask with weighted filter
filtered_image_pixels = pixels_in_window.*filter_window;
    
% Sum all the pixels to obtain the final pixel value, and add back
% to the corresponding central position
final_pixel_value = sum(filtered_image_pixels, 'all');
% take absolute value
final_pixel_value = abs(final_pixel_value);

% normalise the final pixel value between 0 and 255 as the weighted sharpen
% mask can contain negatives and latege postitives fromhigh central weight
final_pixel_value = (final_pixel_value-sharpen_min)*...
    (255/(sharpen_max-sharpen_min));

% round to intiger intensity
final_pixel_value = round(final_pixel_value);

% return updated new image
new_image(Row,Col) = final_pixel_value;
filtered_image_matrix_with_pad = new_image;
end
