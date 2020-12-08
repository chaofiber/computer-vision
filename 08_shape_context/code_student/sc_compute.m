function d = sc_compute(X, nbBins_theta, nbBins_r, smallest_r, biggest_r)
%SC_COMPUTE computes the shape context descriptots for a set of points
%output:
%     - d: the shape context descriptoys for all input points
%           (n * K: K = nbBins_theta*nb_Bins_r)
%input:
%     - X:              set of points, in cartesian coordinate, (n,2)shape
%     - nbBins_theta:   number of bins in the angular dimension
%     - nbBins_r:       number of bins in the radical dimension
%     - smallest_r:     the length of the smallest radius
%     - biggest_r:      the length of the biggest radius
%                                                                                                                                  
% 
% 
%       Author: Chao Ni, 30.11.2020
%               chaoni@ethz.ch

X = X';
n = size(X,1);  disp(n);
r_min = log(smallest_r);
r_max = log(biggest_r);
dr = (r_max - r_min) / nbBins_r;
dtheta = 2*pi/nbBins_theta;
norm = mean2(sqrt(dist2(X,X)));
d = zeros(n, nbBins_r*nbBins_theta);

for ii = 1:n
    X_rel = setdiff(X,X(ii,:),'rows') - X(ii,:);
    [theta_list, r_list] = cart2pol(X_rel(:,1), X_rel(:,2));
    theta_list = theta_list + 2*pi*(theta_list<0);
    % compute the index among the K bins: a unique indexing method: set the
    % index of the related bin as:  (n_theta-1)*nbBins_r + n_r
    % todo: need to recompute the n_theta, as sometimes it is below zero
    % while the idx is above zero. However, such cases should be
    % eliminated.
    n_theta = ceil(theta_list / dtheta);
    n_r = ceil((log(r_list/norm) - r_min) / dr);
    idx = (n_theta - 1).* nbBins_r + n_r;
    if (size(idx,1))>0
        for jj = 1:size(idx,1)
            if idx(jj) > 0
                d(ii,idx(jj)) = d(ii,idx(jj)) + 1;
            end
        end
    end
end

