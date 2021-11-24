function mean_filtered_image = mean_filter(image_filename, window_size)
%==========================================================================
% Read a P2/P5 format image file, perform mean filtering, returning
% filtered image matrix
%
% Arguments:
%   filename                image name to be filtered including extension
%
% Returns:
%   mean_filtered_image     filtered image matrix
%
%==========================================================================

%check window size is odd as required give error message if invalid
msg=' ';
if(mod(window_size,2) == 0)
    tmp=sprintf('Error: window size not valid, please enter odd number.\n');
    msg=strcat(msg,tmp);
    error(msg);
end

%read in the image file and store in matrix
origional_image = image_filename;
origional_image_matrix = readimg(origional_image);

%create filter window of defined size
%zeros matrix created, and weight added to each element - fastest method 
filter_window = zeros(window_size,window_size) + (1/(window_size^2)); 

%convolve filter window over entire image creating new filtered image
filtered_image_matrix = convolve(origional_image_matrix, filter_window, window_size);

%save filtered image and display comparison against origional and filtered 
saveimg(filtered_image_matrix, "mean_filtered_image.pgm");
subplot(1,2,1), imshow(origional_image), title("Origional Image"); hold on
subplot(1,2,2), imshow("mean_filtered_image.pgm"), title("Mean filtered image using window size: " + window_size); hold off

end