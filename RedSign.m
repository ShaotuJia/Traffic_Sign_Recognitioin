%This function is to threshold Red Signs

function imgSign = RedSign(image)

%read image and convert to HSV
imgHSV = rgb2hsv(image);

%Separate HSV channel and remove noise
imgH = medfilt2(imgHSV(:,:,1));
imgS = medfilt2(imgHSV(:,:,2));
imgV = medfilt2(imgHSV(:,:,3));

% Initialize Sign Image
sz = size(imgHSV(:,:,1));
imgSign = zeros(sz,'logical');

%color threshold image in HSV color space
%the red color Hue between 0 ~ 0.04
for i = 1 : length(imgH(:,1))
    for j = 1 : length(imgH(1,:))
        if imgH(i,j,1) >= 0 && imgH(i,j,1) < 0.04 
            imgSign(i,j,1) = 1;
        else
            imgSign(i,j,1) = 0;
        end
    end
end


%Binary Image post-processing
imgSign = bwareaopen(imgSign,20);
imgSign = imfill(imgSign,'holes');
seY = strel('disk' , 5);
imgSign = imclose(imgSign,seY);

%show image
imshow(imgSign);

            


