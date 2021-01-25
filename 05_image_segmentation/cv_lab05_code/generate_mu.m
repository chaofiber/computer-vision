% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X, K)
% Spread them equally in the range
% Input:
%      X     :  input image (width*height,3) -- (L,3)
%      K     :  cluster size scalar
% Output:
%      mu    :  mean parameter (K,3)
%
%
%         author:  Chao Ni (chaoni@ethz.ch)
%         date  :  15.12.2020

mu =  zeros(K,3);
for i = 1:3
    range = linspace(min(X(:,i)),max(X(:,i)),K+2);
    mu(:,i) = range(2:K+1);
end

end