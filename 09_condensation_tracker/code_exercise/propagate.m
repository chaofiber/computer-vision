function [particles] = propagate(particles,sizeFrame,params)
%PROPAGATE the particles given the system prediction model (matrix A) and
%the system model noise represented by params
% Input: 
%        particles   :   (n_particles, state_dim(2 or 4))
%        sizeFrame   :   size of the frame
%        params      :   useful parameters
% Output: 
%        particles   :   propagated particles
%
%        Author  :   Chao Ni, chaoni@ethz.ch
%        Date    :   08.12.2020


%  no motion at all
if params.model == 0
    A = eye(2);
    W = normrnd(0,params.sigma_position,params.num_particles,2);
else
% assume time step as 1
    A = [1 0 1 0;
         0 1 0 1;
         0 0 1 0;
         0 0 0 1];
    W_pos = normrnd(0,params.sigma_position,params.num_particles,2);
    W_vel = normrnd(0,params.sigma_velocity,params.num_particles,2);
    W = [W_pos,W_vel];
end

% W = repmat(W',params.num_particles,1); % n*4
particles = particles * A' + W;

particles(:,1) = min(particles(:,1),sizeFrame(2));
particles(:,1) = max(particles(:,1),1);
particles(:,2) = min(particles(:,2),sizeFrame(1));
particles(:,2) = max(particles(:,2),1);
end

