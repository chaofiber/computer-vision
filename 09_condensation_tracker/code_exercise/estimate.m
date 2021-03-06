function [meanState] = estimate(particles,particles_w)
%ESTIMATE estimate the mean state given the particles and their weights
% Input: 
%        particles    :    (n_particles, state_dim(2 or 4))
%        particles_w  :    weights of all particles (n * 1)
% Output: 
%        meanState    :    estimated mean state (1*state_dim)
% 
% 
%        Author  :   Chao Ni, chaoni@ethz.ch
%        Date    :   08.12.2020

meanState = sum(particles.*particles_w,1);
% meanState = particles_w'*particles;
end

