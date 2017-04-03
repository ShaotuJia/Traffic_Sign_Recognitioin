%This function is to threshold Red Signs

function blob = RedSign(image)

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
%sizeRow = length(imgH(:,1)) * 2 /3;
%ColStart = uint32(length(imgH(1,:)) / 3);

%color threshold image in HSV color space
%the red color Hue between 0 ~ 0.1
%Saturation between 0.5 ~ 1
for i = 1 : length(imgH(:,1))
    for j = 1 : length(imgH(1,:))
        if imgH(i,j,1) >= 0 && imgH(i,j,1) < 0.06 && imgS(i,j) >= 0.5 && imgS(i,j) <=1
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

%!!TEST!!!
%show binary image
%imshow(imgSign);
%hold on;

%find best Blob; within admissiable aspect ratio; and largest area
blob = BestBlob(imgSign);

%{
if class(blob) == 'struct'
    rectangle('Position',blob.BoundingBox,'EdgeColor','r','LineWidth',3);
end
%}

end



            


