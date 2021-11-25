function [snr_max, snr_min] = snr_range(origional_image_matrix, window_size)
%==========================================================================
% Function to determine SNR range for image
%
% Arguments:
%   origional_image_matrix      image to be convolved with filter kernal
%   window_size                 size of filter window
%   
%
% Returns:
%   snr_max                 max snr of all possible window position
%   snr_min                 min snr of all possible window position
%
%==========================================================================

% initialise max and min possible values
snr_maximum = 0;
snr_minimum = 127.5;

% Pad the origional image so filter window does not wander out of bounds at
% edge of image - replicatative padding used
padded_image_matrix = padarray(origional_image_matrix,[floor(window_size/2),floor(window_size/2)],"replicate","both");

% Determine number of rows and columns in padded image
image_row_size = size(padded_image_matrix,1);
image_col_size = size(padded_image_matrix,2);

% Step through each pixel of the origional image and save SNR of each
% window
for R = 1+floor(window_size/2):image_row_size-floor(window_size/2)      % for every row
    for C = 1+floor(window_size/2):image_col_size-floor(window_size/2)  % for every column

        % Calculate range around current pixel for the window
        above_range = (R - floor(window_size/2));
        below_range = (R + floor(window_size/2));
        left_range = (C - floor(window_size/2));
        right_range = (C + floor(window_size/2));

        % Add pixels contained in window size to a new matrix
        pixels_in_window = padded_image_matrix([above_range:below_range], [left_range:right_range]);
        
        % calculate mean and standard deviation
        mean = sum(pixels_in_window, 'all')/window_size^2;
        std_dev = std(pixels_in_window,1,"all");

        % if statement to avoid NaN condition in div by 0 where standard deviation 
        % = 0 in completely flat sections of the image
        if std_dev == 0
            snr = snr_maximum;
        else
            snr = mean / std_dev;
        end
        
        % if snr is higher than current maximum - update new maximum
        if snr > snr_maximum
            snr_maximum = snr;
        end
        
        % if snr is lower than current minimum - update new minimum
        if snr < snr_minimum
            snr_minimum = snr;
        end

    end
end

% after all window positions tested, set final max and min values
snr_min = snr_minimum;
snr_max = snr_maximum;

end


