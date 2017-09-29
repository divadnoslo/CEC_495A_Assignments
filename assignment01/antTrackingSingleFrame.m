%% Ant Tracking Plotter Single Frame
% David Olson
% 6 Sep 2017

clear all;
close all;
clc;

%% Getting to a black and white image

pos1 = imread('ant/img008.jpg');
pos2 = imread('ant/img009.jpg');

pos1 = rgb2gray(pos1);
pos2 = rgb2gray(pos2);

diff1 = abs(pos1 - pos2);
% figure
% imshow(diff1)
% figure
% imhist(diff1)
Ithresh = diff1 > 25;
% figure
% imshow(Ithresh)

% Now we have a black and white image to work with
BW = Ithresh;
%% Running CCA to find ant's location

[labels, number] = bwlabel(BW, 8);
Istats = regionprops(labels, 'basic', 'Centroid');

[maxVal, maxIndex] = max([Istats.Area]);

%% Plot Location of ant

figure
hold on
imshow(BW)
hold on
rectangle('Position', [Istats(maxIndex).BoundingBox], ...
          'LineWidth', 2, 'EdgeColor', 'g');
hold on      
plot(Istats(maxIndex).Centroid(1), Istats(maxIndex).Centroid(2), 'r*');
hold off