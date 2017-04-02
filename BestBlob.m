%This function is to find maximum blob with admissable Aspect Ratio in binary image
%The input must be binary image

function blob = BestBlob(imgSign)

%check whether the image is binary
if class(imgSign) ~= 'logical'
    disp('Please input binary image');
end

%find blob properties
stats = regionprops(imgSign);
%display stats
disp('stats: ');
disp(stats);

%find the maximum blob 
%AspectRatio between 0.6 ~ 1.4 
%intensity density in boundingBox > 70%
maxlabel = 0;
maxArea = 0;
for i = 1 : max(size(stats))
    ratio = AspectRatio(stats(i));
    density = Density(stats(i));
    
    %!!density test!! 
   
    disp('dataNumber:');
    disp(i);
    disp('ratio:');
    disp(ratio);
    disp('density:');
    disp(density);
    
    disp('Area:');
    Area = stats(i).Area;
    disp(Area);
    
    
    if ratio > 0.6 && ratio < 2.5 && density > 0.5
        if maxArea < stats(i).Area 
         maxArea = stats(i).Area
         maxlabel = i;
        end  
    end
end

%{
disp('i: ');
disp(i);

disp('The max area is: ');
disp(maxArea);
%}

if maxlabel == 0 || maxArea < 60
    blob = 0; %no red traffic sign
else %area > 60 otherwise boundingbox does not draw clear
    blob = stats(maxlabel);
end

end