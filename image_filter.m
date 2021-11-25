function image_filter(image_filename, filter_type, window_size)
%==========================================================================
% Function to take a pgm image, perform specified filter, display results
% of filtering, with comparison to origional
%
% Arguments:
%   image_file_name         image name to be filtered including extension
%   filter_type             filter method being applied
%   window_size             size of filter window
%   
%
% Returns:
%   filtered_image          filtered image displayed and returned
%
%==========================================================================

% check window size is odd - give error message if not
msg=' ';
if(mod(window_size,2) == 0)
    tmp=sprintf('Error: window size not valid, please enter odd number.\n');
    msg=strcat(msg,tmp);
    error(msg);
end

% Read in the image file and store in matrix
origional_image = image_filename;
origional_image_matrix = readimg(origional_image);

% check selected filter type - prompt user for specific parameters as
% required
if filter_type == "gaussian"
    prompt = "Enter standard deviation for Gaussian filter: ";
    std_dev = input(prompt);
    %generate window size from standard deviation
    window_size = 2*(3*std_dev)+1;
else
std_dev = 0;
end

% If unsharp masking being performed, obtain min and max snr for whole
% image and normalisation in later processing
if filter_type == "unsharp masking"
    [snr_max, snr_min] = snr_range(origional_image_matrix, window_size);
else
    %set to 0 if unsharp masking filter not used
    snr_max = 0;
    snr_min = 0;
end

% Perform convolution on the image matrix using specified filtering 
[filtered_image_matrix_with_pad, window_size] = convolution(origional_image_matrix, filter_type, window_size, snr_max, snr_min, std_dev);

% Remove empty padding arround the filtered image, so image matrix
% of same size is returned
pad_size = floor(window_size/2);
filtered_image_matrix = filtered_image_matrix_with_pad(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

% Save & display filtered image comparison against origional 
image_filter_comparison(origional_image, origional_image_matrix, filtered_image_matrix, filter_type, window_size, std_dev);

end

