function [C] = chi2_cost(s1,s2)
%CHI2_COST compute a cost matrix between two sets of shape context
%output:
%     - C: the cost matrix for matching two sets of shape context
%     descriptors s1 and s2: (N * M)
%input:
%     - s1:             first shape context descriptor: (N*K)
%     - s2:             second shape context descriptor: (M*K)
% 
% 
%       Author: Chao Ni, 30.11.2020
%               chaoni@ethz.ch

C = zeros(size(s1,1),size(s2,1));
for ii = 1: size(s1,1)
    for jj = 1: size(s2,1)
        cost = 1/2.* (s1(ii,:) - s2(jj,:)).^2 ./ (s1(ii,:) + s2(jj,:));
        cost(isnan(cost)) = 0;
        C(ii,jj) = sum(cost,'all');
    end
end
end

