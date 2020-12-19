function vPoints = grid_points(img,nPointsX,nPointsY,border)
% Generate a list of grid points, given the image clip and number of points
% required on each dimension and the total border length (pixel-wise)
%
% Input:
%      img         :  image that need to be grided, gray image for now, (n,m);
%      nPointsX    :  number of points that needs to be collected in x
%                     direction, therefore (nPoints-1) segment;
%      nPointsY    :  number of points that needs to be collected, y
%                     direction;
%      border      :  number of pixels of the area surrounding the feature
%                     that is not gridded;
%
% Output:
%      vPoints     :  a list of grid points  (nPointsX*nPointsY,2);
%      
%
%         author   :  Chao Ni (chaoni@ethz.ch)
%         date     :  17.12.2020    

vPoints = zeros(nPointsX*nPointsY,2);
x_coord = linspace(border+1,size(img,1)-border,nPointsX);
y_coord = linspace(border+1,size(img,2)-border,nPointsY);
for i = 1:nPointsX
    vPoints((i-1)*nPointsY+1:i*nPointsY,1) = x_coord(i);
    vPoints((i-1)*nPointsY+1:i*nPointsY,2) = y_coord;
end

end
