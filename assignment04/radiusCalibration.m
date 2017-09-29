%% Impeller Radius Calibration
% David Olson
% 25 Sep 17

close all;
clear all;
clc;

% Convert image to black and white, edge detection
Irgb = imread('rotor03.jpg');
Ihsv = rgb2hsv(Irgb);
I = Ihsv(:,:,3);
BW = edge(I, 'canny', [0.04 0.5]);

% Create Structure Elements, dialate, and fill
SE1 = strel('line', 5, 0);
SE2 = strel('line', 5, 90);
I_dilate = imdilate(BW, [SE1 SE2]);
BWfill = imfill(I_dilate, 'holes');

% Further filtering
BWnobord = imclearborder(BWfill, 4);
I_final = imerode(BWnobord, [SE1 SE2]);

% Begin to find the ratio of black to white
[label, number] = bwlabel(I_final, 8);
Istats = regionprops(label, 'basic', 'BoundingBox');

% Find center and radius of object
centerObj = [Istats.BoundingBox(1) + (Istats.BoundingBox(3)/2), ...
    Istats.BoundingBox(2) + (Istats.BoundingBox(4)/2)];
radiusObj = (Istats.BoundingBox(3) +  Istats.BoundingBox(4))/4;

ratio = 0;
radDec = 0;
while (ratio < 1)
    
    radDec = radDec + 1;
    
    % Count black and white pixels within the cicle
    whiteCount = 0;
    Count = 0;
    
    [M, N] = size(I_final);
    
    for ii = 1 : M
        for jj = 1 : N
            if (sqrt(((ii - centerObj(1))^2) + ((jj - centerObj(2))^2)) < (radiusObj - radDec))
                if (I_final(ii,jj) == 1)
                    whiteCount = whiteCount + 1;
                end
                
                Count = Count + 1;
                
            end
        end
    end
    
    % Calculate ratio and display on graph
    ratio = whiteCount / Count;
    
end

fprintf('Radius Decrease:  %d pixels \n', radDec)
save('radDec.mat', 'radDec')
