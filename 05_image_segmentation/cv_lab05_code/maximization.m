function [mu, var, alpha] = maximization(P, X)
% update the parameters mean, covariance matrix and weights based on the expectation
% the maximization step of EM algorithm
% Input:
%      P     :  (L,K), P(i,j) denotes the probability of pixel i belongs to
%               the custer j
%      X     :  input image (width*height,3) -- (L,3)
% Output:
%      mu    :  mean parameter (K,n)
%      var   :  covariance matrix parameter (n,n,K), where n is the
%               dimenstion of each pixel: 3
%      alpha :  weight parameter (1,K)
%
%         author:  Chao Ni (chaoni@ethz.ch)
%         date  :  15.12.2020


[L,K] = size(P);
n = size(X,2);
alpha = zeros(1,K);
mu = zeros(K,n);
var = zeros(n,n,K);

for k = 1:K
    alpha(k) = mean(P(:,k));
    mu(k,:) = ((P(:,k))'*X) / sum(P(:,k));
    for i = 1:L
        var(:,:,k) = var(:,:,k) + (X(i,:)-mu(k,:))'*(X(i,:)-mu(k,:))*P(i,k);
    end
    var(:,:,k) = var(:,:,k) / sum(P(:,k));
end

end