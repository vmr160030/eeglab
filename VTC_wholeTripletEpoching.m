
%{
===================================VTC wholeTriplet epoching Script===================================
Summary of function:
This script epochs and rejects epochs using 4 methods for VTC
from -0.5 to 2.0 seconds around the first word, second word, and third word

Written by Vyom
9/17/2018
%}


i = 1;
j = 1;
numEpochsBeforeReject = [];
numEpochs = [];

%cell array of subject names
subjectName = ["032018_1f",
"032018_2f",
"032018_3f",
"032318_1f",
"032318_2f",
"032318_3f",
"032318_4f",
"032318_5m",
"032318_6m",
"032318_7f",
"032418_1f",
"032418_2f",
"032418_3m",
"032418_4f",
"032718_1f",
"032718_2f",
"033018_1m",
"033018_2m",
"033018_3f",
"033018_4f",
"033018_5f",
"033018_6f",
"033118_1f",
"033118_2f",
"033118_3f",
"033118_4f",
"040218_1f",
"040518_2f",
"040518_3f",
"040618_1f",
"040618_2m"
];

%cell array of filepath for corrected eventlists
subjectEventPath = ["K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032018_1f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032018_2f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032018_3f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032318_1f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032318_2f\032318_2fCORRECTED_NEW_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032318_3f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032318_4f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032318_5m\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032318_6m\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032318_7f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032418_1f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032418_2f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032418_3m\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032418_4f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032718_1f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\032718_2f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033018_1m\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033018_2m\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033018_3f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033018_4f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033018_5f\newcorrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033018_6f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033118_1f\correctedNEW_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033118_2f\correctedNEW_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033118_3f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\033118_4f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\040218_1f\corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\040518_2f\040518_2f_NEW_CORRECTEDeventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\040518_3f\040518_3f_NEW_CORRECTEDeventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\040618_1f\040618_1f_corrected_eventlist.csv",
"K:\Dept\CallierResearch\Maguire\Pre-processing\Vyom Theme Category\040618_2m\corrected_eventlist.csv"
];


%loops through all elements of subjectName
while i < (numel(subjectName) + 1)
    %%
    
    %start eeglab. This will automatically clear loaded datasets.
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    
    %load averef file
    EEG = pop_loadset('filename',strcat(subjectName{i,1},'_averef.set'),'filepath',strcat('K:\\Dept\\CallierResearch\\Maguire\\Pre-processing\\Vyom Theme Category\\',subjectName{i,1},'\\') );
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', strcat('C:\Users\vmr160030\Desktop\eventListDoubleCheck\',num2str(i),'_Before_subject_erplab.csv') );
    
    
    %import corrected eventlist
    EEG = pop_importevent( EEG, 'append','no','event',subjectEventPath{i,1},'fields',{'number' 'type' 'latency' 'urevent' 'duration'},'skipline',1,'timeunit',1,'align',0);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', strcat('C:\Users\vmr160030\Desktop\eventListDoubleCheck\',num2str(i),'_After_subject_erplab.csv') );
    
    %%
    
    %epoch for desired trigger codes and time frame
    EEG = pop_epoch( EEG, {  '11'  '21'  '31'  '41'  '51'  '61'  '71'  '81'  '12' '22' '32' '42' '52' '62' '72' '82' '131' '132' '23' '331' '332' '43' '531' '532' '631' '634' '73' '83'}, [-0.5         2.0], 'newname', strcat(subjectName{i,1},'_epoched'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    EEG = eeg_checkset( EEG );
    %NOTE: not removing baseline as test, put this back in later. 
    %EEG = pop_rmbase( EEG, [-500    0]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
    EEG = eeg_checkset( EEG );
    
    
    
    %record number of epochs before rejection in array for later review
    numEpochsBeforeReject = [numEpochsBeforeReject numel(EEG.epoch)];
    
    
    %reject epochs using 4 methods: eegthresh, rejtrend, jointprob, and rejkurt
    [EEG, indices] = pop_eegthresh(EEG,1,[1:length(EEG.chanlocs)] ,-75,75,-0.5,4.498,2,0);
    EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
    for (j = 1:length(indices)) %#ok<*NO4LP>
       EEG.reject.rejglobal(1,indices(j)) = 1;
    end
    EEG = pop_rejtrend(EEG,1,[1:length(EEG.chanlocs)] ,2500,50,0.3,2,0);
    EEG = pop_jointprob(EEG,1,[1:length(EEG.chanlocs)] ,5,5,0,0,0,[],0);
    EEG = pop_rejkurt(EEG,1,[1:length(EEG.chanlocs)] ,5,5,0,0,0,[],0);
    EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
    EEG = pop_rejepoch( EEG, EEG.reject.rejglobal,0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off'); 
    EEG = eeg_checkset( EEG );
    
    
    %record number of epochs in array for later review
    numEpochs = [numEpochs numel(EEG.epoch)];
    
    
    %save epoched dataset to desired path
    savePath = strcat('K:\Dept\CallierResearch\Maguire\Epoched Data\Vyom Theme Category\',subjectName{i,1},'\noBSLong.set');
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'savenew',savePath,'gui','off');  %#ok<*ASGLU>
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    
    %increment counter
    i = i + 1;

end


 disp('VTC epoching is done running');