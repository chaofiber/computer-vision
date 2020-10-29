%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function

% TODO 1. For each correspondence xi <-> Xi, computes matrix Ai
[~,n] = size(xyn);
A = [];
for ii = 1:n
    xy = xyn(:,ii);
    Ai = [zeros(1,4), -XYZn(:,ii)', xy(2)*XYZn(:,ii)';
          XYZn(:,ii)', zeros(1,4), -xy(1)*XYZn(:,ii)'];
    A = [A; Ai];
end
% TODO 2. Compute the Singular Value Decomposition of Usvd*S*V' = A
[~,~,V] = svd(A);
% TODO 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)
P_normalized = reshape(V(:,12),4,3)';
end
