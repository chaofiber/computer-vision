% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 200000;
M = iter; % set the largest
num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;
best_ratio = 0;
p = 0.99;

for i=1:iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    rand_idx = randperm(num_pts,8);
    x1s = x1(:,rand_idx);
    x2s = x2(:,rand_idx);
    [Fh, F] = fundamentalMatrix(x1s, x2s);
    FF = Fh;
    % Compute the error.
    distances = (distPointsLines(x2, FF*x1) + distPointsLines(x1,FF'*x2)) / 2;
    % Compute the inliers with errors smaller than the threshold.
    inliers_index = find(distances < threshold);
    % Update the number of inliers and fitting model if the current model
    % is better.
    if (numel(inliers_index)>best_num_inliers)
        best_num_inliers = numel(inliers_index);
        best_ratio = best_num_inliers/num_pts;
        best_F = FF;
        best_inliers = inliers_index;
    end
    % Adaptive RANSAC
    prob = 1 - (1-best_ratio^8)^i;
    if (prob > p)
        fprintf("number of trails: %d\n",i);
        break;
    end

end
% Compute the mean error with the best F
distances = (distPointsLines(x2, best_F*x1) + distPointsLines(x1,best_F'*x2)) / 2;
fprintf("total number of inliers: %d\n", best_num_inliers); 
fprintf("best ratio: %0.2f\n", best_ratio);
fprintf("mean error of inliers: %0.2f\n", mean(distances(best_inliers)) );
end


