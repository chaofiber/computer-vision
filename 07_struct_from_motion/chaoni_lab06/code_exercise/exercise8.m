% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

figure(20), showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20, 'b');

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
x1s = makehomogeneous(fa(1:2,matches(1,:)));
x2s = makehomogeneous(fb(1:2,matches(2,:)));
threshold = 0.0001;
threshold_proj = 0.05;
[F, inliers] = ransacfitfundmatrix(x1s, x2s, threshold);

% show clicked points
figure(100),clf, imshow(img1, []); hold on; plot(x1s(1,inliers), x1s(2,inliers), '*r');
figure(200),clf, imshow(img2, []); hold on; plot(x2s(1,inliers), x2s(2,inliers), '*r');
% draw epipolar lines in img 1
x1s_inlier = x1s(:,inliers);
x2s_inlier = x2s(:,inliers);
figure(100)
for k = 1:size(x1s_inlier,2)
    drawEpipolarLines(F'*x2s_inlier(:,k), img1); hold on;
end
saveas(gcf,'../data/epipolor1.png');
% draw epipolar lines in img 2
figure(200)
for k = 1:size(x2s_inlier,2)
    drawEpipolarLines(F*x1s_inlier(:,k), img2);
end
saveas(gcf,'../data/epipolor2.png');

figure(1), showFeatureMatches(img1, x1s(1:2, inliers), img2, x2s(1:2, inliers), 1, 'b'); hold on;
outliers = setdiff(1:size(matches,2),inliers);
showFeatureMatches(img1, x1s(1:2, outliers), img2, x2s(1:2, outliers), 2,'r');
saveas(gcf,'../data/04initial.png');

% compute essential matrix: approx K = K' (two cameras have same intrinsic
% matrix
E = K'*F*K;
x1_calibrated = K^-1 * x1s(:,inliers);
x2_calibrated = K^-1 * x2s(:,inliers);

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the **inlier matches** with the computed projection matrix
[X2, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);  %XS 4D homogeneous coordinate, in normalized coordiante
%% Add an addtional view of the scene: image 1

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
fa = fa(:,matches(1,inliers));
da = da(:,matches(1,inliers));
[matches, scores] = vl_ubcmatch(da, dc);
x1s = makehomogeneous(fa(1:2,matches(1,:)));
x3s = makehomogeneous(fc(1:2,matches(2,:)));
x1_calibrated = K^-1 * x1s;
x3_calibrated = K^-1 * x3s;

%run 6-point ransac
[Ps{3}, inliers] = ransacfitprojmatrix(x3_calibrated, X2(:,matches(1,:)), threshold_proj);
if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end

% plotting inliers match and outliers match
figure(3), showFeatureMatches(img1, x1s(1:2, inliers), img3, x3s(1:2, inliers), 3,'b'); hold on;
outliers = setdiff(1:size(matches,2),inliers);
showFeatureMatches(img1, x1s(1:2, outliers), img3, x3s(1:2, outliers), 4,'r');
saveas(gcf,'../data/adding1.png');
%triangulate the inlier matches with the computed projection matrix
[X3,~] = linearTriangulation(Ps{1}, x1_calibrated(:,inliers), Ps{3}, x3_calibrated(:,inliers));
%% Add an additional view: image 2: new matches, new inliers

imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);

%match against the features from image 1 that where triangulated
fa = fa(:,matches(1,inliers));
da = da(:,matches(1,inliers));
[matches, scores] = vl_ubcmatch(da, dd);
x1s = makehomogeneous(fa(1:2,matches(1,:)));
x4s = makehomogeneous(fd(1:2,matches(2,:)));
x1_calibrated = K^-1 * x1s;
x4_calibrated = K^-1 * x4s;


%run 6-point ransac
[Ps{4}, inliers] = ransacfitprojmatrix(x4_calibrated, X3(:,matches(1,:)), threshold_proj);
if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end

% plotting inliers match and outliers match
figure(5), showFeatureMatches(img1, x1s(1:2, inliers), img4, x4s(1:2, inliers), 5,'b'); hold on;
outliers = setdiff(1:size(matches,2),inliers);
showFeatureMatches(img1, x1s(1:2, outliers), img4, x4s(1:2, outliers), 6,'r');
saveas(gcf,'../data/adding2.png');
%triangulate the inlier matches with the computed projection matrix
[X4,~] = linearTriangulation(Ps{1}, x1_calibrated(:,inliers), Ps{4}, x4_calibrated(:,inliers));

%% Add an additional view: image 3: new matches, new inliers

imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

%match against the features from image 1 that where triangulated
fa = fa(:,matches(1,inliers));
da = da(:,matches(1,inliers));
[matches, scores] = vl_ubcmatch(da, de);
x1s = makehomogeneous(fa(1:2,matches(1,:)));
x5s = makehomogeneous(fe(1:2,matches(2,:)));
x1_calibrated = K^-1 * x1s;
x5_calibrated = K^-1 * x5s;


%run 6-point ransac
[Ps{5}, inliers] = ransacfitprojmatrix(x5_calibrated, X4(:,matches(1,:)), threshold_proj);
if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
    Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
end

% plotting inliers match and outliers match
figure(7), showFeatureMatches(img1, x1s(1:2, inliers), img5, x5s(1:2, inliers), 7,'b');
outliers = setdiff(1:size(matches,2),inliers);
showFeatureMatches(img1, x1s(1:2, outliers), img5, x5s(1:2, outliers), 8,'r');
saveas(gcf,'../data/adding3.png');
%triangulate the inlier matches with the computed projection matrix
[X5,~] = linearTriangulation(Ps{1}, x1_calibrated(:,inliers), Ps{5}, x5_calibrated(:,inliers));
%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
plot3(X2(1,:),X2(2,:),X2(3,:),'r.'); hold on;
plot3(X3(1,:),X3(2,:),X3(3,:),'g.'); hold on;
plot3(X4(1,:),X4(2,:),X4(3,:),'b.'); hold on;
plot3(X5(1,:),X5(2,:),X5(3,:),'y.'); hold on;

%draw cameras
drawCameras(Ps, fig);
saveas(gcf,'../data/camera.png');


%% dense reconstruction
denseReconstrction;