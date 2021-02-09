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

% *************************************************************************
% *** Short Description ***
%
% Creates a set of synthetic trajectories 
% Learns a distribution from it
% And computes predictions given some observations
%
% Original Paper: Paraschos, A.; Daniel, C.; Peters, J.; Neumann, G (2013). 
%        Probabilistic Movement Primitives, Advances in Neural Information 
%        Processing Systems (NIPS), Cambridge, MA: MIT Press.
%
% Last Update: April, 2016
% Author: Rueckert Elmar, rueckert.elmar@gmail.com 
% *************************************************************************

clear all;
close all;
clc;
    

%% Create synthetic data
numDemonstrations = 50;
DOF = 2;

datasets = struct([]);

T = 100;
t=zeros(DOF,T);
for i=1:DOF
    t(i,:) = linspace(0,i*2*pi,T);
end

hFigRawData=figure; hold all;
set(hFigRawData,'Color','white');
for l=1:numDemonstrations
    data = (1+ 0.3*randn(1,1))*sin(t) + (0.3+ 0.1*randn(1,1))*sin(3*t) + 0.1*randn(DOF,T);
    datasets(l).Y = data(:); %encoding: [val1DoF1, val1DoF2, val1DoF3, ..., val2DoF1, ...]
    datasets(l).Ymat = data; %for plotting only
    plot(data(1,:));
end
xlabel('time step', 'fontsize',26);
ylabel('raw data of joint 1', 'fontsize',26);
set(gca, 'fontsize',26);


%% Learn a distribution using ProMPs
numGaussians = 10;
lambdaProMPs = 1e-5; %regularization parameter to avoid singularities

%Linearly distributed basis functions
for l=1:numDemonstrations
    %Note the trajectory length T might change with the demonstrations
    datasets(l).PSI_X = sparse(getBasisFunctionsMultipleJointsAndTimesteps(numGaussians,T,DOF,1));
end

wsProMPsPrior = ProMPs_train(datasets,size(datasets(1).PSI_X,2), size(datasets(1).Y,2), lambdaProMPs); 
%Learned Prior:
mu_w = mean(wsProMPsPrior,3);
sigma_w = cov(squeeze(wsProMPsPrior(:,1,:))');
    

%% Plot the prior distribution
flgPlotData = 0;
ProMPs_plot_prior(datasets, wsProMPsPrior, lambdaProMPs, flgPlotData, DOF);

%% Predict future trajectory points given some observations
% for simplicity, one of the training traj. is used
datasetsTest = datasets;
lTestId = 1;
usedSampleStep = 10;                           %every 10th point is observed
usedSampleIds = 1:usedSampleStep:round(T*0.2); %first 20%   
lambdaProMPsPrediction = [lambdaProMPs 1e+5*ones(1,DOF-1)]; %only condition on the first DoF

X_test = zeros(length(usedSampleIds)*DOF,size(datasetsTest(lTestId).PSI_X,2)); 
y_test = zeros(length(usedSampleIds)*DOF,size(datasetsTest(lTestId).Y,2));
for i=1:length(usedSampleIds)
   indices = DOF * (usedSampleIds(i)-1)+1: DOF*usedSampleIds(i);
   X_test((i-1)*DOF + 1:i*DOF,:) = datasetsTest(lTestId).PSI_X(indices,:);
   y_test((i-1)*DOF + 1:i*DOF,:) = datasetsTest(lTestId).Y(indices,:);
end

[w_starProMPs, sigma_starProMPs] = ProMPs_prediction(X_test,y_test,wsProMPsPrior,lambdaProMPsPrediction,DOF); 
y_predProMPs = datasetsTest(lTestId).PSI_X * w_starProMPs;
y_predProMPsMat = reshape(y_predProMPs,DOF,T);
y_testMat = reshape(y_test, DOF, length(y_test)/DOF);


%% Plot the predictive distribution 
ProMPs_plot_prediction(datasetsTest, lTestId, y_predProMPs, sigma_starProMPs, ...
    lambdaProMPs, T, DOF, usedSampleIds, y_testMat, y_predProMPsMat);

 
