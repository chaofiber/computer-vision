close all;
data = load('dataset.mat');
objects = data.objects;

nbObjects = length(objects);
nbSamples = 200;
display_flag = true;

% heart
% X = objects(1).X;
% Y = objects(2).X;

% folk
% X = objects(8).X;
% Y = objects(9).X;

% watch
X = objects(13).X;
Y = objects(12).X;

X = get_samples(X,nbSamples);
Y = get_samples(Y,nbSamples);

[cost] = shape_matching(X,Y,display_flag);