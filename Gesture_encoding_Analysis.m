% Analysis code for: Gesture Encoding in human left premotor cortex neuronal ensembles
% Carlos Vargas-Irwin, Brown University, https://orcid.org/0000-0002-3526-3754
% 
% %%%%%%%%%%%%%%%%%%% Overview
% 
% This script will run other functions in the repository to perform the following:
% 1. Latent space generation from neural data
% 2. Latent space alignment
% 3. Generation of Gesture dendrograms based on the similarity of the neural activity patterns
% 4. Visualization of Neural latent spaces (3D plots)
% 5. Classification using the combined latent spaces 
% 
% %%%%%%%%%%%%%%%%%%% Variables & data organization
% 
% DataMatOL: Neural data collected during open loop blocks.
% Neural data is stored in 3D matrices [K , T, F], where K = trial number,T = time bin and F = neural feature. 
% Neural features were either  spiking activity (threshold crossings) of local field potential power
% in the 250 Hz - 5 kHz band (8th order IIR Butterworth) collected in 20ms bins and smoothed with a
% 200ms gaussian kernel. Each trial corresponds to the execution of oneintended gesture, 
% including 50 bins (1 second) beofre and another 50 after the 'go' instruction, for a total of 100 bins (2 seconds). 
% Only features that displayed significant task modulation were included in the analysis. 
% 
% DataMatCL: Similar to DataMatOL, except for closed loop control blocks
% 
% labels: data structure with informational labels for each trial of the 8249 trials in the concatenated data structure.
%     Includes the following fields: 
%     sessid: [8249×1 double]     session # (1-8). Sessions 1-6 correspond to participant T11, 7 and 8 to T5.
%     gest: [8249×1 string]       the gesture cued for each trial
%     DGid: [8249×1 double]       gesture group derived from T11 dendrogram (1-7)
%     LRid: [8249×1 double]       Left (1) or Right (2) hand
%     FlexExtid: [8249×1 double]  Flexion (1) or extension (2)
%     gestNLR: [8249×1 string]    Gesture labels that omit the Left / Right designations 
%     
%     Plus the following fields, which contain the names for specific groups (used to label figures)
%     DGnames: {1×7 cell}         
%     LRnames: {'Left'  'Right'}
%     FlexExt: {'Flexion'  'Extension'}
%     
% UNI_C: After the latent spaces are generated and aligned, they are stored in the UNI_C variable
% of size 8249 (number of trials) x 15 (number of latent space dimensions)

%% load processed Data
load('Gesture_Encoding_processed_data.mat')


%% 1. Generate latent space plots for all datasets independently

[CSIMS, basedmat] = GesturePaper1_StateSpacePlots( dataMatOL, dataMatCL);

%% 2. align all latent spaces 

show = 0;
[UNI_CT11, UNIprocDT11, transT11] = spaceAlignPRO(CSIMS(1:6),labels.gestBySession(1:6),show);

[UNI_CT5, UNIprocDT5, transT5] = spaceAlignPRO(CSIMS(7:8),labels.gestBySession(7:8),show);

UNI_C = vertcat(UNI_CT11, UNI_CT5);


%% 3. Generate Dendrograms

figure
[GtreeT11 GleafOrderT11] = gestureDendro(UNI_C(find(labels.sessid<7),:),labelsT11);
title('T11 Sessions 1-6')
 set(gcf,'position',[730 564 1007 420])


figure
[Gtree3 GleafOrder3] = gestureDendro(UNI_C(find(labels.sessid>6),:),labelsT5);
title('T5 Sessions 1-2')
set(gcf,'position',[730 564 1007 420])


%% 4. Visualize Full ensemble CSIMS gesture spaces for each participant
% Create separate CSIMS plots for each set of sessions
% plot params 
radius = 1;
spherepoints = 10;
RLcolormat = [0 0 0; lines((6)); 0 0 0 ];
colormat = [lines((6)); 0 0 0 ];

 figure
for n = 4:6
f = find( labels.sessid == n & labels.DGid>0);
skittlesPlot( UNI_C(f,:) , labels.DGid(f), radius, spherepoints,colormat);
hold on 
view(2)
end
title('T11 sessions 1-6')

%%
 figure
for n = 7:8
f = find( labels.sessid == n & labels.DGid>0);
skittlesPlot(UNI_C(f,:) , labels.DGid(f), radius, spherepoints,colormat);
hold on 
view([-180 -90])
end
L = findobj(gcf,'Type','Light'); set(L(1),'position',get(gca,'cameraposition')); set(L(2),'position',get(gca,'cameraposition')*-1); 
title('T5 Session 1-2')


%% 5. Ensemble decoding

f = find( labels.sessid <7);
[ ENSresultsT11 ]  = GesturePaper1_Ensemble_Decoding(UNI_C(f,:),labelsT11,1,'T11 ');

f = find( labels.sessid >6);
[ ENSresultsT5 ]  = GesturePaper1_Ensemble_Decoding(UNI_C(f,:),labelsT5,1,'T5 ');


%% Decoding accuracy vs. # of gestures 

for n = 1:numel(dataMatOL)
%labelsN = parseGestureLabels(gestOL(n), gestCL(n) );
labelsN.gest = labels.gestBySession{n};
labelsN.DGid = labels.DGidBySession{n};
labelsN.LRid = labels.LRidBySession{n};
labelsN.FlexExtid = labels.FlexExtidBySession{n};
f = find( labels.sessid == n);
warning('off')
[ ENSresultsN{n} ]  = GesturePaper1_Ensemble_Decoding(UNI_C(f,:),labelsN,0,'');
warning('on')
end
%%
figure

colormat = [lines((6)); lines((2))];
pcvng = ENSresultsN{1}.percorrVSngest(1:48);
for n = 1:numel(dataMatOL)
h = plot(ENSresultsN{n}.percorrVSngest); set(h,'linewidth',2,'color',colormat(n,:));
    hold on
    if n>1
        pcvng = pcvng+ENSresultsN{n}.percorrVSngest(1:48);
    end
    if n >6
    set(h,'linestyle','--');
    end
end
pcvng = pcvng / numel(dataMatOL);
h = plot(pcvng,'k'); set(h,'linewidth',4)
ylabel('decoding accuracy (% correct)')
xlabel('# of gestures')
legend([{'T11(1)'} {'T11(2)'}  {'T11(3)'}  {'T11(4)'}  {'T11(5)'}  {'T11(6)'} {'T5(1)'} {'T5(2)'} {'average'}]);
set(gca,'fontsize',12)





