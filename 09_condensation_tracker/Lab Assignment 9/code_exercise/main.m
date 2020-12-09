%% 
close all;
clc;
clear;

%%
VideoName = 'video1';
load('../data/params.mat');
params.model = 1;

%%
condensationTracker(VideoName,params);