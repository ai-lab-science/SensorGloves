% The MIT License (MIT)
% Copyright (c) 2020 Elmar Rueckert
% 
% Permission is hereby granted, free of charge, to any person obtaining a 
% copy of this software and associated documentation files (the "Software"), 
% to deal in the Software without restriction, including without limitation 
% the rights to use, copy, modify, merge, publish, distribute, sublicense, 
% and/or sell copies of the Software, and to permit persons to whom the 
% Software is furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
% DEALINGS IN THE SOFTWARE. 

% **********************************************************
% * Probabilistic Motion Models to Investigate Dystonia
% *
% *                       Paper: Probabilistic Movement Models Show that Postural Control Precedes and Predicts Volitional Motor Control   
% *                       Rueckert, Elmar and Jernej Camernik and Jan Peters and Jan Babic (2016). Scientific Reports, Nature Publishing Group. .
% * 
% * If you use this code, please cite the paper!
% * 
% * contact: rueckert@ai-lab.science
% *
% **********************************************************

clear all;
close all;
clc;

%compute the similarity matrices between trials and subjects

dsName{1} = 'floete_07022021_';
dsName{2} = 'gitarre_07022021_';
dsName{3} = 'sax_07022021_';


nDS = size(dsName,2);
dL2Mat = nan(nDS,nDS);
dKLMat = nan(nDS,nDS);

for rId=1:nDS
    for cId=1:nDS
        dsName1 = dsName{rId};
        dsName2 = dsName{cId};
        [dL2Mat(rId,cId), dKLMat(rId,cId)] = compPTSMDistance(dsName1, dsName2);

    end
end

figure; 
imagesc(dL2Mat);
%xticks(1:nDS);
%xticklabels(dsName);
yticks(1:nDS);
yticklabels(dsName);

c=colorbar;
c.Label.String = 'L2 distance';
set(gca, 'fontsize', 20);

try
figure; 
imagesc(dKLMat);
yticks(1:nDS);
yticklabels(dsName);
catch err 
end

c=colorbar;
c.Label.String = 'KL divergence';
set(gca, 'fontsize', 20);