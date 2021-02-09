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
function [w_star,sigma_star] = ProMPs_prediction( X_star, y_star, ws, lambda, DDB)

    [M,N,L] = size(ws);
    S = size(X_star,1) / DDB;
    flgUseRecursiveImpl = 0;

    if size(lambda,1)*size(lambda,2) == 1
        if flgUseRecursiveImpl
            lambdaMat = eye(DDB)* lambda;
        else
            lambdaMat = eye(DDB*S)* lambda;
        end
    else
        if flgUseRecursiveImpl
            lambdaMat = diag(lambda);
        else
            lambdaMat = diag(repmat(lambda,1,S));
        end
    end

    w_star = mean(ws,3);
    sigma_star = cov(squeeze(ws(:,1,:))');


    x_tmp = X_star';
    y_tmp = y_star;  


    sigma_star = sigma_star';
    features = x_tmp';
    tempMatrix = sigma_star * features' / (lambdaMat + features * sigma_star * features');
    newMu = w_star + tempMatrix * (y_tmp - features * w_star);
    newSigma = sigma_star - tempMatrix * features * sigma_star;

    w_star = newMu;
    sigma_star = newSigma;





end

