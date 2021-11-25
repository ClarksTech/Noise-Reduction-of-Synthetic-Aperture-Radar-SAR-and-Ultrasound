function image_filter_comparison(origional_image, origional_image_matrix, filtered_image_matrix, filter_type, window_size,std_dev)
%==========================================================================
% Function to plot the impact of image filtering, and edge detection on
% resultant images
% 
%
% Arguments:
%   origional_image             origional pgm image        
%   origional_image_matrix      origional image as matrix
%   filtered_image_matrix       filtered image as matrix   
%   filter_type                 type of filter used
%   window_size                 window size
%
% Returns:
%   Displays Plots for image pre and post-processing, canny edge detection
%   is then performed to see the filterings impact on edge detection and
%   noise reduction
%
%==========================================================================

% Save & display filtered image comparison against origional 
saveimg(filtered_image_matrix, "filtered_image.pgm");

% display origional image
subplot(2,2,1), imshow(origional_image), title("Original Image"); hold on

% if gausian filtering used, display standard deviation with filtered image
% results, otherise only show window size
if filter_type == "gaussian"
    subplot(2,2,2), imshow("filtered_image.pgm"), title( filter_type + " filtered, window size: " + window_size + " σ = " + std_dev); hold on
else
    subplot(2,2,2), imshow("filtered_image.pgm"), title( filter_type + " filtered, window size: " + window_size); hold on
end
% Apply canny edge detection to the images pre and post filtering to help
% determine the impact of the filter on noise reduction and edge detection
subplot(2,2,3), edge(origional_image_matrix, "canny"), title("Original Image canny edge detection"); hold on
subplot(2,2,4), edge(filtered_image_matrix, "canny"), title("Filtered Image canny edge detection"); hold off

end

