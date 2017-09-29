%% Dr. Schipper is juggling and I'm gonna make the computer watch
% David Olson
% 15 Sep 17

close all;
clear;
clc;

tic

StartingFrame = 1;
EndingFrame = 936;

for k = StartingFrame : EndingFrame - 1
    
    if (k == 1)
        
        % Load Image
        Img = imread(['juggle/img', sprintf('%2.3d', k), '.jpg']);
        
        % Find Balls in Image, sort based on area
        ballImg = greenBaller(Img);
        [label, number] = bwlabel(ballImg, 8);
        Istats = regionprops(label, 'basic', 'Centroid');
        [values, index] = sort([Istats.Area], 'descend');
        
        % Create Array of "ball" keeping track of all detected objects
        if (number >= 3)
            ball = Istats(index(1:3));
        elseif (number == 2)
            ball = Istats(index(1:2));
        elseif (number == 1)
            ball = Istats(index(1));
        else
            ball = 0;
        end
        
    else
        
        % Load Image
        Img = imread(['juggle/img', sprintf('%2.3d', k), '.jpg']);
        
        % Find Detections
        ballImg = greenBaller(Img);
        [label, number] = bwlabel(ballImg, 8);
        Istats = regionprops(label, 'basic', 'Centroid');
        [values, index] = sort([Istats.Area], 'descend');
        
        % Sort Detections
        if (number >= 3)
            det = Istats(index(1:3));
        elseif (number == 2)
            det = Istats(index(1:2));
        elseif (number == 1)
            det = Istats(index(1));
        else
            det = 0;
        end
        
        % Find Distance between all detections and balls
        for b = 1 : 1 : length(ball)
            for d = 1 : 1 : length(det)
                dist(b, d) = hypot(abs(det(d).Centroid(1) - ball(b).Centroid(1)), ...
                                   abs(det(d).Centroid(2) - ball(b).Centroid(2)));
            end
        end
        
        % Sort Distances to find minimum
        [minDist, minLoc] = min(dist);
        
        % Correlate balls with detections
        ball(1) = det(minLoc(1));
        ball(2) = det(minLoc(2));
        ball(3) = det(minLoc(3));
        
        hold on
        imshow(Img)
        rectangle('Position', ...
            [ball(1).BoundingBox], ...
            'LineWidth', 2, 'EdgeColor', 'm');
        rectangle('Position', ...
            [ball(2).BoundingBox], ...
            'LineWidth', 2, 'EdgeColor', 'c');
        rectangle('Position', ...
            [ball(3).BoundingBox], ...
            'LineWidth', 2, 'EdgeColor', 'y');
        text(10, 10, ['Number of Balls Detected:  ', num2str(length(det))], 'color',  'r')
        
    end
    
pause(1/30)

end

toc
