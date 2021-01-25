function exercise5()
close all;
% load image
img = imread('cow.jpg');
% for faster debugging you might want to decrease the size of your image
% (use imresize)
% (especially for the mean-shift part!)

figure, imshow(img), title('original image')

% smooth image (6.1a)
% (replace the following line with your code for the smoothing of the image)
filter = fspecial('gaussian',[5,5],5.0);
imgSmoothed = imfilter(img, filter);
figure, imshow(imgSmoothed), title('smoothed image');

% convert to L*a*b* image (6.1b)
% (replace the folliwing line with your code to convert the image to lab
% space
C = makecform('srgb2lab');
imglab = applycform(imgSmoothed, C);
figure, imshow(imglab), title('l*a*b* image');

% (6.2)
[mapMS peak] = meanshiftSeg(imglab);
visualizeSegmentationResults (mapMS,peak);
% 
%% (6.3)
[mapEM, cluster] = EM(imglab);
visualizeSegmentationResults (mapEM,cluster);

end