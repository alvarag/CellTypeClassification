clc; 
clear all; 
close all

% Preparation
numTrainPercentage = 0.8;
parentFile = cd;

% Set Up Training Options

layers = [
    imageInputLayer([224 224 1])
    
    convolution2dLayer(11,32,'Padding','same')
    batchNormalizationLayer()
    reluLayer()
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,32,'Padding','same')
    batchNormalizationLayer()
    reluLayer()
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,32,'Padding','same')
    batchNormalizationLayer()
    reluLayer()
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,32,'Padding','same')
    batchNormalizationLayer()
    reluLayer()
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,32,'Padding','same')
    batchNormalizationLayer()
    reluLayer()
    averagePooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(5,32,'Padding','same')
    batchNormalizationLayer()
    reluLayer()
    averagePooling2dLayer(2,'Stride',2)
    
    fullyConnectedLayer(8)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.005, ...
    'MaxEpochs',100, ...  
    'ValidationData',imdsValidation, ...
    'ValidationPatience',Inf,...
    'MiniBatchSize',50, ...
    'Shuffle','every-epoch', ...
    'VerboseFrequency',2, ...
    'Plots','training-progress',...
    'ExecutionEnvironment','multi-gpu');

accuracy = 0.0;

for i = 0:9
    dsFileTrain = strcat(cd, "/train", num2str(i);
    imdsTrain = imageDatastore(dsFile, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    dsFileTest = strcat(cd, "/test", num2str(i);
    imdsTest = imageDatastore(dsFile, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

    % Train Network
    [net,info] = trainNetwork(imdsTrain, layers, options);
%    save('net','net'); % this provides you with a 'net.mat' file you can then use to apply the model on new images
%    save('info','info');

    % Compute Accuracy of Test Set
    YPred = classify(net,imdsTest);
    YTest = imdsTest.Labels;
    accuracy += sum(YPred == YValidation) / numel(YTest);
end

accuracyCV = accuracy / 10
