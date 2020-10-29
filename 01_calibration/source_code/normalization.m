%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn
% T: 3x3
% U: 4x4

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization

% TODO 1. compute centroids
center_xy = mean(xy,2);
center_XYZ = mean(XYZ,2);
% TODO 2. shift the points to have the centroid at the origin
xy_shift = xy - center_xy;
XYZ_shift = XYZ - center_XYZ;
% TODO 3. compute scale
[~, n] = size(xy);
sigma_xy = sum(sqrt(sum(xy_shift.*xy_shift,1)))/n;
sigma_XYZ = sum(sqrt(sum(XYZ_shift.*XYZ_shift,1)))/ n;
% TODO 4. create T and U transformation matrices (similarity transformation)
T = [sigma_xy*eye(2), center_xy;
          zeros(1,2),         1];
T = T^(-1);
U = [sigma_XYZ*eye(3), center_XYZ;
           zeros(1,3),         1];
U = U^(-1);
% TODO 5. normalize the points according to the transformations
xy_normalized = T*[xy;ones(1,n)];
XYZ_normalized = U*[XYZ;ones(1,n)];

end