% The MIT License (MIT)
% Copyright (c) 2016 Elmar Rueckert, Daniel Tanneberg, David Kappel
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
% *
% * Supplementary Code to 
% *                       Probabilistic Movement Models Show that Postural Control Precedes and Predicts Volitional Motor Control, 
% *                       Scientific Reports, Nature Publishing Group.
% * 
% *                       Rueckert, Elmar and Jernej Camernik and Jan Peters and Jan Babic (2016).
% * 
% * If you use this code, please cite the paper!
% * 
% * contact: rueckert.elmar@gmail.com
% *
% **********************************************************
function ProMPs_plot_prediction(datasetsTest, lTestId, y_predProMPs, sigma_starProMPs, lambdaProMPs, T, DOF, usedSampleIds, y_testMat, y_predProMPsMat)

lw = 2;
fs = 26;
fsLegend=18;

datasetsTestTmp = datasetsTest(lTestId);
y_predVarProMPs = zeros(size(y_predProMPs));
for t=1:size(y_predProMPs,1)
    y_predVarProMPs(t,:) =  datasetsTestTmp.PSI_X(t,:)*sigma_starProMPs*datasetsTestTmp.PSI_X(t,:)' + lambdaProMPs;
end
y_predVarProMPsMat = reshape(y_predVarProMPs,DOF,T);
timeIds = linspace(0,1,T);
for i=1:DOF   
    hFigPrediction(i) = figure;
    set(hFigPrediction(i),'Color','white');
    hold all;
    lndPred =  shadedErrorBar(timeIds,y_predProMPsMat(i,:),sqrt(y_predVarProMPsMat(i,:)),'r',1);
    est_plot = lndPred.mainLine;
    set(est_plot, 'linewidth', 3);
    hTrue=plot(timeIds, datasetsTestTmp.Ymat(i,:), 'k', 'linewidth', lw);
    hObs=scatter(timeIds(usedSampleIds)', y_testMat(i,:)',100, 'xb', 'linewidth',lw*2);
           
    xlabel('movement phase', 'fontsize', fs);
    ylabel(['prediction of joint ' num2str(i)] , 'fontsize', fs);
    
    lhndLegend=legend([est_plot, hTrue, hObs], 'prediction', 'true', 'observation');
    set(lhndLegend, 'fontsize',12);
    set(gca, 'fontsize', fs);
end
