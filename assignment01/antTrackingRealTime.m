%% Ant Tracking Plotter Real Time
% David Olson
% 6 Sep 2017

clear all;
close all;
clc;

StartingFrame = 1;
EndingFrame = 448;

xyCentroid = zeros(2, 448);

figure
hold on

for k = StartingFrame : EndingFrame - 1
    
    pos1 = imread(['ant/img', sprintf('%2.3d', k), '.jpg']);
    pos2 = imread(['ant/img', sprintf('%2.3d', k+1), '.jpg']);
    hold on
    imshow(pos2, 'border', 'tight')
    pos1 = rgb2gray(pos1);
    pos2 = rgb2gray(pos2);
    diff1 = abs(pos1 - pos2);
    BW = diff1 > 25;

    [labels, number] = bwlabel(BW, 8);
    
    if (number == 1)
        Istats = regionprops(labels, 'basic', 'Centroid');
        [maxVal, maxIndex] = max([Istats.Area]);
        xyCentroid(:,k) = [Istats(maxIndex).Centroid(1); Istats(maxIndex).Centroid(2)];
    end
    
    hold on
    plot(xyCentroid(1,1:k), xyCentroid(2,1:k), 'kx')
    
    pause(1/30)
    
end



