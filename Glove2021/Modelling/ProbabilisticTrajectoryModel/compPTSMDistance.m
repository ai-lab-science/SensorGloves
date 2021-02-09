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
function [dL2, dKL] = compPTSMDistance(dsName1, dsName2)

%save(sprintf('models%sPTM_%s.mat', filesep, dataFolder));


ds1 = load(sprintf('models%sPTM_%s.mat', filesep, dsName1));
ds2 = load(sprintf('models%sPTM_%s.mat', filesep, dsName2));

%The datasets contains n = 34 trajectories or demonstrations. 
%of the left wrist or right wrist human target reaching motions. Only the
%y?-coordinate is given. 

%Variables in the dataset                   Dimesnion
%----------------------------------------------------
%dsWrist               n x 100 time steps
T = ds1.T;
n1 = ds1.DOF;
n2 = ds2.DOF;

p.mu = ds1.mu_w;
p.sigma = ds1.sigma_w;
q.mu = ds2.mu_w;
q.sigma = ds2.sigma_w;

%% Use the learned prior model to predict the mean trajectory and variance. 
%p(tau) = integral p(tau|w)p(w) dw 
%Use the function shadedErrorBar.m to visdualize the model.  plot the 95%
%confidenz interval (2*sigma)
%What happens if you increase the data noise parameter: 
sigma_y = 0.01;

tau_LeftWrist = ds1.A*p.mu;
tau_RightWrist = ds2.A*q.mu;
tau_LeftWristCov = sigma_y^2 + ds1.A*p.sigma*ds1.A';
tau_RightWristCov = sigma_y^2 + ds2.A*q.sigma*ds2.A';

%varainces
var_LeftWrist = diag(tau_LeftWristCov);
std_LeftWrist = sqrt(var_LeftWrist); 
var_RightWrist = diag(tau_RightWristCov);
std_RightWrist = sqrt(var_RightWrist); 

%% Compute Similarity measures
% a) Euclidean distance between the feature weights
dL2 = sqrt((p.mu' - q.mu')*(p.mu - q.mu));

% b) KL divergence
dKL = KL(p,q);

end
