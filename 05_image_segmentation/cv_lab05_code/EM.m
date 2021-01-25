function [map cluster] = EM(img)
% Implement the Mixture Gaissuan image segmentation algorithm
% Input:
%        img      :   L*a*b* type image, size (n,m,3)
% Output:
%        map      :   matrix with the same size as img, it holds the id of 
%                     the associated peak for each pixel. (n,m), such that
%                     map(i,j) = c <=> peak(i,j) = peaks(c)
%        cluster  :   a list of peak for each pixel, each pixel
%                     denotes a color;
%
%
%         author  :   Chao Ni (chaoni@ethz.ch)
%         date    :   15.12.2020


% iterate between maximization and expectation
% use function maximization
% use function expectation

img = double(img);
L = size(img,1)*size(img,2);
X = [reshape(img(:,:,1),[L,1]),reshape(img(:,:,2),[L,1]),reshape(img(:,:,3),[L,1])];

% user-defined cluster number
K = 5;

% initialization
map = zeros(size(img(:,:,1)));


% initialize mu and covariance, and alpha
mu_pre = generate_mu(X,K);
cov = generate_cov(X,K);
alpha = 1/K * ones(1,K);
tol = 0.1;
iter = 0;
while true
    % Expectation
    P = expectation(mu_pre,cov,alpha,X);
    % Maximization
    [mu, cov, alpha] = maximization(P,X);
    dist = norm(mu(:)-mu_pre(:));
    if mod(iter,1)==0; fprintf('progressing: %d iterations, mean update value: %f, \n',iter, dist);end
    if dist<tol; break; end
    mu_pre = mu;
    iter = iter + 1;
end

% softmax
[~, idx] = max(P,[],2);
map = reshape(idx,size(img,1),size(img,2));
cluster = mu;
disp(mu);
disp(cov);
disp(alpha);

end