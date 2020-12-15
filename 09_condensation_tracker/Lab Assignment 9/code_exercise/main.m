%% 
close all;
clc;
clear;

%%
% VideoName = 'video1';
VideoName = 'myOwnVideo';
load('../data/params.mat');
params.model = 0;
params.initial_velocity = [0,0];
params.sigma_position = 50;
params.sigma_observe = 0.1;
% params.sigma_velocity = 0.1;
params.num_particles = 300;
params.hist_bin = 16;
params.alpha = 0.0;
%%
condensationTracker(VideoName,params);