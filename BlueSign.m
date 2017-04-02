%This function is to threshold Red Signs

function BlueSign(image)

%read image and convert to HSV
imgHSV = rgb2hsv(image);

%Separate HSV channel and remove noise
imgH = medfilt2(imgHSV(:,:,1));
imgS = medfilt2(imgHSV(:,:,2));


% Initialize Sign Image
sz = size(imgHSV(:,:,1));
imgSign = zeros(sz,'logical');

%The sign might not to occur in lower one-thrid of the image
%To reduce computation load, here ignore the lower one-thrid of the image
sizeRow = length(imgH(:,1)) * 2 /3;
ColStart = uint32(length(imgH(1,:)) / 3);

%color threshold image in HSV color space
%the blue color Hue between 0.55 ~ 0.625
%the Saturation > 0.6
for i = 1 : sizeRow
    for j = ColStart : length(imgH(1,:))
        if imgH(i,j,1) >= 0.55 && imgH(i,j,1) < 0.625 && imgS(i,j) > 0.6
            imgSign(i,j,1) = 1;
        else
            imgSign(i,j,1) = 0;
        end
    end
end

%Binary Image post-processing
imgSign = bwareaopen(imgSign,10);
imgSign = imfill(imgSign,'holes');
seY = strel('disk' , 20);
imgSign = imclose(imgSign,seY);

%!!!For TEST
%show binary image

imshow(imgSign);
hold on;



%find best blob; within aspect ratio range and max area
blob = BestBlob(imgSign);

if class(blob) == 'struct'
    rectangle('Position',blob.BoundingBox,'EdgeColor','b','LineWidth',3);
end

end



            


