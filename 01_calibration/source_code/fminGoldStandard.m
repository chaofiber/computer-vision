%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)

%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];

% TODO compute reprojection errors
projected_XYZ = P * XYZ_normalized;
projected_XYZ = projected_XYZ ./ projected_XYZ(3,:);
reproj_error = xy_normalized(1:2,:) - projected_XYZ(1:2,:);
% TODO compute cost function value
f = sum(reproj_error.*reproj_error,'all');
end