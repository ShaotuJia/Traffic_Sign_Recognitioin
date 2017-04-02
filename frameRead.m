% This script is to test very frame

clear;
clc;
close all;

%construct frame name
NP = 32686;
imageName = strcat('image.0',num2str(NP),'.jpg');
fullname = fullfile('input',imageName);

img = imread(fullname);

%show image
imshow(img); 
hold on;

TrafficSign(img);

%BlueSign(img);
%RedSign(img);