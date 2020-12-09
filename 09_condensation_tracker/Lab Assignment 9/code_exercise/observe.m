function [particles_w] = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)
%OBSERVE compute for all particles its color histogram describing the
%bounding box defined by the center of the particle and W and H. These
%observations should be used to update the weights particle_w based on the
%chi^2 distance
% Input: 
%        particles     :   (n_particles, state_dim(2 or 4))
%        frame         :   image operated on
%        H, W          :   size of bounding box: height(y), width(x)
%        hist_bin      :   number of bins
%        hist_target   :   target color histogram
%        sigma_observe :   observation noise
% Output: 
%        particles_w   :   propagated particles weights
%
%        Author  :   Chao Ni, chaoni@ethz.ch
%        Date    :   08.12.2020

% position of the bounding box
% expect the size of the bounding box be odd, otherwise it's tricky to
% define the bounding box with center and size.
xMin =  particles(:,1) - W/2;
yMin =  particles(:,2) - H/2;
xMax =  particles(:,1) + W/2;
yMax =  particles(:,2) + H/2;

particles_w = zeros(size(particles,1),1);

for ii = 1:size(particles,1)
    hist_ii = color_histogram(xMin(ii),yMin(ii),xMax(ii),yMax(ii),frame,hist_bin);
    chi = chi2_cost(hist_ii,hist_target);
    particles_w(ii) = 1/(sqrt(2*pi)*sigma_observe) * exp(-chi*chi/(2*sigma_observe*sigma_observe));
end
particles_w = particles_w / sum(particles_w);
end

