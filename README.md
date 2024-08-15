# Gesture Encoding in human left premotor cortex neuronal ensembles

Analysis code for: Gesture Encoding in human left premotor cortex neuronal ensembles

Carlos Vargas-Irwin, Brown University
https://orcid.org/0000-0002-3526-3754

%%%%%%%%%%%%%%%%%% Overview

This **Gesture_Encoding_Analysis.m** script will run other functions in the repository to perform the following:
1. Latent space generation from neural data
2. Latent space alignment
3. Generation of Gesture dendrograms based on the similarity of the neural activity patterns
4. Visualization of Neural latent spaces (3D plots)
5. Classification using the combined latent spaces

The script will load processed data in 'Gesture_Encoding_processed_data.mat'.
Access the datata file here: \\files22.brown.edu\LRSResearch\ENG_BrainGate_Shared\BG2\UserShare\Carlos\GesturePaperRepo 
NOTE: will be updated with the Dryad link once the paper is accepted

%%%%%%%%%%%%%%%%%% Variables & data organization

DataMatOL: Neural data collected during open loop blocks.
Neural data is stored in 3D matrices [K , T, F], where K = trial number,T = time bin and F = neural feature. 
Neural features were either  spiking activity (threshold crossings) of local field potential power
in the 250 Hz - 5 kHz band (8th order IIR Butterworth) collected in 20ms bins and smoothed with a
200ms gaussian kernel. Each trial corresponds to the execution of oneintended gesture, 
including 50 bins (1 second) beofre and another 50 after the 'go' instruction, for a total of 100 bins (2 seconds). 
Only features that displayed significant task modulation were included in the analysis. 

DataMatCL: Similar to DataMatOL, except for closed loop control blocks

labels: data structure with informational labels for each trial of the 8249 trials in the concatenated data structure.
    Includes the following fields: 
    sessid: [8249×1 double]     session # (1-8). Sessions 1-6 correspond to participant T11, 7 and 8 to T5.
    session ID 1: T11 trial day 219
			   2: T11 trial day 227
			   3: T11 trial day 248
			   4: T11 trial day 854
			   5: T11 trial day 856
			   6: T11 trial day 861
			   7: T5 trial day 2084
			   8: T5 trial day 2255
    gest: [8249×1 string]       the gesture cued for each trial
    DGid: [8249×1 double]       gesture group derived from T11 dendrogram (1-7)
    dendrogram group 1: Finger Flex.    
                     2: Thumb    
                     3: Grasp    
                     4: Abduction   
                     5: Extension    
                     6: Wrist  
                     7: Do Nothing
    LRid: [8249×1 double]       Left (1) or Right (2) hand
    FlexExtid: [8249×1 double]  Flexion (1) or extension (2)
    gestNLR: [8249×1 string]    Gesture labels that omit the Left / Right designations 

    Plus the following fields, which contain the names for specific groups (used to label figures)
    DGnames: [    {'Finger Flex.'}    {'Thumb'}    {'Grasp'}    {'Abduction'}    {'Extension'}    {'Wrist'}   {'Do Nothing'} ]
    LRnames: ['Left'  'Right']
    FlexExt: ['Flexion'  'Extension']

UNI_C: After the latent spaces are generated and aligned, they are stored in the UNI_C variable
of size 8249 (number of trials) x 15 (number of latent space dimensions)
