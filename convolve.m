function filtered_image_matrix = convolve(origional_image_matrix, filter_window, window_size)
%==========================================================================
% Convolve filter window over image, producing and returning the filtered 
% image matrix
%
% Arguments:
%   origional_image_matrix      image matrix to be convolved over
%   filter_window               weighted window matrix    
%   window_size                 size of filter window
%
% Returns:
%   filtered_image              filtered image matrix
%
%==========================================================================

%Pad the origional image so filter window does not wander out of bounds at
%edge of image - replicatative padding used
padded_image_matrix = padarray(origional_image_matrix,[floor(window_size/2),floor(window_size/2)],"replicate","both");

%determine number of rows and columns in padded image
image_row_size = size(padded_image_matrix,1);
image_col_size = size(padded_image_matrix,2);

%create matrix to store filtered fixel values
filtered_image_matrix_with_pad = zeros(image_row_size,image_col_size);


%step through each pixel of the origional image and apply the weighted
%filter to the surronding pixels to determine the new mean value
for R = 1+floor(window_size/2):image_row_size-floor(window_size/2)      % for every row
    for C = 1+floor(window_size/2):image_col_size-floor(window_size/2)  % for every column

        %calculate ranges around central pixel for mask size
        above_range = (R - floor(window_size/2));
        below_range = (R + floor(window_size/2));
        left_range = (C - floor(window_size/2));
        right_range = (C + floor(window_size/2));

        %add pixels contained in mask size to a new matrix
        image_pixels_in_mask = padded_image_matrix([above_range:below_range], [left_range:right_range]);
        
        % perform multiplication of each pixel in mask with weighted filter
        % mask
        filtered_image_pixels = zeros(window_size,window_size);
        for x = 1:size(image_pixels_in_mask,1)           % for every row
            for y = 1:size(image_pixels_in_mask,2)       % for every column
                filtered_image_pixels(x,y) = image_pixels_in_mask(x,y)*filter_window(x,y);
            end
        end
        
        %Sum all the pixels to obtain the final pixel value, and add back
        %to the corresponding central position
        final_pixel_value = sum(filtered_image_pixels, 'all');
        filtered_image_matrix_with_pad(R,C) = final_pixel_value;

        %remove empty padding arround the filtered image, so image matrix
        %of same size is returned
        pad_size = floor(window_size/2);
        filtered_image_matrix = filtered_image_matrix_with_pad(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

    end
end

end

