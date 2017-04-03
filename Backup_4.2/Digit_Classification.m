clc;
clear;
close all;

%This script is to learn how to use HOG and SVM for object recognition

%Load traing and test data using |imageDatastore|
BluePtraining = fullfile(toolboxdir('vision'), 'visiondata','digits','synthetic');
handwrittenDir = fullfile(toolboxdir('vision'),'visiondata','digits','handwritten');

%|imageDatastore| recursively scans the directory tree containing the image
% Folder names are automatically used as labels for each image.
trainingSet = imageDatastore(, 'IncludeSubfolders', true, 'LabelSource','foldernames');
testSet = imageDatastore(handwrittenDir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%Show pre-processing results
exTestImage = readimage(testSet,37);
processedImage = imbinarize(rgb2gray(exTestImage));

%Using HOG Features
img = readimage(trainingSet, 206);

%Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);

%Loop over the trainingSet and extract HOG features from each image.
%A similar procedure will be used to extract features from the testSet.
cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

numImages = numel(trainingSet.Files);
trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

for i = 1 : numImages
    img = readimage(trainingSet, i);
    
    img = rgb2gray(img);
    
    %Apply pre-processing steps
    img = imbinarize(img);
    
    trainingFeatures(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);
end

%Get labels for each image
trainingLabels = trainingSet.Labels;

%fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme
classifier = fitcecoc(trainingFeatures, trainingLabels);

%Extract HOG features from the test Set. The procedure is similar to
%what was shown earlier and is encapsulated as a helper function for
%brevity
[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(testSet, hogFeatureSize, cellSize);

%Make class predictions using the test features
predictedLabels = predict(classifier, testFeatures);

%Tabulate the results using a confusion matrix
confMat = confusionmat(testLabels,predictedLabels);

helperDisplayConfusionMatrix(confMat)