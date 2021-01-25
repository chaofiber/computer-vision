function [map peaks] = meanshiftSeg(img)
% Implement the mean Shift image segmentation algorithm
% Input:
%        img    :   L*a*b* type image, size (n,m,3)
% Output: 
%        map    :   matrix with the same size as img, it holds the id of 
%                  the associated peak for each pixel. (n,m), such that
%                  map(i,j) = c <=> peak(i,j) = peaks(c)
%        peaks  :   a list of peak for each pixel, each pixel
%                  denotes a color;
%
%
%         author:  Chao Ni (chaoni@ethz.ch)
%         date  :  15.12.2020

img = double(img);
L = size(img,1)*size(img,2);
X = [reshape(img(:,:,1),[L,1]),reshape(img(:,:,2),[L,1]),reshape(img(:,:,3),[L,1])];

% a user-defined parameter: control the search window
r = 25;

% initialization
map = zeros(size(img(:,:,1)));

% for each pixel, find the peak
for i = 1:L
    peak = find_peak(X,X(i,:),r);
    if (i==1); peaks = peak; continue; end
    % check if the peak is too close to existing peaks
    dists = sqrt(sum((peaks - repmat(peak,size(peaks,1),1)).^2,2));
    idx = peaks(dists<r/2);
    if isempty(idx)
        peaks = [peaks; peak];
        % because X is constructed column by column, so it is safe to use
        % map(i) directly to give value to a two-dim image
        map(i) = size(peaks,1);
    else
        % merge peaks that are close and find the index, if there are
        % multiple options, choose the closet one to merge
        [~,map(i)] = min(dists);
    end 
    if mod(i,100)==0; fprintf('progressing: %f, \n',i/L);end
end