function [pc, cm, mod ] = classifySimple(datamat,id,varargin)
% [pc, cm, mod ] = classifySimple(datamat,id,varargin)
% simple script for classification
% NOTE: all gesture paper classification calls this function
%
% INPUT
% datamat: data to be classified (samples x features)
% id: classes to which each data sample belongs 
% decoder type: specify 'LDA' or 'KNN' (default)
% 
% OUTPUT
% pc: percent correct across (average across crossvalidated folds)
% cm: normalized confusion matrix (% by rows)
% mod: classification model used (NOTE: calls classifySimple)
% 

if nargin<3
    modtype = 'KNN';
else
    modtype = 'LDA';
end

switch modtype
    
    case 'LDA'
         mod = fitcdiscr(datamat, id,'Kfold',10);
        
    case 'KNN'
       
        mod = fitcknn(datamat, id,'Kfold',10,'NumNeighbors',7);

end

cm = confusionmat(id,mod.kfoldPredict );
% normalize per row    
for r=1:size(cm,1)
   cm(r,:) = 100*(cm(r,:)/ sum(cm(r,:)));
end


pc = 100*(1-kfoldLoss(mod));

