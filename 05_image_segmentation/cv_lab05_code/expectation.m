function P = expectation(mu,var,alpha,X)
% compute the probability that x is in segment k, given current guess of
% \theta, the expectration step of EM algorithm
% Input:
%      mu    :  mean parameter (K,n)
%      var   :  covariance matrix parameter (n,n,K), where n is the
%               dimenstion of each pixel: 3
%      alpha :  weight parameter (1,K)
%      X     :  input image (n*m,3) -- (L,3)
% Output:
%      P     :  (L,K), P(i,j) denotes the probability of pixel i belongs to
%               the custer j
%
%
%         author:  Chao Ni (chaoni@ethz.ch)
%         date  :  15.12.2020


K = length(alpha);
% N = size(imgSqueezed,1);
L = size(X,1);
n = size(var,1);
P = zeros(L,n);

for i = 1:L
    for k = 1:K
        P(i,k) = alpha(k)*exp(-0.5*(X(i,:)-mu(k,:))*pinv(var(:,:,k))*(X(i,:)-mu(k,:))') ...
                 / ((2*pi)^(3/2)*det(var(:,:,k))^0.5);
    end
    P(i,:) = P(i,:) / sum(P(i,:));
end

end