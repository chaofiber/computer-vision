% Generate initial values for the K
% covariance matrices

function cov = generate_cov(X, K)
% initialize with a diagnol matrix with range of X in three-dimension as its element
% Input:
%      X     :  input image (width*height,3) -- (L,3)
%      K     :  cluster size scalar
%
%
%         author:  Chao Ni (chaoni@ethz.ch)
%         date  :  15.12.2020

range = zeros(3,1);
range(1) = max(X(:,1)) - min(X(:,1));
range(2) = max(X(:,2)) - min(X(:,2));
range(3) = max(X(:,3)) - min(X(:,3));
cov = zeros(3,3,K);
for k = 1:K
    cov(:,:,k) = diag(range);
end

end