function [particles, particles_w] = resample(particles,particles_w)
%RESAMPLE resample the particles based on their weights, and return the new
%particles along with their corresponding weights.
% Input: 
%        particles     :   (n_particles, state_dim(2 or 4))
%        particles_w   :   particle weights

% Output: 
%        particles     :   resampled particles
%        particles_w   :   new particles weights
%
%        Author  :   Chao Ni, chaoni@ethz.ch
%        Date    :   08.12.2020
[particles, index] = datasample(particles, size(particles,1),'Replace',true, 'Weights',particles_w);
particles_w = particles_w(index);
particles_w = particles_w / sum(particles_w,'all');
end

