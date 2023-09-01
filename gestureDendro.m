function [tree, leafOrder] = gestureDendro(UNI,labels)
%  [tree leafOrder] = gestureDendro(UNI,labels)

%% dendrogram


% first compute centroids for each gesture....
uc = unique(labels.gest);
% exclude no action
f = find(uc ~= 'no_action');
uc = uc(f);
for c = 1:numel(uc)
    fc = find(labels.gest == uc(c));
    gcent(c,:) = mean( UNI(fc,:) );
end

% compute dendrogram with optimal leaf order

tree = linkage(gcent,'centroid');
D = pdist(gcent);
leafOrder = optimalleaforder(tree,D);
dendrogram(tree,50,'Reorder',leafOrder);
       

xtl = get(gca,'xticklabel');
set(gca,'xticklabel',uc( str2num(xtl )));
 xtickangle(90);