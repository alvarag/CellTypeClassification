clc; 
clear all; 
close all

% Preparation
dsFile = strcat(cd, "/../NeuralNetworkTraining");

% Augmentation params
theta = 54;       %angle to rotate
filtNum = 0.75;   %smoothing parameter for gaussian filter
patchRadius = 20; %radius of boundary between the original image and the
%cropped added portions of the image (e.g. top row moved to bottom row) for
%smoothing

rowT = 30;        %rows translated
colT = 24;        %cols translated
filtNum = 0.5;    %smoothing parameter for gaussian filter in patch
patchRadius = 3;%radius of boundary between the original image and the
%cropped added portions of the image (e.g. top row moved to bottom row) for
%smoothing

% Read the images
imds = imageDatastore(dsFile,'IncludeSubfolders',true,'LabelSource','foldernames');
[numFiles, ~] = size(imds.Files);

for i = 1 : numFiles
    imgName = char(imds.Files(i));
    img = im2double(imread(imgName));
    [name, ~] = regexp(char(imds.Files(i)), ".jpg", 'split');
    rot1 = rotateIm(img,theta,filtNum,patchRadius);
    trans1 = transIm(img,rowT,colT,filtNum,patchRadius);
    imwrite(uint8(rot1), name, '_r.jpg')
    imwrite(uint8(trans1), name, '_t.jpg')
end
