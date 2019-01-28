
%{
===================================ERSP_Bins Script===================================
Summary of function:
This script plots ERSP scalp map bins of specified widths for all electrodes.
You need to have a study loaded first. Updated to enable monte carlo w/ CC
analysis

Written by Vyom
8/24/2018
edited 1/24/2019
%}

%montecarlo with cluster corrections or permutation analysis?
%enter 1 for montecarlo or 2 for permutation
statMethod = 1;

%if montecarlo, which variable to analyze?
%enter 1 for 1st variable or 2 for 2nd variable
whichVar = 1;


%frequency range of interest
freq = [9 10];

%initial and final time points
initial = 0;
final = 10;

%width of bins
bin = 2;

%power limits for maps
lims = [-0.8 0.8];

%save images where?
saveDir = 'C:\Users\vmr160030\Desktop\Test\';

%what dimensions would you like for your images?
width = 650;
height = 650;


i = initial;
while i < final
    if (statMethod == 2)
        STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','on','naccu',1000,'method','perm','alpha',0.05);
        stat = 'permutation';
    elseif (statMethod == 1)
        if(whichVar == 1)
            STUDY = pop_statparams(STUDY, 'condstats','on','groupstats','off','mode','fieldtrip','fieldtripnaccu',1000,'fieldtripmethod','montecarlo','fieldtripmcorrect','cluster','fieldtripalpha',0.05);
            %STUDY = pop_statparams(STUDY, 'groupstats','off','condstats','on','mode','fieldtrip','fieldtripnaccu',1000,'fieldtripmethod','montecarlo','fieldtripalpha',0.05);
        elseif(whichVar == 2)
            STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','off','mode','fieldtrip','fieldtripnaccu',1000,'fieldtripmethod','montecarlo','fieldtripmcorrect','cluster','fieldtripalpha',0.05);
            %STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','off','mode','fieldtrip','fieldtripnaccu',1000,'fieldtripmethod','montecarlo','fieldtripalpha',0.05);
        end
        stat = 'monteCarlo';
    end
STUDY = pop_erspparams(STUDY, 'topotime',[i i+bin] ,'topofreq', freq, 'ersplim', lims);
STUDY = std_erspplot(STUDY,ALLEEG,'channels',{'FP1' 'FPZ' 'FP2' 'AF3' 'AF4' 'F7' 'F5' 'F3' 'F1' 'FZ' 'F2' 'F4' 'F6' 'F8' 'FT7' 'FC5' 'FC3' 'FC1' 'FCZ' 'FC2' 'FC4' 'FC6' 'FT8' 'T7' 'C5' 'C3' 'C1' 'CZ' 'C2' 'C4' 'C6' 'T8' 'TP7' 'CP5' 'CP3' 'CP1' 'CPZ' 'CP2' 'CP4' 'CP6' 'TP8' 'P7' 'P5' 'P3' 'P1' 'PZ' 'P2' 'P4' 'P6' 'P8' 'PO7' 'PO5' 'PO3' 'POZ' 'PO4' 'PO6' 'PO8' 'CB1' 'O1' 'OZ' 'O2' 'CB2'});
%STUDY = std_erspplot(STUDY,ALLEEG,'channels',{'FP1' 'FPZ' 'FP2' 'AF3' 'AF4'});

savePath = strcat(saveDir,'\ERSP scalp ',num2str(freq),' Hz ',num2str(i),'-',num2str(i + bin),' ms_',stat,'_variable_',num2str(whichVar),'.jpeg');
fig1 = gcf;
fig1.PaperUnits = 'points';
fig1.PaperPosition = [0 0 width height];
saveas(fig1,savePath);
close(gcf);

i = i + 50;
end

disp('50ms bins is done running');
