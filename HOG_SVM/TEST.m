%Test script to debug functions
clc;
clear


BlueTrainingDir = fullfile('BlueSignTraining\');

BlueTrainingSet = imageDatastore(BlueTrainingDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

BlueTrainingNum = numel(BlueTrainingSet.Files);

i = 1;
CellSize = 4;


BlueImgTraining = readimage(BlueTrainingSet, i);

figure (1), imshow(BlueImgTraining);
 
try
   BlueImgTraining = ExtractSign(BlueImgTraining);
   catch
       disp('cannot extract this training sign');
end
   
   figure (2), imshow(BlueImgTraining);
   
   %Resize image to 64 x 64
   BlueImgTraining = imresize(BlueImgTraining, [64 64]);
   
   figure (3), imshow(BlueImgTraining);
   
   %Convert to HSV
   BlueImgTraining = rgb2hsv(BlueImgTraining);
   
   %Extract HSV channel image
   BlueImgTrainingH = BlueImgTraining(:,:,1);
   BlueImgTrainingS = BlueImgTraining(:,:,2);
   
   % Obtain HOG Features
   BlueHogTrainingH = vl_hog(single(BlueImgTrainingH), CellSize, 'verbose');
   FeatureTEST(i, :) = reshape(BlueHogTrainingH, [1 16*16*31]);
