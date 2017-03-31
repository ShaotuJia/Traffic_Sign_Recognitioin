% This is the main script to show images
clc;
clear;
close all;

load('GT-00001.mat');

imageName = Filename{40};
image = imread(imageName);

imgSign = RedSign(image);

blob = MaxBlob(imgSign);
ratio = AspectRatio(blob);

figure (1), hold on;
imshow(imgSign), hold on;

%Draw boundingBox
rectangle('Position',blob.BoundingBox,'EdgeColor','r','LineWidth',3);

