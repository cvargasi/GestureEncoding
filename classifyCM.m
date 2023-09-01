function [cm mod] = classifyCM(datamat,id,labels,show)
% [cm mod] = classifyCM(datamat,id,labels,show)
% Classify and return normalized confusion matrix 
% 
% INPUTS
% datamat: data to be classified (samples x features)
% id: classes to which each data sample belongs 
% labels: text labels for the CM
% show: only generates a figure if set to 1
% 
% OUTPUTS
% cm: normalized confusion matrix (% by rows)
% mod: classification model used (NOTE: calls classifySimple)
% 

%  Classify 
[ pc cm mod ] = classifySimple(datamat, id);


% display results
if show

figure
imagesc(cm); colorbar
%title(['classification accuracy: ' num2str(LDA.results.mean) '%'])
set(gca,'Xticklabel',labels)
set(gca,'Xtick',[ 1:numel(labels)])
set(gca,'Yticklabel',labels)
set(gca,'Ytick',[ 1:numel(labels)])
set(gca,'fontsize',15)
xtickangle(90)


for r = 1:size(cm,1)
    for c = 1:size(cm,2)

        h = text(c-.2,r, [num2str(round(cm(r,c))) '%' ]);
        set(h,'fontsize',15);
        
    end
end

end




