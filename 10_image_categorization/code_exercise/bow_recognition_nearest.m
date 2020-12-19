function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor (using knnsearch) in the positive and negative sets
  % and decide based on this neighbor. For each image, we have its feature
  % as histogram, a vector with size 200 (codebook size)
  [~,DistPos] = knnsearch(vBoWPos, histogram);
  [~,DistNeg] = knnsearch(vBoWNeg, histogram);
  
  if (DistPos<DistNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
