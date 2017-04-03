%This function is to extract inside information blob from the BoundingBox
%@function BlueSign
%@Brief This is only for BLUE SIGN now !!!!

function Sign = ExtractSign(img)

Box = BlueSign(img);
try 
    
startRow = uint16(Box.BoundingBox(1));
startCol = uint16(Box.BoundingBox(2));
width = Box.BoundingBox(3);
height = Box.BoundingBox(4);

%Initialize imgSign
imgSign = uint8(zeros([height, width, 3]));

%Extract Sign
RowEnd = startRow + height -1; %minus 1 to avoid index exceeding
ColEnd = startCol + width -1;

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


