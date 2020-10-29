%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
% TODO fill the gaps in fminGoldstandard.m
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end

% TODO: denormalize projection matrix
P_normalized = reshape(pn,4,3)';
P = T^(-1)*P_normalized*U;

%factorize prokection matrix into K, R and t
[K, R, t] = decompose(P);

% TODO compute average reprojection error
[~,n] = size(xy);
projected_xy = P*[XYZ;ones(1,n)];
projected_xy(:,:) = projected_xy(:,:)./projected_xy(3,:);
error = sum(sqrt(sum((xy - projected_xy(1:2,:)).*(xy - projected_xy(1:2,:)),1)))/n;
end