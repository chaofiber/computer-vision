% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
% normalize data (subtract mean and divide standard deviation)
[nx1s,T1] = normalizePoints2d(x1s);
[nx2s,T2] = normalizePoints2d(x2s);

% to solve for fundamental matrix: x2^TFx^1 = 0
x1 = nx1s(1,:);
y1 = nx1s(2,:);
x2 = nx2s(1,:);
y2 = nx2s(2,:);
d = size(x1s,2);

A = [    x2.*x1;
         x2.*y1;
             x2;
         y2.*x1;
         y2.*y1;
             y2;
             x1;
             y1;
     ones(1,d)];
A = A';
[~,~,V] = svd(A);
F_vec = V(:,end);
F = [F_vec(1:3)';F_vec(4:6)';F_vec(7:9)'];

% denormalize
F = T2'*F*T1;

% compute Fh with singular constraint
[U,S,V] = svd(F);
S(3,3) = 0;
Fh = U*S*V';

end