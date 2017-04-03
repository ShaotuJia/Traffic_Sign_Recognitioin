%This Script is to find the classifier for red sign
clc;
clear;
close all;

%Define the folder name of bluetest and bluetraining data
RedTestDir = fullfile('RedSignTesting\');
RedTrainingDir = fullfile('RedSignTraining\');

%Load training the test data using |imageDatastore|
%|imageDatastore| recursively scans the directory tree containing the image
%Folder names are automatically used as labels for each image

RedTrainingSet = imageDatastore(RedTrainingDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
RedTestSet = imageDatastore(RedTestDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%Number of image in BlueTrainingSet and BlueTestSet
RedTrainingNum = numel(RedTrainingSet.Files);
RedTestNum = numel(RedTestSet.Files);

%Obtain HOG parameter using sample image 
%Read first image in BlueTestSet as sample image
sampleImage = readimage(RedTestSet, 1);

%Extract Blue Sign for sampleImage
sampleImage = ExtractRedSign(sampleImage);

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
RedTrainingFeatures = zeros(RedTrainingNum, HogSize, 'single');
RedTestFeatures = zeros(RedTestNum, HogSize, 'single');

%Obtain Training HOG Features
for i = 1 : RedTrainingNum
    %read image
   RedImgTraining = readimage(RedTrainingSet, i);
   
   % Extract Blue Sign
   try
   RedImgTraining = ExtractRedSign(RedImgTraining);
   catch
       disp('cannot extract this training sign');
   end
   
   %Resize image to 64 x 64
   RedImgTraining = imresize(RedImgTraining, [64 64]);
   %Convert to HSV
   RedImgTraining = rgb2hsv(RedImgTraining);
   
   %Extract HSV channel image
   RedImgTrainingH = RedImgTraining(:,:,1);
   RedImgTrainingS = RedImgTraining(:,:,2);
   
   % Obtain HOG Features
   RedHogTrainingH = vl_hog(single(RedImgTrainingH), CellSize, 'verbose');
   RedTrainingFeatures(i, :) = reshape(RedHogTrainingH, [1 sizeX * sizeY * sizeZ]);
   
end

%Get labels for each training image
RedTrainingLabels = RedTrainingSet.Labels;

%fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme
RedClassifier = fitcecoc(RedTrainingFeatures, RedTrainingLabels);

%Obtain TEST set HOG Features
for j = 1 : RedTestNum
    
    %Read image
   RedImgTest = readimage(RedTestSet, j);
   
   %Extract Blue Sign
   try
   RedImgTest = ExtractRedSign(RedImgTest);
   catch
       disp('Cannot extract this test sign');
   end
   
   %Resize image to 64 x 64
   RedImgTest = imresize(RedImgTest, [64 64]);
   %Convert to HSV
   RedImgTest = rgb2hsv(RedImgTest);
   
   %Extract HSV channel
   RedImgTestH = RedImgTest(:,:,1);
   RedImgTestS = RedImgTest(:,:,2);
   
   % Obtain HOG Features
   RedHogTestH = vl_hog(single(RedImgTestH), CellSize, 'verbose');
   RedTestFeatures(j, :) = reshape(RedHogTestH, [1 sizeX * sizeY * sizeZ]);
end

%get label for test images
RedTestLabels = RedTestSet.Labels;

%Make class predictions using the test features
predictedLabels = predict(RedClassifier, RedTestFeatures);

%Tabulate the results using a confusion matrix
[confMat, order] = confusionmat(RedTestLabels,predictedLabels);
