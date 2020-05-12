clc; 
clear all; 
close all

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

accuracy = 0.0;

% Perform cross-validation
for i = 0:9
    dsFileTrain = strcat(cd, "/train", num2str(i));
    imdsTrain = imageDatastore(dsFileTrain, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    dsFileTest = strcat(cd, "/test", num2str(i));
    imdsTest = imageDatastore(dsFileTest, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

    % Train Network
    options = trainingOptions('sgdm', ...
        'InitialLearnRate',1e-3, ...
        'L2Regularization',0.005, ...
        'MaxEpochs',100, ...  
        'ValidationData',imdsTest, ...
        'ValidationPatience',Inf,...
        'MiniBatchSize',50, ...
        'Shuffle','every-epoch', ...
        'VerboseFrequency',2, ...
        'Plots','training-progress',...
        'ExecutionEnvironment','multi-gpu');

    [net,info] = trainNetwork(imdsTrain, layers, options);

    % Compute Accuracy of Test Set
    YPred = classify(net, imdsTest);
    YTest = imdsTest.Labels;
    accuracy = accuracy + sum(YPred == YTest) / numel(YTest);
end

accuracyCV = accuracy / 10;
disp(accuracyCV);
