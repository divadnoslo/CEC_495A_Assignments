%% Digit Extraction
% David Olson
% 15 Oct 17

close all;
clear all;
clc;

%% Load Data

load('unknownImages.mat')
load('templateImages.mat')

%% Normalized Cross-Correlation

postcode = zeros([1, length(unknownImageScaled)]);

for ii = 1 : length(unknownImageScaled)
    
    maxVal = 0;
    templateChoice = -1;
    
    for jj = 1 : length(templateImageScaled)
        
        corr = normxcorr2(unknownImageScaled{ii}, ...
                          templateImageScaled{jj});
        maxCorr = max(corr(:));
        
        if (maxCorr > maxVal)
            maxVal = maxCorr;
            templateChoice = jj - 1;
        end
        
    end
    
    postcode(ii) = templateChoice;
    
end

fprintf('PostCode Read: %d%d%d%d%d%d \n', postcode)

              