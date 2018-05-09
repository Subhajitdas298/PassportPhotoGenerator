%% Detect objects using Viola-Jones Algorithm
% Author : Subhajit Das
% Date : 09/05/2018

%% clear
clc;
close all;
clear all;

%% Read the input image
[file,path] = uigetfile('*.jpg');
fullFileName = fullfile(path, file);
I = imread(fullFileName);

%% face detection

FDetect = vision.CascadeObjectDetector;

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

figure;
imshow(I); 
hold on;
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','r');
end
title('Detected Faces');
hold off;

%% generating passport photo
hToWRatio = input('Enter height to width ratio (default: 1.2) : ');
if isempty(hToWRatio)
     hToWRatio = 1.2;
end
scale = input('Enter height to scale (default: 1.8) : ');
if isempty(scale)
     scale = 1.8;
end

for i = 1:size(BB,1)
    x = BB(i, 1);
    y = BB(i, 2);
    w = BB(i, 3);
    h = BB(i, 3);
    
    m = w;
    a = m  * (scale * hToWRatio - 1);
    b = m * (scale - 1);
    currPhotoDim = [(x-b/2), (y-.4*a), (w+b), (h+a)];
    
    photo = imcrop(I, currPhotoDim);
    figure;
    imshow(photo);
    title(strcat('Passport Photo [', int2str(i), ']'));
end
