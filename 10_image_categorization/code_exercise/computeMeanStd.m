function [mu sigma] = computeMeanStd(vBoW)
% Compute the mean and standard deviation of each column of the matrix vBox
% Input:
%     vBow  :  NxK, N images, each image has a histogram of K dimension
% Outpu:
%     mu    :  1xK
%     sigma :  1xK

mu = mean(vBoW);
sigma = std(vBoW);

end