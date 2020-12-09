function [hist] = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)
% Calculate the normalized histogram of RGB colors occurring within the
% bounding box defined b y [xMin, xMax]*[yMin,yMax] within the current
% video frame. The histogram is obtained by binning each color channel into
% hist_bin bins
% 
%
% Input: 
%        xMin, yMin,
%        xMax, yMax  :   define the bounding box
%        frame       :   image used for computing
%        hist_bin    :   number of bins used
% Output: 
%        hist        :   histogram of the color: (hist_bin,3)
%        Author  :   Chao Ni, chaoni@ethz.ch
%        Date    :   08.12.2020

xMin = round(max(1,xMin));
yMin = round(max(1,yMin));
xMax = round(min(xMax, size(frame,2)));
yMax = round(min(yMax, size(frame,1)));

% R,G,B are hist_bin*1 arraies containing number of counts, ~ are the
% related bin distribution
[R, ~] = imhist(frame(yMin:yMax,xMin:xMax,1),hist_bin);
[G, ~] = imhist(frame(yMin:yMax,xMin:xMax,2),hist_bin);
[B, ~] = imhist(frame(yMin:yMax,xMin:xMax,3),hist_bin);

hist = [R;G;B];
% normalize hist: 
% todo: how to normalize, color channer wise?
hist = hist ./ sum(hist, 'all');
end

