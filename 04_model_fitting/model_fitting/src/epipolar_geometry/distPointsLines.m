% Compute the distance for pairs of points and lines
% Input
%   points    Homogeneous 2D points 3xN
%   lines     2D homogeneous line equation 3xN
% 
% Output
%   d         Distances from each point to the corresponding line N
function d = distPointsLines(points, lines)
% distance from a point (x,y,1) to a line (ax+by+c=0) is
% distance = abs(ax+by+c)/sqrt(a^2+b^2)
n = size(points,2);
d = zeros(1,n);
for ii = 1:n
    d(ii) = abs(points(:,ii)'*lines(:,ii))/ sqrt(lines(1,ii)^2 + lines(2,ii)^2);
end
end

