function [peak] = find_peak(X,xl,r)
%FIND_PEAK find the mode of the density function for a given pixel xl
%          the distance is in the sense of color density, therefore need to
%          compute the distance to the current pixel for each pixels,
%          becase the shape of that cluster is arbitry.
%Input:
%         X    :  discrete samples of the density function, size(L,3) where
%                 L = n*m is the number of all pixels, 3 is the color channel
%         xl   :  a given pixel, size(1,3), denotes the color
%         r    :  radius within which should be considered to compute the
%                 mean (peak)
%Output:
%         peak :  peak pixel for xl, the same size as
%                 xl, size(1,3), it denotes the color that the pixel xl
%                 should belong to
%
%
%         author:  Chao Ni (chaoni@ethz.ch)
%         date  :  15.12.2020

peak_pre = xl;
tol = 1;
while true
    dists = sqrt(sum((X - repmat(peak_pre,[size(X,1),1])).^2,2));
    peak = mean(X(dists<r,:));
    shift = norm(peak_pre-peak);
    if shift<tol; break; end
    peak_pre = peak;
end

end

