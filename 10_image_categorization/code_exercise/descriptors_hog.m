function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)
% For each grid point (feature), generate a descriptor known as histogram
% of oriented gradients (HOG) descriptor.
%
% Input:
%      img         :  image  (n,m);
%      vPoints     :  a list of grid points  (N,2);  
%      cellWidth   :  number of pixels each cell has width wise;
%      cellHeight  :  number of pixel each cell has height wise;
%
% Output:
%      descriptors :  a list of descriptors, each descriptor is
%                     corresponding to a grid point, and has a dimension of
%                     128: for each cell, create an 8-bin histogram,
%                     manually set 4*4=16 cells leads to 128 demension
%                     after concatenation;  (N,128)
%      patches     :  a list of patches; (N,16*16) 16 because 4 cells and
%                     each cell has size 4 pixel;
%
%         author   :  Chao Ni (chaoni@ethz.ch), adapted from exercise
%         date     :  17.12.2020    


    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; % better to be even numbers, otherwise it would be tricky to define the center

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(size(vPoints,1),nBins*nCellsW*nCellsH);
    patches = zeros(size(vPoints,1),pw*ph); 
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = atan2(grad_y, grad_x); 
    
    for i = 1:size(vPoints,1) % for all local feature points
        img_patch = img(floor(vPoints(i,1)-w*nCellsW/2):floor(vPoints(i,1)-w*nCellsW/2)+pw-1,...
                        floor(vPoints(i,2)-h*nCellsH/2):floor(vPoints(i,2)-h*nCellsH/2)+ph-1);
        patches(i,:) = img_patch(:);
        %for each grid point, compute 16 cells, each cell a 8 bin histogram
        hist = zeros(nCellsH*nCellsW,nBins);
        for j = 1:nCellsH
            for k = 1:nCellsW
                cell = Gdir(floor(vPoints(i,1)-w*nCellsW/2):floor(vPoints(i,1)-w*nCellsW/2)+cellWidth-1,...
                            floor(vPoints(i,2)-h*nCellsH/2):floor(vPoints(i,2)-h*nCellsH/2)+cellHeight-1);
                hist((j-1)*nCellsW+k,:) = histcounts(cell,nBins);
            end
        end
        descriptors(i,:) = reshape(hist',[1,nCellsW*nCellsH*nBins]);
    end % for all local feature points
    
end
