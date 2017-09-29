%% Impeller Analysis
% David Olson
% 25 Sep 17

close all;
clear all;
clc;

load('radDec.mat')

while(1)
    
    % Remind choices availbile
    disp('Choices are 2 3 5 6 7 9 10, enter something else to stop.')
    imageValue = input('Which image number do you want to evaluate?  ');
    
    % Load proper image
    switch imageValue
        case 2
            Irgb = imread('rotor02.jpg');
        case 3
            Irgb = imread('rotor03.jpg');
        case 5
            Irgb = imread('rotor05.jpg');
        case 6
            Irgb = imread('rotor06.jpg');
        case 7
            Irgb = imread('rotor07.jpg');
        case 9
            Irgb = imread('rotor09.jpg');
        case 10
            Irgb = imread('rotor10.jpg');
        otherwise
            break
    end
    
    % Convert image to black and white, edge detection
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
    imshow(I_final)
    
    % Begin to find the ratio of black to white
    [label, number] = bwlabel(I_final, 8);
    Istats = regionprops(label, 'basic', 'BoundingBox');
    
    % Find center and radius of object
    centerObj = [Istats.BoundingBox(1) + (Istats.BoundingBox(3)/2), ...
        Istats.BoundingBox(2) + (Istats.BoundingBox(4)/2)];
    radiusObj = (Istats.BoundingBox(3) +  Istats.BoundingBox(4))/4;
    
    % Radius Calibration to account for distortion
    radiusObj = radiusObj - radDec;
    
    % Show final image and circle
    imshow(I_final, 'Border', 'tight')
    hold on
    viscircles(centerObj, radiusObj, 'Color', 'y');
    
    % Count black and white pixels within the cicle
    whiteCount = 0;
    Count = 0;
    
    [M, N] = size(I_final);
    
    for ii = 1 : M
        for jj = 1 : N
            if (sqrt(((ii - centerObj(1))^2) + ((jj - centerObj(2))^2)) < radiusObj)
                if (I_final(ii,jj) == 1)
                    whiteCount = whiteCount + 1;
                end
                Count = Count + 1;
            end
        end
    end
    
    % Calculate ratio and display on graph
    ratio = whiteCount / Count;
    text(160, 465, ['Image ', num2str(imageValue), ':  ', num2str(ratio * 100), '%'], 'Color', 'm')
    
    disp(' ')
end