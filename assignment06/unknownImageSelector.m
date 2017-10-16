%% Digit Extraction
% David Olson
% 15 Oct 17

close all;
clear all;
clc;

%% Load and develop BW Image
Igray = imread('unknown.jpg');
Ithresh = Igray < 200;
BW = Ithresh;
%imshow(BW)

%% Grow region for thicker lines, more robust detection possible
SE = strel('disk', 2);
BW2 = imdilate(BW, SE);
%imshow(BW2)

%% CCA, detect objects coinciding with the digits
[label, number] = bwlabel(BW2, 8);
Istats = regionprops(label, 'basic', 'BoundingBox');
Istats([Istats.Area] < 1000) = [];
num = length(Istats);

Ibox = floor([Istats.BoundingBox]);
Ibox = reshape(Ibox, [4 num]);

% %% Plot Ibox properties over BW2 image -- Test
% 
% imshow(BW2)
% hold on;
% for k = 1 : num
%     rectangle('position', Ibox(:,k), ...
%               'edgecolor', 'r', 'LineWidth', 3);
% end

%% Sub-Image Extraction and Scaling

for k = 1 : num
    col1 = Ibox(1, k);
    col2 = Ibox(1, k) + Ibox(3, k);
    row1 = Ibox(2, k);
    row2 = Ibox(2, k) + Ibox(4, k);
    subImage = BW2(row1:row2, col1:col2);
    unknownImage{k} = subImage;
    unknownImageScaled{k} = imresize(subImage, [24 12]);
end

% figure, imshow(unknownImage{1})
% figure, imshow(unknownImageScaled{1})
    
save('unknownImages.mat', 'unknownImageScaled')
