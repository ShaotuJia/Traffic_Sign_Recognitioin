%This function is to find traffic sign 

function TrafficSign(image)

%read image and convert to HSV
imgHSV = rgb2hsv(image);

%Separate HSV channel and remove noise
imgH = medfilt2(imgHSV(:,:,1));
imgS = medfilt2(imgHSV(:,:,2));


% Initialize Sign Image
sz = size(imgHSV(:,:,1));
imgSignR = zeros(sz,'logical');
imgSignB = zeros(sz,'logical');

%The sign might not to occur in lower one-thrid of the image
%To reduce computation load, here ignore the lower one-thrid of the image
sizeRow = length(imgH(:,1)) * 2 /3;
ColStart = uint32(length(imgH(1,:)) / 3);

%color threshold image in HSV color space
%the red color Hue between 0 ~ 0.
%Saturation between 0.5 ~ 1
for i = 1 : sizeRow
    for j = ColStart : length(imgH(1,:))
        %Detect Red sign
        if imgH(i,j,1) >= 0 && imgH(i,j,1) < 0.04 && imgS(i,j) >= 0.5 && imgS(i,j) <=1
            imgSignR(i,j,1) = 1;
        else
            imgSignR(i,j,1) = 0;
        end
        %Detect Blue Sign
        %Hue : 0.45 ~ 0.625
        %Saturation: > 0.6
        if imgH(i,j,1) >= 0.55 && imgH(i,j,1) < 0.625 && imgS(i,j) > 0.6
            imgSignB(i,j,1) = 1;
        else
            imgSignB(i,j,1) = 0;
        end
    end
end


%Binary Image post-processing for Red Sign
imgSignR = bwareaopen(imgSignR,10);
imgSignR = imfill(imgSignR,'holes');
seYR = strel('disk' , 20);
imgSignR = imclose(imgSignR,seYR);


%Binary Image post-processing for Blue Sign
imgSignB = bwareaopen(imgSignB,10);
imgSignB = imfill(imgSignB,'holes');
seYB = strel('disk' , 20);
imgSignB = imclose(imgSignB,seYB);

%!!TEST!!!
%show binary image
%imshow(imgSignB);
%hold on;

%find best Blob; within admissiable aspect ratio; and largest area
blobR = BlobSignR(imgSignR);
blobB = BlobSignB(imgSignB);

%!! TEST!!
%disp('blobB:');
%disp(blobB);

%Draw the Red sign Bounding Box
if max(size(blobR)) ~= 0
    for i = 1 : max(size(blobR))
    rectangle('Position',blobR(i).BoundingBox,'EdgeColor','r','LineWidth',3);
    hold on;
    end
end

%Draw the Blue Sign Bounding Box
if max(size(blobB)) ~= 0
    for j = 1 : max(size(blobB))
    rectangle('Position',blobB(j).BoundingBox,'EdgeColor','b','LineWidth',3);
    hold on;
    end
end
    

end
