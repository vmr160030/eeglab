%{
===================================basicPrecompute Script===================================
Summary of function:
This script loads datasets and precomputes a study for VTC 

Written by Vyom
8/24/2018
%}
function precomputeFunction(path, studyName, group1, epochFileName, group2, whichWay)
% variables to change
% path = 'C:\Users\vmr160030\Desktop\VTC Study Data v2\';
% studyName = 'SecondWordTheme';
% group1 = {[12 32] [22 42] };
% epochFileName = 'noBS.set';

% load datasets
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

numSubjects= 40 % replace with the number of subjects


%creating loading bar
h = waitbar(0,'LoadDataSets is running...');
hw=findobj(h,'Type','Patch');
 set(hw,'EdgeColor',[0 1 0],'FaceColor',[0 1 0]); % changes the color to green
disp( '[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;')

%selecting specific subjects
subjects=[5:18 23:35 37:40]
counter=0;
l=length(subjects);
list=cell(numSubjects, 1);

for i=subjects %i=1:numSubjects %replace this to match number of subjects
    
    s=i;
   counter=counter+1;
 
  %==== Copy and paste this section from subjects.m 
  
if s == 1
    subject = '021718_1f';
elseif s == 2
    subject = '021718_2f';
elseif s == 3
    subject = '021718_3f';
elseif s == 4
    subject = '021718_4f';
elseif s == 5
    subject = '032018_1f';
elseif s == 6
    subject = '032018_2f';
elseif s == 7
    subject = '032018_3f';
elseif s == 8
    subject = '032318_1f';
elseif s == 9
    subject = '032318_2f';
elseif s == 10
    subject = '032318_3f';
elseif s == 11
    subject = '032318_4f';
elseif s == 12
    subject = '032318_5m';
elseif s == 13
    subject = '032318_6m';
elseif s == 14
    subject = '032318_7f';
elseif s == 15
    subject = '032418_1f';
elseif s == 16
    subject = '032418_2f';
elseif s == 17
    subject = '032418_3m';
elseif s == 18
    subject = '032418_4f';
elseif s == 19
    subject = '032618_1f';
elseif s == 20
    subject = '032618_2f';
elseif s == 21
    subject = '032618_3f';
elseif s == 22
    subject = '032618_4f';
elseif s == 23
    subject = '032718_1f';
elseif s == 24
    subject = '032718_2f';
elseif s == 25
    subject = '033018_1m';
elseif s == 26
    subject = '033018_2m';
elseif s == 27
    subject = '033018_3f';
elseif s == 28
    subject = '033018_4f';
elseif s == 29
    subject = '033018_5f';
elseif s == 30
    subject = '033018_6f';
elseif s == 31
    subject = '033118_1f';
elseif s == 32
    subject = '033118_2f';
elseif s == 33
    subject = '033118_3f';
elseif s == 34
    subject = '033118_4f';
elseif s == 35
    subject = '040218_1f';
elseif s == 36
    subject = '040518_1f';
elseif s == 37
    subject = '040518_2f';
elseif s == 38
    subject = '040518_3f';
elseif s == 39
    subject = '040618_1f';
elseif s == 40
    subject = '040618_2m';
end

    
%=====paste until the above section==========


list{i}=subject;
    subjnum=strcat('%Subject', int2str(i), ' is done');
    disp(subjnum)
   
  
    
 %====conditions and folder location====%
    
    
 %replace conditions and folder    
       
        EEG = pop_loadset('filename',epochFileName,'filepath',strcat(path,'\',studyName,'\', list{i}, '\\'));
       [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
       
        
ratio=counter/length(subjects);
%ratio=i/numSubjects;
  waitbar(ratio,h); %updates waitbar
  
end
close(h);
disp('LoadDataSets is done running');

if(whichWay == 1)
        disp('doing one way');   
        [EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,31);
        [STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'updatedat','on','rmclust','off' );
        [STUDY ALLEEG] = std_checkset(STUDY, ALLEEG);
        CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
        STUDY = std_makedesign(STUDY, ALLEEG, 1, 'variable1','type','variable2','type','name','STUDY.design 1','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',group1,'subjselect',{'032018_1f' '032018_2f' '032018_3f' '032318_1f' '032318_2f' '032318_3f' '032318_4f' '032318_5m' '032318_6m' '032318_7f' '032418_1f' '032418_2f' '032418_3m' '032418_4f' '032718_1f' '032718_2f' '033018_1m' '033018_2m' '033018_3m' '033018_4f' '033018_5f' '033018_6f' '033118_1f' '033118_2f' '033118_3f' '033118_4f' '040218_1f' '040518_2f' '040518_3f' '040618_1f' '040618_2m'});
        [STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','on','recompute','on','erp','on','erpparams',{'rmbase' [-100 0] },'on','erspparams',{'cycles' [2 0.5]  'nfreqs' 100 'freqs' [3 50] 'baseline' [-500 0]},'itc','on');
        EEG = eeg_checkset( EEG );
        [STUDY EEG] = pop_savestudy( STUDY, EEG, 'filename',studyName,path);
        CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
    
    
elseif(whichWay == 2)
        disp('doing two way');
        [EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,31);
        [STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'updatedat','on','rmclust','off' );
        [STUDY ALLEEG] = std_checkset(STUDY, ALLEEG);
        CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
        STUDY = std_makedesign(STUDY, ALLEEG, 1, 'variable1','type','variable2','type','name','STUDY.design 1','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',group1,'values2',group2,'subjselect',{'032018_1f' '032018_2f' '032018_3f' '032318_1f' '032318_2f' '032318_3f' '032318_4f' '032318_5m' '032318_6m' '032318_7f' '032418_1f' '032418_2f' '032418_3m' '032418_4f' '032718_1f' '032718_2f' '033018_1m' '033018_2m' '033018_3m' '033018_4f' '033018_5f' '033018_6f' '033118_1f' '033118_2f' '033118_3f' '033118_4f' '040218_1f' '040518_2f' '040518_3f' '040618_1f' '040618_2m'});
        [STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','on','recompute','on','erp','on','erpparams',{'rmbase' [-100 0] },'on','erspparams',{'cycles' [2 0.5]  'nfreqs' 100 'freqs' [3 50] 'baseline' [-500 0]},'itc','on');
        EEG = eeg_checkset( EEG );
        [STUDY EEG] = pop_savestudy( STUDY, EEG, 'filename',studyName,path);
        CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
    
end

%precompute
[EEG ALLEEG CURRENTSET] = eeg_retrieve(ALLEEG,31);
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'updatedat','on','rmclust','off' );
[STUDY ALLEEG] = std_checkset(STUDY, ALLEEG);
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
STUDY = std_makedesign(STUDY, ALLEEG, 1, 'variable1','type','variable2','type','name','STUDY.design 1','pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',group1,'subjselect',{'032018_1f' '032018_2f' '032018_3f' '032318_1f' '032318_2f' '032318_3f' '032318_4f' '032318_5m' '032318_6m' '032318_7f' '032418_1f' '032418_2f' '032418_3m' '032418_4f' '032718_1f' '032718_2f' '033018_1m' '033018_2m' '033018_3m' '033018_4f' '033018_5f' '033018_6f' '033118_1f' '033118_2f' '033118_3f' '033118_4f' '040218_1f' '040518_2f' '040518_3f' '040618_1f' '040618_2m'});
[STUDY ALLEEG] = std_precomp(STUDY, ALLEEG, {},'interp','on','recompute','on','erp','on','erpparams',{'rmbase' [-100 0] },'on','erspparams',{'cycles' [2 0.5]  'nfreqs' 100 'freqs' [3 50] 'baseline' [-500 0]},'itc','on');
EEG = eeg_checkset( EEG );
[STUDY EEG] = pop_savestudy( STUDY, EEG, 'filename',studyName,path);
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];


disp('Study precomputing is done running');
end

