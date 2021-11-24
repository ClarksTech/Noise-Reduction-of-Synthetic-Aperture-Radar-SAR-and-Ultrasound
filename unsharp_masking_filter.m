function unsharp_mask_filtered_image = unsharp_masking_filter(image_filename, window_size)
%==========================================================================
% Read a P2/P5 format image file, perform sharpen filtering, returning
% filtered image matrix
%
% Arguments:
%   filename                        image name to be filtered including extension
%   window_size                     size of filter window
%
% Returns:
%   unsharp_mask_filtered_image     filtered image matrix
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
filter_window = zeros(window_size,window_size);

%convolve filter window over entire image creating new filtered image
unsharp_mask_filtered_image = convolve(origional_image_matrix, filter_window, window_size, 1);

%save filtered image and display comparison against origional and filtered 
saveimg(unsharp_mask_filtered_image, "unsharp_mask_filtered_image.pgm");
subplot(1,2,1), imshow(origional_image), title("Origional Image"); hold on
subplot(1,2,2), imshow("unsharp_mask_filtered_image.pgm"), title("Unsharp masking filtered image using window size: " + window_size); hold off

end
