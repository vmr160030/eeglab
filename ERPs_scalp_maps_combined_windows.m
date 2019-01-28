
%{
===================================ERP_scalp_maps_combined_windows Script===================================
Summary of function:
This script plots ERP scalp maps for specified time windows
windows. Be sure to edit all initial variables.

Written by Vyom
12/24/2018
%}

%include study names here
%for instance if your study is called "xyz.study" put in "xyz"
%If you have multiple studies, separate their names with a comma
cond = ["SecondWordCatV3Small","SecondWordThemeV3Small"];

%where are the studies located?
studyDir = 'C:\Users\vmr160030\Desktop\VTC Study Data v2\';

%where would you like to save images?
saveDir = 'C:\Users\vmr160030\Desktop\VTC Study Outputs v2\secondWord\ERP combined small\';


%over what combined time windows would you like to plot scalp maps? 
times = {... %time windows of interest for first study: 
         { [350 600], [250 400], [250 400], [500 600], [450 650], [250 400] },...
          %time windows of interest for second study:
         { [450 650], [350 500], [500 600], [500 600] },...
          %if you have more than two studies, you can add a set of time
          %windows like this:
          %{ [time1 time2], [time3 time4] },...
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
        %plotting topo
        savePath = strcat(saveDir,cond{1,studyNum},'_topo_',num2str(times{1, studyNum}{1,plot}),' ms.jpeg'); 
        STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','on','naccu',1000,'method','perm','alpha',0.05);
        STUDY = pop_erpparams(STUDY, 'plotgroups','together','plotconditions','together','topotime',times{1, studyNum}{1,plot},'averagechan','off' );
        STUDY = std_erpplot(STUDY,ALLEEG,'channels',allElecs);
        fig1 = gcf;
        fig1.PaperUnits = 'points';
        fig1.PaperPosition = [0 0 width height];
        saveas(fig1,savePath);
        close(gcf);
    end
end
disp('ERP scalp maps @ combined windows is done running');
