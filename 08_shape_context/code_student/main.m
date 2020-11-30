close all;
data = load('dataset.mat');
objects = data.objects;

nbObjects = length(objects);
nbSamples = 100;
display_flag = true;

X = objects(1).X;
Y = objects(2).X;

X = get_samples(X,nbSamples);
Y = get_samples(Y,nbSamples);

[cost] = shape_matching(X,Y,display_flag);