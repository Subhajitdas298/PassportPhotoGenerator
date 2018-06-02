%% Detect faces using Viola-Jones Algorithm
% Author : Subhajit Das

%% clear
clc;
close all;
clear all;

%% suppress warnings
warning('off','all')

%% Read the input image
[file,path] = uigetfile({'*.jpg';'*.jpeg';'*.png';'*.bmp'});
% exit if no file is selected
if isequal(file,0) || isequal(path,0)
    disp('Operation cancelled');
    disp('Exiting...');
    return;
end
fullFileName = fullfile(path, file);
I = imread(fullFileName);

%% face detection
BB = smart_face_detect(I, 1);

%% stop if no face is found
if isempty(BB)
    disp('No faces detected.');
    disp('Exiting...');
    return;
end

%% show/mark detected faces
figure;
imshow(I);
hold on;
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','r');
end
title('Detected Faces');
hold off;

%% generating passport photo
hToWRatio = input('Enter height to width ratio (1.0 to 1.5; default: 1.2) : ');
if isempty(hToWRatio) || hToWRatio < 1  || hToWRatio > 1.5
    hToWRatio = 1.2;
end
display(strcat('Height to Width ratio : ', num2str(hToWRatio)));

scale = input('Enter scale (default: 1.8) : ');
if isempty(scale)
    scale = 1.8;
end
display(strcat('Scale : ', num2str(scale)));

% for creating printable photo in A4 paper %
% create blank image
printableImage = ones(3508,  2480, 3, 'uint8') * 255;
MARGIN = 30;
PAGE_MARGIN = 50;
PHOTO_PER_ROW = 6;

photoIndex = 0;

for i = 1:size(BB,1)
    x = BB(i, 1);
    y = BB(i, 2);
    w = BB(i, 3);
    h = BB(i, 3);
    
    m = w;
    a = m  * (scale * hToWRatio - 1);
    b = m * (scale - 1);
    currPhotoDim = [(x-b/2), (y-.4*a), (w+b), (h+a)];
    
    photo = imcrop(I, currPhotoDim);
    % get real width after crop
    width = size(photo, 2);
    % scale image, with Width approaching 345 pixels
    photo = imresize(photo, 345/width);
    % height and width after scaling
    height = size(photo, 1);
    width = size(photo, 2);
    
    % show the image
    figure;
    imshow(photo);
    title(strcat('Passport Photo [', int2str(i), ']'));
    
    % get how many copies of this photo
    copies = input(strcat('No of copies for Passport Photo [', int2str(i), '] (1 to 30; default: 1) : '));
    if isempty(copies) || copies < 1 || copies > 30
        copies = 1;
    end
    display(strcat('Copies : ', num2str(copies)));
    
    % place the photo in the page %
    for j = 1:copies        
        photoRow = floor(photoIndex / PHOTO_PER_ROW);
        photoColumn = mod(photoIndex, PHOTO_PER_ROW);
        
        % photo position (top-left) for whole zone including 30 pixel margins
        photoPosition = [photoRow * (2 * MARGIN + height), photoColumn * (2 * MARGIN + width)];
        
        % exact starting location of the photo (top-left)
        photoLocation = [photoPosition(1) + PAGE_MARGIN, photoPosition(2) + PAGE_MARGIN];
        
        printableImage = array_3d_copy(printableImage, photo, photoLocation(1) , photoLocation(2), 1);
        
        photoIndex = photoIndex + 1;
    end
end

% show printable image
figure;
imshow(printableImage);

%% starting warnings
warning('on','all')

[filename,user_canceled] = imsave;

if user_canceled
    disp('Image is NOT saved');
    return;
end
