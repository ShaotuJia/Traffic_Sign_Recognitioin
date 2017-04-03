%This function is to extract inside information blob from the BoundingBox
%@function RedSign
%@Brief This is only for RED SIGN now !!!!
function Sign = ExtractRedSign(img)

Box = RedSign(img);
try 
    
startRow = uint16(Box.BoundingBox(1));
startCol = uint16(Box.BoundingBox(2));
width = Box.BoundingBox(3);
height = Box.BoundingBox(4);

%Initialize imgSign
imgSign = uint8(zeros([height, width, 3]));

%Extract Sign
RowEnd = startRow + height; % avoid index exceeding the maximum dimension
if RowEnd > length(img(:,1,1))
    RowEnd = length(img(:,1,1));
end

ColEnd = startCol + width;
if ColEnd > length(img(1,:,1))
    ColEnd = length(img(1,:,1))
end

for i = startRow : RowEnd 
    for j = startCol : ColEnd
        imgSign(i-startRow+1,j-startCol+1,1) = img(i,j,1);
        imgSign(i-startRow+1,j-startCol+1,2) = img(i,j,2);
        imgSign(i-startRow+1,j-startCol+1,3) = img(i,j,3);
    end
end

Sign = imgSign;

catch 
    Sign = img;
    disp('non-struct array object');
end


end
