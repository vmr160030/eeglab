
%{
===================================ERP_at_combined_times Script===================================
Summary of function:
This script plots ERP waveforms for specified electrodes over a common
timeRange

Written by Vyom
12/24/2018
edited 1/7/2019
%}

%include study names here
%for instance if your study is called "xyz.study" put in "xyz"
%If you have multiple studies, separate their names with a comma
cond = ["SecondWordCatV3Small","SecondWordThemeV3Small"];

%where are the studies located?
studyDir = 'C:\Users\vmr160030\Desktop\VTC Study Data v2\';

%where would you like to save images?
saveDir = 'C:\Users\vmr160030\Desktop\VTC Study Outputs v2\secondWord\ERP combined small\';

%what is the common time range?
timeRange = [-500 1500];

%what electrodes would you like to average over? 
elecs = {...%electrode groups of interest for first study:
          { {'FCZ' 'FC2' 'CP1' 'CPZ' 'CP2' 'CZ'}, {'FCZ' 'FC2' 'C2' 'F2'} },...
          %electrode groups of interest for second study:
          { {'CPZ' 'CZ' 'C1' 'PZ' 'CP1' 'CP2'}, {'CPZ' 'CZ' 'C1' 'PZ' 'CP1' 'CP2'} },...
          %if you have more than two studies, you can add electrode groups
          %like so:
          %{ {'electrode1' 'electrode2'}, {'electrode3' 'electrode4'} },...
        };

%what dimensions would you like for your images?
width = 650;
height = 650;

    
%a list of all electrode names
allElecs = {'FP1' 'FPZ' 'FP2' 'AF3' 'AF4' 'F7' 'F5' 'F3' 'F1' 'FZ' 'F2' 'F4' 'F6' 'F8' 'FT7' 'FC5' 'FC3' 'FC1' 'FCZ' 'FC2' 'FC4' 'FC6' 'FT8' 'T7' 'C5' 'C3' 'C1' 'CZ' 'C2' 'C4' 'C6' 'T8' 'TP7' 'CP5' 'CP3' 'CP1' 'CPZ' 'CP2' 'CP4' 'CP6' 'TP8' 'P7' 'P5' 'P3' 'P1' 'PZ' 'P2' 'P4' 'P6' 'P8' 'PO7' 'PO5' 'PO3' 'POZ' 'PO4' 'PO6' 'PO8' 'CB1' 'O1' 'OZ' 'O2' 'CB2'};



for studyNum=1:numel(cond) 
    
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[STUDY ALLEEG] = pop_loadstudy('filename', strcat(cond{1,studyNum},'.study'), 'filepath',studyDir);
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];   
    
    for plot = 1:numel(times{1,studyNum})
        %plotting waveform
        STUDY = pop_statparams(STUDY, 'condstats','on','naccu',1000,'method','perm','alpha',0.05);
        STUDY = pop_erpparams(STUDY,'plotconditions','together','timerange',timeRange ,'averagechan','on','topotime',[],'filter',30);
        STUDY = std_erpplot(STUDY,ALLEEG,'channels',elecs{1,studyNum}{1,plot});
        savePath = strcat(saveDir,cond{1,studyNum},'_wave_elecGroup',num2str(plot),'.jpeg');
        fig1 = gcf;
        fig1.PaperUnits = 'points';
        fig1.PaperPosition = [0 0 width height];
        saveas(fig1,savePath);
        close(gcf);
    end
end
disp('ERP waveforms is done running');

