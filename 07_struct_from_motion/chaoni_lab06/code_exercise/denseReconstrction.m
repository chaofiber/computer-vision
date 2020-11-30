

%%
% Rectify images

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.001.pgm';

% img1 = single(imread(imgName1));
% img2 = single(imread(imgName2));

scale = 0.5^2; % try this scale first
%scale = 0.5^3; % if it takes too long for GraphCut, switch to this one

imgL = imresize(imread(imgName1), scale);
imgR = imresize(imread(imgName2), scale);



[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);

figure(1);
subplot(121); imshow(imgRectL);
subplot(122); imshow(imgRectR);


%% extract SIFT features and match
[fa, da] = vl_sift(single(imgRectL));
[fb, db] = vl_sift(single(imgRectR));
[matches, scores] = vl_ubcmatch(da, db);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];

diff = abs(x2s - x1s);
diff_x = diff(1,:);
dispRange = -ceil(quantile(diff_x,0.95)):ceil(quantile(diff_x,0.95));

%% Graph-cut stereo matching
Labels = ...
    gcDisparity((imgRectL), (imgRectR), dispRange);
dispsGCL = double(Labels + dispRange(1));
Labels = ...
    gcDisparity((imgRectR), (imgRectL), dispRange);
dispsGCR = double(Labels + dispRange(1));

figure(1);
subplot(121); imshow(dispsGCL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispsGCR, [dispRange(1) dispRange(end)]);

%%
thresh = 8;

maskLRcheck = leftRightCheck(dispsGCL, dispsGCR, thresh);
maskRLcheck = leftRightCheck(dispsGCR, dispsGCL, thresh);

maskGCL = double(maskL).*maskLRcheck;
maskGCR = double(maskR).*maskRLcheck;

figure(2);
subplot(121); imshow(maskGCL);
subplot(122); imshow(maskGCR);

%% creating dense reconstruction
create3DModel(dispsGCL, imgRectL, 1);
% saveas(gcf,'../data/dense.png');
