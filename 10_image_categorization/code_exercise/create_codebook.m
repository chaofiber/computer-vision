function vCenters = create_codebook(nameDirPos,nameDirNeg,k)
% Generate createbook (dictory of visual words) given all images and a
% cluster size, using k-means to cluster. For each image, we will generate
% N feature (N is the number of grids, feature has size (N,128)),
% among all those features (N* #imgs), we use k-means to classify them.
% 
% Output:
%     vCenters: center of all high-dimensional features, size (k,
%     P=128),128 is the feature length for each image
  vImgNames = dir(fullfile(nameDirPos,'*.png')); % change to jpg for my own data
  vImgNames = [vImgNames; dir(fullfile(nameDirNeg,'*.png'))];
  
  nImgs = length(vImgNames);
  vFeatures = zeros(0,128); % 16 histograms containing 8 bins, no rows yet
  vPatches = zeros(0,16*16); % 16*16 image patches 
  
  cellWidth = 4;
  cellHeight = 4;
  nPointsX = 10;
  nPointsY = 10;
  border = 8;
  
  % Extract features for all images
  for i=1:nImgs
    
    disp(strcat('  Processing image ', num2str(i),'...'));
    
    % load the image
    img = double(rgb2gray(imread(fullfile(vImgNames(i).folder,vImgNames(i).name))));

    % Collect local feature points for each image
    % and compute a descriptor for each local feature point
    vPoints = grid_points(img,nPointsX,nPointsY,border);

    % create hog descriptors and patches
    [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight);
    
    vFeatures = [vFeatures; descriptors];
    vPatches = [vPatches; patches];
    
  end
  disp(strcat('    Number of extracted features:',num2str(size(vFeatures,1))));

  % Cluster the features using K-Means
  disp(strcat('  Clustering...'));
  [~,vCenters] = kmeans(vFeatures,k);
  
  
  % Visualize the code book  
  disp('Visualizing the codebook...');
  visualize_codebook(vCenters,vFeatures,vPatches,cellWidth,cellHeight);
%   disp('Press any key to continue...');
%   pause;
  

end