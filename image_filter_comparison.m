function image_filter_comparison(origional_image, origional_image_matrix, filtered_image_matrix, filter_type, window_size)
%==========================================================================
% Function to plot the impact of image filtering, and edge detection on
% resultant images
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
%   Displays Plots
%
%==========================================================================

% Save & display filtered image comparison against origional 
saveimg(filtered_image_matrix, "filtered_image.pgm");
subplot(2,2,1), imshow(origional_image), title("Original Image"); hold on
subplot(2,2,2), imshow("filtered_image.pgm"), title( filter_type + " filtered image, window size: " + window_size); hold on
subplot(2,2,3), edge(origional_image_matrix, "canny"), title("Original Image canny edge detection"); hold on
subplot(2,2,4), edge(filtered_image_matrix, "canny"), title("Filtered Image canny edge detection"); hold off

end

