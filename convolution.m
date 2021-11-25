function [filtered_image_matrix_with_pad, window_size, std_dev] = convolution(origional_image_matrix, filter, window_size)
%==========================================================================
% Function to take image matrix, perform convolution with specified filter
% return image matrix of filtered image
%
% Arguments:
%   origional_image_matrix      image to be convolved with filter kernal
%   filter_type                 filter method being applied
%   window_size                 size of filter window
%   
%
% Returns:
%   filtered_image_matrix       filtered image returned
%   window_size                 window size as gaussian filtering changes
%   std_dev                     standard deviation used for gaussian
%
%==========================================================================

% check selected filter type - prompt user for specific parameters as
% required
if filter == "gaussian"
    prompt = "Enter standard deviation for Gaussian filter: ";
    std_dev = input(prompt);
    %generate window size from standard deviation
    window_size = 2*(3*std_dev)+1;
end


% Pad the origional image so filter window does not wander out of bounds at
% edge of image - replicatative padding used
padded_image_matrix = padarray(origional_image_matrix,[floor(window_size/2),floor(window_size/2)],"replicate","both");

% Create matrix of padded size to store filtered Pixel values
new_image = zeros(size(padded_image_matrix,1),size(padded_image_matrix,2));

% Determine number of rows and columns in padded image
image_row_size = size(padded_image_matrix,1);
image_col_size = size(padded_image_matrix,2);

% Step through each pixel of the origional image and find pixel values
% within window size
for R = 1+floor(window_size/2):image_row_size-floor(window_size/2)      % for every row
    for C = 1+floor(window_size/2):image_col_size-floor(window_size/2)  % for every column

        % Calculate range around current pixel for the window
        above_range = (R - floor(window_size/2));
        below_range = (R + floor(window_size/2));
        left_range = (C - floor(window_size/2));
        right_range = (C + floor(window_size/2));

        % Add pixels contained in window size to a new matrix
        pixels_in_window = padded_image_matrix([above_range:below_range], [left_range:right_range]);
        
        % Call appropriate filter function to obtain the padded filtered
        % matrix
        if filter == "mean"                     
            new_image = image_mean_filter(R, C, new_image, pixels_in_window, window_size);
        elseif filter == "sharpen"
            new_image = image_sharpen_filter(R, C, new_image, pixels_in_window, window_size);
        elseif filter == "gaussian"
            new_image = image_gaussian_filter(R, C, new_image, pixels_in_window, window_size, std_dev);
        elseif filter == "unsharp masking"
            new_image = image_unsharp_masking_filter(R, C, new_image, pixels_in_window, window_size);  
        elseif filter == "median"
            new_image = image_median_filter(R, C, new_image, pixels_in_window);  
        end
    end
end

filtered_image_matrix_with_pad = new_image;

end

