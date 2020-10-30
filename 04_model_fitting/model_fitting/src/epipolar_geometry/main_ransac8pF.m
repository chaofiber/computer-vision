% =========================================================================
% Feature extraction and matching
% =========================================================================
clear
addpath helpers

%don't forget to initialize VLFeat

%Load images
% imgName1 = ''; % Try with some different pairs
% imgName2 = '';
% imgName1 = 'images/rect1.jpg';
% imgName2 = 'images/rect2.jpg';
imgName1 = 'images/pumpkin1.jpg';
imgName2 = 'images/pumpkin2.jpg';
% imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
% imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';

img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
[matches, scores] = vl_ubcmatch(da, db);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];
% load('x1s_ladybug.mat','x1s');
% load('x2s_ladybug.mat','x2s');
% load('x1s_pumpkin.mat','x1s');
% load('x2s_pumpkin.mat','x2s');
% load('x1s_rect.mat','x1s');
% load('x2s_rect.mat','x2s');

% to save file and compare different threshold
% save('x1s_rect.mat','x1s');
% save('x2s_rect.mat','x2s');
% save('x1s_ladybug.mat','x1s');
% save('x2s_ladybug.mat','x2s');
% save('x1s_pumpkin.mat','x1s');
% save('x2s_pumpkin.mat','x2s');

%show matches
% clf
% showFeatureMatches(img1, x1s(1:2,:), img2, x2s(1:2,:), 1);

%%
% =========================================================================
% 8-point RANSAC
% =========================================================================

threshold = 5;

% TODO: implement ransac8pF
[inliers, F] = ransac8pF(x1s, x2s, threshold);

showFeatureMatches(img1, x1s(1:2, inliers), img2, x2s(1:2, inliers), 1);


% =========================================================================