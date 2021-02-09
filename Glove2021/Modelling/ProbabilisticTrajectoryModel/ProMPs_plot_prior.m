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
function [hFigModel] = ProMPs_plot_prior(datasets, wsProMPs, lambdaProMPs, flgPlotData, DDB)

    wsProMPsPrior = mean(wsProMPs,3);
    sigmaProMPs = cov(squeeze(wsProMPs(:,1,:))');
    y_predProMPs = datasets(1).PSI_X * wsProMPsPrior;
    y_predVarProMPs = zeros(size(y_predProMPs));
    for t=1:size(y_predProMPs,1)
        y_predVarProMPs(t,:) =  datasets(1).PSI_X(t,:)*sigmaProMPs*datasets(1).PSI_X(t,:)' + lambdaProMPs;
    end
    
    T = size(y_predProMPs,1) / DDB; % for each task different number of timesteps
    y_predProMPs = reshape(y_predProMPs,DDB,T)';
    y_predVarProMPs = reshape(y_predVarProMPs,DDB,T)';
    
    timeIds = linspace(0,1,T);
    
         
    lw = 2;
    fs = 26;
    fsLegend=18;
    L = size(datasets,2);
    cMap = jet(L);
    hFigModel = zeros(1,DDB);
    
    for i=1:DDB   
        
         hFigModel(i) = figure;
         set(hFigModel(i),'Color','white');
         hold all;
     
        lndPred =  shadedErrorBar(timeIds,y_predProMPs(:,i),sqrt(y_predVarProMPs(:,i)),'r',1);
        est_plot = lndPred.mainLine;
        set(est_plot, 'linewidth', lw);
   
    
    
     if flgPlotData > 0
        
         tmpData = []; 
         for trajId=1:L
            Tdata = size(datasets(trajId).Y,1) / DDB; 
            y_true = reshape(datasets(trajId).Y,DDB,Tdata)';
            timeIds = linspace(0,1,length(y_true(:,i)));

            plot(timeIds, y_true(:,i), 'linewidth', 1, 'color', 'b');
            
         end
         

     end
    m = datasets(1).PSI_X*wsProMPsPrior;
    m = reshape(m,DDB,T)';
    timeIds = linspace(0,1,T);
    plot(timeIds, m(:,i),'k', 'linewidth', 2*lw);
    
    %axis tight

    
    xlabel('movement phase', 'fontsize', fs);
    ylabel(['prior of joint ' num2str(i)], 'fontsize', fs);
    set(gca, 'fontsize', fs);
 
    hold off;
    end
end
