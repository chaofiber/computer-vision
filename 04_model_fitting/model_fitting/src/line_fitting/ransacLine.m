function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    rand_idx = randperm(num_pts,2);
    pt1 = data(:,rand_idx(1));
    pt2 = data(:,rand_idx(2));
    % Tip: Matlab command randperm / randsample is useful here

    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    coef2 = polyfit([pt1(1) pt2(1)],[pt1(2), pt2(2)],1);
    k = coef2(1);
    b = coef2(2);
    
    % Compute the distances between all points with the fitting line
    distances = abs(k*data(1,:)+b-data(2,:));    
    
    % Compute the inliers with distances smaller than the threshold
    inliers = find(distances < threshold);
    
    % Update the number of inliers and fitting model if the current model
    % is better. using all data that fit
    if (numel(inliers) > best_num_inliers)
        best_num_inliers = numel(inliers);
        coef2 = polyfit(data(1,inliers), data(2,inliers),1);
        best_k = coef2(1);
        best_b = coef2(2);
    end
end


end
