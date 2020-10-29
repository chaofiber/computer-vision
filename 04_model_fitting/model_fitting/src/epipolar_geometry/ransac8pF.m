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

iter = 20000;
M = iter; % set the largest
num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;
p = 0.99;

for i=1:iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    rand_idx = randperm(num_pts,8);
    x1s = x1(:,rand_idx);
    x2s = x2(:,rand_idx);
    [Fh, F] = fundamentalMatrix(x1s, x2s);
    % Compute the error.
    distances = (distPointsLines(x2, F*x1) + distPointsLines(x1,F*x2)) / 2;
    % Compute the inliers with errors smaller than the threshold.
    inliers_index = find(distances < threshold);
    % Update the number of inliers and fitting model if the current model
    % is better.
    if (numel(inliers_index)>best_num_inliers)
        best_num_inliers = numel(inliers_index);
        best_ratio = best_num_inliers/num_pts;
        best_F = F;
        best_inliers = inliers_index;
        % update M for Adaptive RANSAC (upper round)
        M = round(abs(log(1-p)/log(1-best_ratio^8))+0.5); 
    end
    if (i>=M)
        break;
    end
end
% Compute the mean error with the best F
distances = (distPointsLines(x2, best_F*x1) + distPointsLines(x1,best_F*x2)) / 2;

disp("total number of inliers:"); disp(best_num_inliers);
disp("total number of inliers (ratio):"); disp(best_num_inliers/num_pts);
disp("mean error of inliers:"); disp(mean(distances(best_inliers)));
disp("value of M:"); disp(M);

end


