% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)
 % filter our keypoints that are too close to the edge
 [n, m] = size(img);
 patch_size = int32(9);
 half_size = idivide(patch_size,2);
 new_corners = [];
 descriptors = [];
 for ii = 1:size(keypoints,2)
     if keypoints(1,ii)<=half_size || keypoints(1,ii)>=n-half_size+1 || ...
         keypoints(2,ii)<=half_size || keypoints(2,ii)>=m-half_size+1
         continue;
     end
     new_corners = [new_corners, keypoints(:,ii)];
 end
 keypoints = new_corners;
 descriptors = extractPatches(img, keypoints, patch_size);
     
end