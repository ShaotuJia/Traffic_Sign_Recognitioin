%This script is to classify blue traffic sign
clc;
clear;
close all;

%Define the folder name of bluetest and bluetraining data
BlueTestDir = fullfile('BlueSignTesting\');
BlueTrainingDir = fullfile('BlueSignTraining\');

%Load training the test data using |imageDatastore|
%|imageDatastore| recursively scans the directory tree containing the image
%Folder names are automatically used as labels for each image

BlueTrainingSet = imageDatastore(BlueTrainingDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
BlueTestSet = imageDatastore(BlueTestDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%Number of image in BlueTrainingSet and BlueTestSet
BlueTrainingNum = numel(BlueTrainingSet.Files);
BlueTestNum = numel(BlueTestSet.Files);

%Obtain HOG parameter using sample image 
%Read first image in BlueTestSet as sample image
sampleImage = readimage(BlueTestSet, 1);

%Extract Blue Sign for sampleImage
sampleImage = ExtractBlueSign(sampleImage);

%Resize sample image to 64 x 64
sampleImage = imresize(sampleImage, [64 64]);

CellSize = 4; %Cellsize = 4 for HOG

%Get HOG for sample image
HogSample = (vl_hog(single(sampleImage), CellSize, 'verbose'));

%Size of HogSample matrix
sizeX = length(HogSample(:,1,1));
sizeY = length(HogSample(1,:,1));
sizeZ = length(HogSample(1,1,:));

%reshape HogSample to single array
HogSample = reshape(HogSample, [1 sizeX * sizeY * sizeZ]);

% size of HogSample 
HogSize = length(HogSample);

%Initialize Features for Blue training and test
BlueTrainingFeatures = zeros(BlueTrainingNum, HogSize, 'single');
BlueTestFeatures = zeros(BlueTestNum, HogSize, 'single');

%Obtain Training HOG Features
for i = 1 : BlueTrainingNum
    %read image
   BlueImgTraining = readimage(BlueTrainingSet, i);
   
   % Extract Blue Sign
   try
   BlueImgTraining = ExtractBlueSign(BlueImgTraining);
   catch
       disp('cannot extract this training sign');
   end
   
   %Resize image to 64 x 64
   BlueImgTraining = imresize(BlueImgTraining, [64 64]);
   %Convert to HSV
   BlueImgTraining = rgb2hsv(BlueImgTraining);
   
   %Extract HSV channel image
   BlueImgTrainingH = BlueImgTraining(:,:,1);
   BlueImgTrainingS = BlueImgTraining(:,:,2);
   
   % Obtain HOG Features
   BlueHogTrainingH = vl_hog(single(BlueImgTrainingH), CellSize, 'verbose');
   BlueTrainingFeatures(i, :) = reshape(BlueHogTrainingH, [1 sizeX * sizeY * sizeZ]);
   
end

%Get labels for each training image
BlueTrainingLabels = BlueTrainingSet.Labels;

%fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme
BlueClassifier = fitcecoc(BlueTrainingFeatures, BlueTrainingLabels);

%Obtain TEST set HOG Features
for j = 1 : BlueTestNum
    
    %Read image
   BlueImgTest = readimage(BlueTestSet, j);
   
   %Extract Blue Sign
   try
   BlueImgTest = ExtractBlueSign(BlueImgTest);
   catch
       disp('Cannot extract this test sign');
   end
   
   %Resize image to 64 x 64
   BlueImgTest = imresize(BlueImgTest, [64 64]);
   %Convert to HSV
   BlueImgTest = rgb2hsv(BlueImgTest);
   
   %Extract HSV channel
   BlueImgTestH = BlueImgTest(:,:,1);
   BlueImgTestS = BlueImgTest(:,:,2);
   
   % Obtain HOG Features
   BlueHogTestH = vl_hog(single(BlueImgTestH), CellSize, 'verbose');
   BlueTestFeatures(j, :) = reshape(BlueHogTestH, [1 sizeX * sizeY * sizeZ]);
end

%get label for test images
BlueTestLabels = BlueTestSet.Labels;

%Make class predictions using the test features
predictedLabels = predict(BlueClassifier, BlueTestFeatures);

%Tabulate the results using a confusion matrix
[confMat, order] = confusionmat(BlueTestLabels,predictedLabels);



