function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
  % find matches in the sense of find the closest patch --> minimum
  % square distance
  histo = zeros(size(vCenters,1),1);
  for i = 1:size(vFeatures,1)
      [~,idx] = min(sum((vCenters-vFeatures(i,:)).^2,2));
      histo(idx) = histo(idx) + 1;
  end
end
