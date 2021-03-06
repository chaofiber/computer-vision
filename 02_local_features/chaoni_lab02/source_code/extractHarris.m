% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)

 [n,m] = size(img);
 % construct an auxilary matrix to allow the convolution coincide with
 % exercise notation
 D = zeros(n+1,m+1);
 D(2:n+1,2:m+1) = img;
 % constuct kernels
 K_x = [  0, 0,    0;
        0.5, 0, -0.5;
          0, 0,   0];
 K_y = K_x';
 Ix = conv2(K_x, D);
 Ix = Ix(2:n+1,2:n+1);
 Iy = conv2(K_y, D);
 Iy = Iy(2:n+1,2:n+1);

 % local auto-correlation matrix
 % need to enumerate over all pixels to compute the matrix M and eigen
 % values
 Ix2 = imgaussfilt(Ix.^2, sigma);
 Iy2 = imgaussfilt(Iy.^2, sigma);
 Ixy = imgaussfilt(Ix.*Iy, sigma);
 
 % Harris response function
 R = Ix2.*Iy2 - Ixy.^2 - k * (Ix2+Iy2).^2;
 C = R;
 
 % detection criteria: above threshold and local maximum in 3*3 neighbor
 regmax = imregionalmax(R,8);
 R = R.*regmax;
 idx = find(R>thresh);
 [rows,cols] = ind2sub(size(R),idx);
 corners = [rows';cols'];
 
end