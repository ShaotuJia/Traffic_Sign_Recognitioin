%This script is to read input images as a video

clc;
clear;
close all;

%Making videos 
DrawBox = VideoWriter ('BoundingBox.avi');
DrawBox.FrameRate = 10;
open(DrawBox);

%for k = 0 : 2860 
 for k = 0 : 100   
    N = 32640; % The number of first image
    NP = N + k; % NP is the number of present image
    imageName = strcat('image.0',num2str(NP),'.jpg');
    fullname = fullfile('input',imageName);
    
    try 
        img = imread(fullname);
        figure (1), imshow(img); 
        hold on;
        
        %boundingbox red sign
        %RedSign(img);
        %boundingbox blue sign
        %BlueSign(img); 
        
        %find blue and red sign
        TrafficSign(img);
        
        %Get frames
        Box = getframe(figure(1));
        writeVideo(DrawBox, Box);
        
    catch
        disp('miss image:');
        disp(fullname);
    end
            
 end

 close(DrawBox);
