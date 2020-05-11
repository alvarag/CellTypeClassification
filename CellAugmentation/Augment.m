%clc; 
%clear all; 
%close all

% Preparation
dsFile = strcat(cd, "/../NeuralNetworkTraining");

% Augmentation params
numRots = 10;    %number of rotations per each image
numTrans = 5;    %number of translations per each image

%theta = 54;       %angle to rotate
filtNum = 4;      %smoothing parameter for gaussian filter
patchRadius = 20; %radius of boundary between the original image and the
%cropped added portions of the image (e.g. top row moved to bottom row) for
%smoothing

%rowT = 3;         %rows translated
%colT = 2;         %cols translated
filtNum = 0.5;    %smoothing parameter for gaussian filter in patch
patchRadius = 3;%radius of boundary between the original image and the
%cropped added portions of the image (e.g. top row moved to bottom row) for
%smoothing

% Read the images
imds = imageDatastore(dsFile, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[numFiles, ~] = size(imds.Files);

for i = 1 : numFiles
    imgName = char(imds.Files(i));
    img = im2double(imread(imgName));
    [namec, ~] = regexp(char(imds.Files(i)), ".jpg", 'split');
    name = namec{1};
    
    % performs rotations
    for j = 1 : numRots
        rot1 = rotateIm(img, ceil(rand()*40),filtNum,patchRadius);
        imwrite(uint8(rot1), strcat(char(name), '_r', num2str(j), '.jpg'), 'jpg');
    end

    % performs translations
    for j = 1 : numTrans
        trans1 = transIm(img, 1+ceil(rand()*4), 1+ceil(rand()*4), filtNum, patchRadius);
        imwrite(uint8(trans1), strcat(char(name), '_t', num2str(j), '.jpg'), 'jpg');
    end
end
