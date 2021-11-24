function filtered_image_matrix = convolve(origional_image_matrix, filter_window, window_size, unsharp_mask)
%==========================================================================
% Convolve filter window over image, producing and returning the filtered 
% image matrix
%
% Arguments:
%   origional_image_matrix      image matrix to be convolved over
%   filter_window               weighted window matrix    
%   window_size                 size of filter window
%   unsharp_mask                adaptive linear filter convolution if = 1
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
        
        %if adaptive linear filter unsharp masking is used, use different
        %method to determine result of convolution
        if unsharp_mask == 1
            %get parameters for unsharp masking filter
            original = image_pixels_in_mask(((window_size+1)/2),((window_size+1)/2));
            mean = sum(image_pixels_in_mask, 'all')/window_size^2;
            std_dev = std(image_pixels_in_mask,1,"all");
            snr = mean / std_dev;
           
            % constant k varies with SNR which is dependant on window,
            % normalised between 0 and 1
            minstd = 0;
            maxstd = 127.5;
            k = (snr - minstd) / (maxstd - minstd) ;
            
            %unsharp masking filter implementation 
            final_pixel_value = (mean + k*(original - mean));
            filtered_image_matrix_with_pad(R,C) = final_pixel_value;
        end

        %if adaptive linear filter not used, perform normal convolution
        if unsharp_mask == 0
            % perform multiplication of each pixel in mask with weighted filter
            % mask
            filtered_image_pixels = image_pixels_in_mask.*filter_window;
    
            %Sum all the pixels to obtain the final pixel value, and add back
            %to the corresponding central position
            final_pixel_value = sum(filtered_image_pixels, 'all');
            filtered_image_matrix_with_pad(R,C) = final_pixel_value;
        end

        %remove empty padding arround the filtered image, so image matrix
        %of same size is returned
        pad_size = floor(window_size/2);
        filtered_image_matrix = filtered_image_matrix_with_pad(pad_size+1:end-pad_size,pad_size+1:end-pad_size);

    end
end

end

