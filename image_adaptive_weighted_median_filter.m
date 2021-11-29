function filtered_image_matrix_with_pad = image_adaptive_weighted_median_filter(Row, Col, new_image, pixels_in_window, window_size)
%==========================================================================
% perform adaptive weighted median filtering, returning filtered image matrix, padded
% 
%
% Arguments:
%   Row                         current origional padded image row        
%   Col                         current origional padded image column
%   new_image                   matrix containing new image pixels      
%   pixels_in_window            current pixels inside window position
%   window_size                 window size
%
% Returns:
%   filtered_image_matrix_with_pad     padded filtered image matrix
%
%==========================================================================

% get parameters required to generate mask weights
mean = sum(pixels_in_window, 'all')/window_size^2;
std_dev = std(pixels_in_window,1,"all");

% set arbitrary values for constant and central weight
central_weight = 100;
constant = 10;

% create distance mask
filter_window_distance = zeros(window_size,window_size);
% calculate distance from centre of mask and add
window_centre = ((window_size+1)/2);
for row = 1:window_size             % for every row
    for column = 1:window_size      % for every column
        % calculate distance from central pixel and replace mask value with
        % this distance
        filter_window_distance(row,column) = sqrt((window_centre-column)^2+(window_centre-row)^2);
    end
end

% create final weighted filter window using equation
filter_window = zeros(window_size,window_size);
for row = 1:window_size             % for every row
    for column = 1:window_size      % for every column
        % if condition to avoid div by 0 if the mean is 0 or 255 and
        % standard deviation becomes 0
        if mean == 0 
            % if mean is 0 all pixel values must be 0 therefore all may be
            % given central weight as weighting negated with std_dev = 0
            filter_window(row,column) = floor((central_weight));
        else
            % if not div by 0 condition, calculate approptiate weights
            final_weight = floor((central_weight -((filter_window_distance(row,column)*constant*std_dev)/mean)));
            % if the final weight is less than 0 - set to 0 to avoid
            % negatives
            if final_weight < 0
                final_weight = 0;
            end
            % replace pint in weighted filter window with final weight
            filter_window(row,column) = final_weight;
        end
    end
end

 % assign weights to values in window
 col_PIW = reshape(pixels_in_window,[],1);
 col_weights = reshape(filter_window,[],1);

 % sort the pixels and coresponding weights
 sort_matrix = [col_PIW,col_weights];
 sorted_matrix = sortrows(sort_matrix);

 % find median point
 weights_sum = sum(sorted_matrix(:,2));
 median_point = (weights_sum+1)/2;

 % cumulative sum of weights to find median
 cumulative_weight = 0;
 for weight = 1:(window_size^2)
     % add current weight to the running total
     cumulative_weight = cumulative_weight + sorted_matrix(weight,2);
     % if cumulative weight is median point or above median has been found
     if cumulative_weight >= median_point
         % ser median to correspongin sorted column and break out of loop
         median = sorted_matrix(weight,1);
         weight = (window_size^2) + 1;
         break
     end
 end

% update the new image
new_image(Row,Col) = median;

% return updated new image
filtered_image_matrix_with_pad = new_image;
end



