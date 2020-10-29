%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition

% TODO Compute R, K with QR decomposition such M=K*R
M = P(:,1:3);
[R, K] = qr(M^(-1));
R = R^(-1);
K = K^(-1);
% TODO Compute camera center C=(cx,cy,cz) such P*C=0 
% This method works too and generate same result.
% C = null(P); 
[~,~,V] = svd(P);
C = V(:,4);
C = C / C(4);
C = C(1:3);

% TODO normalize K such K(3,3)=1
K = K / K(3,3);
% TODO Adjust matrices R and Q so that the diagonal elements of K (= intrinsic matrix) are non-negative values and R (= rotation matrix = orthogonal) has det(R)=1
T = diag(sign(diag(K)));
K = K * T;
R = T^(-1)*R;
if (det(R)==-1)
    R = -R;
end

% TODO Compute translation t=-R*C
t = -R*C;
end