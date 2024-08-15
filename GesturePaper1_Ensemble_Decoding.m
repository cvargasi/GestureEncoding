function [ results ]  = GesturePaper1_Ensemble_Decoding(UNI,labels,plotresults,titlestr)


% 49-way classificaiton (exclude no action)
fg = find(labels.gest ~= 'no_action');

[cm mod] = classifyCM(UNI(fg,:), labels.gest(fg),[unique(labels.gest(fg)) ],0);


for r=1:size(cm,1)
   cm(r,:) = 100*(cm(r,:)/ sum(cm(r,:)));
end

% sort by classification accuracy
d = diag(cm);
[v caix] = sort(d);
caix = caix(end:-1:1);

%sort by gesture group
gest = string(mod.ClassNames(:));

%  Dengrogram Group labeling 
fn = find(gest == 'Do nothing');
ff = find(contains(gest, 'finger') & contains(gest, 'down'));
%ft = find(contains(gest, 'thumb') & ~contains(gest, 'thumbs')); % this excludes hand gestures such as  "...hand thumbs up"
ft = find(contains(gest, 'thumb'));
fg = find(contains(gest, 'grasp') | contains(gest, 'ok') | contains(gest, 'zoom out'));
%fh = find(contains(gest, 'hand'));
fho = find(contains(gest, 'hand - open') |  contains(gest, 'zoom in'));
fe = find(contains(gest, 'finger') & contains(gest, 'up'));
frls = find(contains(gest, 'rock') | contains(gest, 'love') | contains(gest, 'scissor'));
fw = find(contains(gest, 'wrist'));
far = find(contains(gest, 'arm'));

dix = [ff; ft; fg; fho; fe; frls; fw; far; fn];
%id = [  zeros(1,numel(ff))+1 zeros(1,numel(ft))+2  zeros(1,numel(fg))+3 zeros(1,numel(fho))+4 zeros(1,numel(fe))+5 zeros(1,numel(frls))+5  zeros(1,numel(fw))+6 zeros(1,numel(far))+7 zeros(1,numel(fn))+8]';


results.allgestCM = cm;

if plotresults
    figure
    imagesc(cm(dix,dix));
    title([titlestr 'mean accuracy: ' num2str(mean(diag(cm))) '%']);
    colorbar
    
    caxis([0 100]);
    colormap([0 0 0; 0 0 0; parula  ]);
    
    set(gcf,'position',[481 237 867 752]);
    
    set(gca,'ytick',[1:numel(mod.ClassNames)],'yticklabel',mod.ClassNames(dix));
    set(gca,'xtick',[1:numel(mod.ClassNames)],'xticklabel',mod.ClassNames(dix));
    xtickangle(90)
end

% # of gestures vs. classification accuracy

for r = 1: numel(mod.ClassNames)

f = find(contains(labels.gest, mod.ClassNames(caix(1:r))));

modN = fitcknn(UNI(f,:), labels.gest(f),'Kfold',10,'NumNeighbors',7);
cmN = confusionmat(labels.gest(f),modN.kfoldPredict );


for r=1:size(cmN,1)
   cmN(r,:) = 100*(cmN(r,:)/ sum(cmN(r,:)));
end


percorr(r) = mean(diag(cmN));

end


results.percorrVSngest = percorr;

% if plotresults
% figure
% percorr
% h = plot(percorr);
% set(h,'linewidth',3);
% xlabel('# of gestures')
% ylabel('decoding accuracy (% correct)')
% set(gca,'fontsize',16)
% 
% set(gcf,'position',[481 237 867 752])
% end

%% Rhand: 24-way classificaiton (exclude no action)
fg = find( startsWith(labels.gest, 'Right') & ~contains(labels.gest, 'no_action')) 

mod = fitcknn(UNI(fg,:), labels.gest(fg),'Kfold',10,'NumNeighbors',7)
cm = confusionmat(labels.gest(fg),mod.kfoldPredict );

for r=1:size(cm,1)
   cm(r,:) = 100*(cm(r,:)/ sum(cm(r,:)));
end


d = diag(cm);
[v caix] = sort(d);
caix = caix(end:-1:1)


results.RgestCM = cm;


if plotresults
figure
imagesc(cm(caix,caix))
title([titlestr 'Right hand mean accuracy: ' num2str(mean(diag(cm))) '%'])
colorbar

caxis([0 100])
colormap([0 0 0; 0 0 0; parula  ])

set(gcf,'position',[481 237 867 752])

set(gca,'ytick',[1:numel(mod.ClassNames)],'yticklabel',mod.ClassNames(caix))
set(gca,'xtick',[1:numel(mod.ClassNames)],'xticklabel',mod.ClassNames(caix))
xtickangle(90)
end

%% Lhand: 24-way classificaiton (exclude no action)
fg = find( startsWith(labels.gest, 'Left') & ~contains(labels.gest, 'no_action')) 

mod = fitcknn(UNI(fg,:), labels.gest(fg),'Kfold',10,'NumNeighbors',7)
cm = confusionmat(labels.gest(fg),mod.kfoldPredict );
for r=1:size(cm,1)
   cm(r,:) = 100*(cm(r,:)/ sum(cm(r,:)));
end


d = diag(cm);
[v caix] = sort(d);
caix = caix(end:-1:1)


results.LgestCM = cm;


if plotresults
figure
imagesc(cm(caix,caix))
title([titlestr 'Left hand mean accuracy: ' num2str(mean(diag(cm))) '%'])
colorbar

caxis([0 100])
colormap([0 0 0; 0 0 0; parula  ])

set(gcf,'position',[481 237 867 752])

set(gca,'ytick',[1:numel(mod.ClassNames)],'yticklabel',mod.ClassNames(caix))
set(gca,'xtick',[1:numel(mod.ClassNames)],'xticklabel',mod.ClassNames(caix))
xtickangle(90)
end

%% Dengrodgram Gesture Group

if plotresults
valid = find(labels.DGid >0);
if numel(unique(labels.DGid(valid))) == 6
[cm] = classifyCM(UNI(valid,:),labels.DGid(valid),[{'Finger Flex.'} {'Thumb'}  {'Grasp'} {'Abduction'} {'Extension'}  {'Wrist'}  ],plotresults)
else
[cm] = classifyCM(UNI(valid,:),labels.DGid(valid),[{'Finger Flex.'} {'Thumb'}  {'Grasp'} {'Abduction'} {'Extension'}  {'Wrist'}  {'Do nothing'}],plotresults)
end
caxis([0 100])
colormap([0 0 0; 0 0 0; parula  ])

title([titlestr 'Gesture Group Classification'])

set(gcf,'position',[481 237 867 752])
end

%% Left vs. Right decoding

if plotresults
valid = find(labels.LRid >0);
[cmLR] = classifyCM(UNI(valid,:),labels.LRid(valid),[{'Left'} {'Right'}   ],plotresults);
caxis([0 100])
colormap([0 0 0; 0 0 0; parula  ])
    
title([titlestr 'Left vs. Right'])
set(gcf,'position',[481 237 867 752])
end

