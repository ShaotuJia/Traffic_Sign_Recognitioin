%This script is for ENPM673_P2_Part2_2.1

for i = 1 : length(Filename)
    
    filename = Filename{i};
    img = imread(filename);
    imshow(img);
    H = rgb2hsv(img); % transfer RGB to HSV 
    h = H(:,:,1);
    s = H(:,:,2);
    v = H(:,:,3);
    
end

