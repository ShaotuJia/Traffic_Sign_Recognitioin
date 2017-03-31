%This function is to find aspect ratio (height/width) of blob
%The input is blob properties
%The output will be aspect ratio

function ratio = AspectRatio(blob)

%find aspect ratio for triangle traffic sign
height = blob.BoundingBox(4);
width = blob.BoundingBox(3);
ratio = height/width;

end