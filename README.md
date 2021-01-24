# ETH Computer Vision lecture: small projects

My overall grade: 98.2/100 among all ten projects.

## 1. Calibration 
In this exercise, direct linear transform and Gold standard algorithm are implemented to compute the intrinsic and extrinsic parameters of the camera. The projection error is also introduced and derived.
<!-- ![image calibration](01_calibration/calibratedDlt.png) -->
<img src = "01_calibration/calibratedDlt.png" class="center" width="400">

- Some key points: 
    - Normalization matrix and we should base on the distance scale (instead of the axis-wise normalization)
    - Using LDT to compute P, and decompose P (do not forget denormalization for computing P)
    - Using QR decomposition to get R and K, using PC = 0 to get the camera position.

## 2. Local features
In this image, pixel value based local feature detection and matching is implemented.
<!-- ![local feature](02_local_features/chaoni_lab02/images/match3.png) -->
<img src = "02_local_features/chaoni_lab02/images/match3.png" class="center" width="400">

- Use kernels to compute image gradient (MATLAB conv will take care of the boundary conditions)
- Patches are used to describe the interesting points, and Harris response function is used to compute the corner point
- Feature Matching is also implemented
    - Single way matching, mutual nearest neighbors, ratio test.

## 3. Particle filtering
No report required for this lab, one can directly check the code.

## 4. Model Fitting
In this lab we implement the RANSAC and its variant and use it to compute the fundamental matrix.

<img src = "04_model_fitting/model_fitting/src/epipolar_geometry/Figures/singularrect1_epipolar.png" class="center" width="400">

- RANSAC: randomly select points and pick the best selection (for fundamental matrix computing)
- Adaptive RANSAC: Generally we terminate RANSAC after M trails if we know with a probability p that at least one of the random samples from these M trails is free from outliers: **p=1-(1-r^N)^M**. where r is the largest inlier ratio found so far at every RANSAN iteration. 
    - p is given, we need to terminate when this equation holds based on the changing variable M and r. (N=8 for computing fundamental matrix)
- Epipolar geometry: we need to draw epipolar lines based on the correspondences --> **l'=Fx, l = F^Tx**, if we enforce singularity constraint, then we for sure there will be a non-zero vector which is the eigen-vector for the matrix F. Therefore we can see all epipolar lines intersect exactly.