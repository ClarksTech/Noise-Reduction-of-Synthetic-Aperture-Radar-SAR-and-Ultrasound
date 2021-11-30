function [sharpen_max, sharpen_min] = ...
    sharpen_range(original_image_matrix, window_size)
%==========================================================================
% Function to determine Sharpen filter range in image for normalisation
%
% Arguments:
%   original_image_matrix       image to be convolved with filter kernal
%   window_size                 size of filter window
%   
%
% Returns:
%   sharpen_max                 max sharpen of all possible window position
%   sharpen_min                 min sharpen of all possible window position
%
%==========================================================================

% initialise max and min possible values
sharpen_maximum = 0;
sharpen_minimum = 10000;

% create filter window of defined size
% zeros matrix created, and -1 added to each element
filter_window = zeros(window_size,window_size) -1; 
% replace central weight with number of weights-1 to produce final
% sharpening filter 
filter_window(((window_size+1)/2),((window_size+1)/2)) = (window_size^2)-1;

% Pad the origional image so filter window does not wander out of bounds at
% edge of image - replicatative padding used
padded_image_matrix = padarray(original_image_matrix,...
    [floor(window_size/2),floor(window_size/2)],"replicate","both");

% Determine number of rows and columns in padded image
image_row_size = size(padded_image_matrix,1);
image_col_size = size(padded_image_matrix,2);

% Step through each pixel of the origional image and save sharpen val 
for R = 1+floor(window_size/2):image_row_size-floor(window_size/2)      % row
    for C = 1+floor(window_size/2):image_col_size-floor(window_size/2)  % col

        % Calculate range around current pixel for the window
        above_range = (R - floor(window_size/2));
        below_range = (R + floor(window_size/2));
        left_range = (C - floor(window_size/2));
        right_range = (C + floor(window_size/2));

        % Add pixels contained in window size to a new matrix
        pixels_in_window = padded_image_matrix([above_range:below_range],...
            [left_range:right_range]);
        
        % perform multiplication of each pixel in mask with weighted filter
        filtered_image_pixels = pixels_in_window.*filter_window;
            
        % Sum all the pixels to obtain the final pixel value
        final_pixel_value = sum(filtered_image_pixels, 'all');
        % take absolute value
        final_pixel_value = abs(final_pixel_value);
        % round to intiger intensity
        final_pixel_value = round(final_pixel_value);
        
        % if sharpen val is higher than current maximum - update new maximum
        if final_pixel_value > sharpen_maximum
            sharpen_maximum = final_pixel_value;
        end
        
        % if snr is lower than current minimum - update new minimum
        if final_pixel_value < sharpen_minimum
            sharpen_minimum = final_pixel_value;
        end

    end
end

% after all window positions tested, set final max and min values
sharpen_min = sharpen_minimum;
sharpen_max = sharpen_maximum;

end



