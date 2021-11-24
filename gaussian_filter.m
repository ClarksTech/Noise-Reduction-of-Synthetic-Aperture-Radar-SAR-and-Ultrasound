function gaussian_filtered_image = gaussian_filter(image_filename, std_dev)
%==========================================================================
% Read a P2/P5 format image file, perform gausian filtering, returning
% filtered image matrix
%
% Arguments:
%   filename                    image name to be filtered including extension
%   std_dev                     standard deviation
%
% Returns:
%   gaussian_filtered_image     filtered image matrix
%
%==========================================================================

%generate window size from standard deviation
window_size = 2*(3*std_dev)+1;

%read in the image file and store in matrix
origional_image = image_filename;
origional_image_matrix = readimg(origional_image);

%create filter window of defined size and generate gaussian weights
%zeros matrix created 
filter_window_dist = zeros(window_size,window_size);
%replace central weight with weight 1
filter_window_dist([(window_size+1)/2,(window_size+1)/2]) = (window_size^2)-1;
%replace remaining 0s with gaussian weight
window_centre = (window_size+1)/2;
for row = 1:window_size             % for every row
    for column = 1:window_size      % for every column
        filter_window_dist(row,column) = exp(-(((window_centre-column)^2+(window_centre-row)^2)/(2*std_dev^2)));
    end
end

dist_correction = zeros(window_size,window_size) + 1/sum(filter_window_dist, 'all');
filter_window = filter_window_dist.*dist_correction;

%convolve filter window over entire image creating new filtered image
gaussian_filtered_image = convolve(origional_image_matrix, filter_window, window_size, 0);

%save filtered image and display comparison against origional and filtered 
saveimg(gaussian_filtered_image, "gaussian_filtered_image.pgm");
subplot(1,2,1), imshow(origional_image), title("Origional Image"); hold on
subplot(1,2,2), imshow("gaussian_filtered_image.pgm"), title("Gaussian filtered image using window size: " + window_size); hold off

end

