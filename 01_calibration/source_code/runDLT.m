%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

[~,n] = size(xy);
% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

% if not notmalized
% xy_normalized = [xy; ones(1,n)];
% XYZ_normalized = [XYZ; ones(1,n)];
% T = eye(3);
% U = eye(4);


%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

% TODO denormalize projection matrix
P = T^(-1)*Pn*U;
%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

% TODO compute average reprojection error

projected_xy = P*[XYZ;ones(1,n)];
projected_xy(:,:) = projected_xy(:,:)./projected_xy(3,:);
error = sum(sqrt(sum((xy - projected_xy(1:2,:)).*(xy - projected_xy(1:2,:)),1)))/n;
end