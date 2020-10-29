% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)
xs_mean = mean(xs,2);
d = size(xs,2);
% todo what kind of normalization it wants us to do
sigma_x = std(xs(1,:));
sigma_y = std(xs(2,:));
T = [1/sigma_x,         0, -xs_mean(1)/sigma_x;
             0, 1/sigma_y, -xs_mean(2)/sigma_y;
             0,         0,                   1];
nxs_homo = T * xs;
nxs = nxs_homo(1:2,:);
end
