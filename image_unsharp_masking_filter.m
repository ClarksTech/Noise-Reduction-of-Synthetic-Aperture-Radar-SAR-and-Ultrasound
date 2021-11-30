function filtered_image_matrix_with_pad = image_unsharp_masking_filter(Row, Col, new_image, pixels_in_window, window_size, snr_max, snr_min)
%==========================================================================
% perform unsharp masking sharpen adaptive linear filtering returning 
% filtered image matrix, padded
%
% Arguments:
%   Row                         current original padded image row        
%   Col                         current original padded image column
%   new_image                   matrix containing new image pixels       
%   pixels_in_window            current pixels inside window position
%   window_size                 window size
%   snr_max                     max snr of all possible window position
%   snr_min                     min snr of all possible window position
%
% Returns:
%   filtered_image_matrix_with_pad     padded filtered image matrix
%
%==========================================================================

% get parameters for unsharp masking filter
original = pixels_in_window(((window_size+1)/2),((window_size+1)/2));
mean = sum(pixels_in_window, 'all')/window_size^2;
std_dev = std(pixels_in_window,1,"all");

% if statement to avoid NaN condition in div by 0 where mean = 0 
if std_dev == 0
    % if no standard deviation there is high SNR therefore return the mean
    % by setting k = 1
    k = 1;
else
    % the constant k varies with 1/SNR which is dependant on the window
    % calculate vaule for k in specific window
    snr = mean / std_dev;
    k_not_norm = 1/snr;
    % normalise k against the whole window using entire image min and max
    % snr values
    max_k = 1/snr_min;
    min_k = 1/snr_max;
    % normalisation equation
    k = (k_not_norm - min_k) / (max_k - min_k);
end
            
% unsharp masking filter equation implementation using calculated k value
% using windowspecific statistics
final_pixel_value = (mean + k*(original - mean));
new_image(Row,Col) = final_pixel_value;

% return updated new image
filtered_image_matrix_with_pad = new_image;
end


