%% Envelope Reader
% David Olson
% 4 Oct 17

close all;
clear all;
clc;

%% Load Data

I = imread('envelope/envelope3.jpg');

%% Adaptive Thresholds

Imed = medfilt2(I, [100 100]);
Ifinal = Imed - I;
BW = Ifinal > 50;

% The Adpative Thresholding is working for all images

%% Hough Transform

[H, theta, rho] = hough(BW);
peaks = houghpeaks(H, 1);
lineEst = houghlines(BW, theta, rho, peaks);
angle = 90 + lineEst.theta;

Irot = imrotate(I, angle, 'crop');

% imshow(Irot)

%% Re-Threshhold Image

Imed = medfilt2(Irot, [100 100]);
Ifinal = Imed - Irot;
BW = Ifinal > 50;

% imshow(BW)

%% Focus in on one section of the image

[rows, cols] = size(BW);
Isub = BW((round(2*rows/3) : rows), (1 : round(cols/2)));

% imshow(Isub)

%% Morphological Operations

SE = strel('disk', 4, 0);
Imarks = imopen(Isub, SE);

% imshow(Imarks)

%% Outline Numbers Below

[label, number] = bwlabel(Imarks, 8);
Istats = regionprops(label, 'basic', 'BoundingBox');
[values, index] = sort([Istats.Area], 'descend');

% Ten pixels per unit length, according to diagram on the hand-out!

% Plotting the outlines of the boxes below
imshow(Isub)
d = 1;
for k = 1 : length(Istats)
    
    if (k == 2)
        continue;
    end
    
    % Plot Box Around Machine Mark
    hold on
    rectangle('Position', ...
              [Istats(k).BoundingBox], ...
              'LineWidth', 2, 'EdgeColor', 'b');
    
    % Prepare Coordinates for Box around Numbers      
    x = Istats(k).BoundingBox(1) + 10;
    y = Istats(k).BoundingBox(2) + 40;
    xwidth = round(Istats(k).BoundingBox(3) * (5/7));
    ywidth = round(Istats(k).BoundingBox(4) * 5);

    % Plot Box Around Number Box
    hold on
    rectangle('Position', ...
              [x y xwidth ywidth], ...
              'LineWidth', 2, 'EdgeColor', 'r');
          
    % Write Text for which digit each block belongs too
    msg = [' Digit #', num2str(d)];
    text(x - 10, y + 110, msg, 'Color', 'y')
    
    d = d + 1;
    
end

