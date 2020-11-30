function [w_x,w_y, E] = tps_model(X,Y,lambda)
%TPS_MODEL Summary of this function goes here
%output:
%     - w_x: parameters for the thin plate splines model in x coord
%     - w_y: parameters for the thin plate splines model in y coord
%     -   E: bending energy
%input:
%     - X:         points in the template shape
%     - Y:         corresponding points in the target shape
%     - lambda:    regularization parameter
%    
%    
%       Author: Chao Ni, 30.11.2020
%               chaoni@ethz.ch
n = size(X,1);
P = [ones(n,1) X];
K = U(sqrt(dist2(X,X)));
%solve the equation Ax=b
A = [[K + lambda*eye(n) P];[P' zeros(3)]];
bx = [Y(:,1); zeros(3,1)];
by = [Y(:,2); zeros(3,1)];

w_x = A\bx;
w_y = A\by;
E = w_x(1:n)'*K*w_x(1:n) + w_y(1:n)'*K*w_y(1:n);
end

function u = U(t)
u = t.^2.*log(t.^2);
u(isnan(u)) = 0;
end
