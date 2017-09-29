%% Ball Tracking Plotter All Frames
% David Olson
% 6 Sep 2017

clear all;
close all;
clc;

tic

StartingFrame = 1;
EndingFrame = 489;

xyCentroidJoy = zeros(2, EndingFrame);
xyCentroidHilst = zeros(2, EndingFrame);

numJoy = 0;
numHilst = 0;

for k = StartingFrame : EndingFrame - 1
    
    Img = imread(['balls/img', sprintf('%2.3d', k), '.jpg']);
    
    % For Joy
    joyBall = blueBall(Img);
    [labelJoy, numberJoy] = bwlabel(joyBall, 8);
    IstatsJoy = regionprops(labelJoy, 'basic', 'Centroid');
    [valuesJoy, indexJoy] = sort([IstatsJoy.Area], 'descend');
    if (isempty(valuesJoy(1)))
        continue
    elseif (valuesJoy(1) > 800)
        xyCentroidJoy(:,k) = [IstatsJoy(indexJoy(1)).Centroid(1); IstatsJoy(indexJoy(1)).Centroid(2)];
        numJoy = numJoy + 1;
    end
    
    % For Van Hilst
    vanHilstBall = greenBall(Img);
    [labelHilst, numberHilst] = bwlabel(vanHilstBall, 8);
    IstatsHilst = regionprops(labelHilst, 'basic', 'Centroid');
    [valuesHilst, indexHilst] = sort([IstatsHilst.Area], 'descend');
    if (isempty(valuesHilst))
        continue
    elseif (valuesHilst(1) > 1000)
        xyCentroidHilst(:,k) = [IstatsHilst(indexHilst(1)).Centroid(1); IstatsHilst(indexHilst(1)).Centroid(2)];
        numHilst = numHilst + 1;
    end
    
end

figure
hold on
imshow('img489.jpg', 'border', 'tight')
hold on
plot(xyCentroidJoy(1,:), xyCentroidJoy(2,:), 'cx')
plot(xyCentroidHilst(1,:), xyCentroidHilst(2,:), 'gx')

toc
