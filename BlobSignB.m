% This function is to find admissable blob blue sign

function blobB = BlobSignB(imgSign)

%check whether the image is binary
if class(imgSign) ~= 'logical'
    disp('Please input binary image');
end

%find blob properties
stats = regionprops(imgSign);
%display stats
%disp(stats);

%find the maximum blob 
%AspectRatio between 0.6 ~ 2.5 
%intensity density in boundingBox > 70%
%Area > 100


%initial blob structure array
blobB = struct('Centroid',{} , 'Area', {} , 'BoundingBox',{});
for i = 1 : max(size(stats))
    ratio = AspectRatio(stats(i));
    density = Density(stats(i));
    
    %!!!Output TEST!!
    %{
    disp('dataNumber:');
    disp(i);
    disp('ratio:');
    disp(ratio);
    disp('density:');
    disp(density);
    disp('Area:');
    Area = stats(i).Area;
    disp(Area);
    %}
    
    if ratio > 0.6 && ratio < 3 && density > 0.4 && stats(i).Area > 150
        blobB(end + 1) = stats(i);
    end  
end

end
