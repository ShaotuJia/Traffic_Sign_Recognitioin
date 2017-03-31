%This function is to find maximum blob in binary image
%The input must be binary image

function blob = MaxBlob(imgSign)

%check whether the image is binary
if class(imgSign) ~= 'logical'
    disp('Please input binary image');
end

%find blob properties
stats = regionprops(imgSign);

%find the maximum blob 
maxlabel = 0;
maxArea = 0;
for i = 1 : max(size(stats))
    
    if maxArea < stats(i).Area 
        maxArea = stats(i).Area
        maxlabel = i;
    end   
end

blob = stats(maxlabel);

end