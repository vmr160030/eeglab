% Script to obtain average ersp power across specified times, freqs, channels. 
% Output is of shape [conditions x subjects]
%
% Author : Vyom Raval
% Email: vmr160030@utdallas.edu
% Date created: 09/12/2019
% Last modified: 02/06/2020
% Tested on: eeglab14.0.0b, eeglab14.1.1b
% Tested using: K:\Dept\CallierResearch\Maguire\RA Folders\Manju\Working Memory\14yrs All 091919.study 

% TODO: Make this a function that takes inputs

%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT ZONE BEGINS %%%%%%%%%%%%%%%%%%%%%%%%%%%
strOutputCsv = 'C:\eeglab14_1_1b\scriptsForDrMaguire\BrainLanguageRevision\VyomTest.csv'; % Path to file you want to save
arrTimeRange = [0 4000];
arrFreqRange = [4 8];

% Ensure that this has no repeats and each electrode is
% typed correctly with no spaces like 'C1'
cElecs = {'FP1', 'Fpz','FP2','Af3','af4','f7','f5','f3','f1','fz','f2', ...
          'f4','f6','f8','fc5','fc3','fc1','fcz','fc2','fc4','fc6'}; 
%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT ZONE ENDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check for repeats
bArrRepeat = size(cElecs) ~= size(unique(cElecs));
if bArrRepeat(2)
    disp('Please make sure cElecs has no repeats');
    [D,~,X] = unique(cElecs(:));
    Y = hist(X,unique(X));
    Z = struct('name',D,'freq',num2cell(Y(:)));
    disp('The following were repeated');
    disp(D(Y>1));
    return;
end

%Compute ersp with std_erspplot
STUDY = pop_statparams(STUDY, 'groupstats','on','condstats','on',...
    'naccu',1000,'method','perm','alpha',0.05);
STUDY = pop_erspparams(STUDY, 'topotime', arrTimeRange,'topofreq', arrFreqRange);
[STUDY erspdata ersptimes erspfreqs pgroup pcond pinter] = std_erspplot(STUDY,...
    ALLEEG, 'channels', cElecs);

arrDataShape = size(erspdata); % Shape of ersp data
nConditions = arrDataShape(1); % Number of conditions
nGroups = arrDataShape(2); % Number of groups

% Get total subjects 
nSubjects = 0;
% For each group
for nGrp = 1:nGroups
    % For each condition
    for nCond = 1:nConditions 
        arrCondData = erspdata{nCond, nGrp}; % Matrix of that condition's data  
        
        arrCondDataShape = size(arrCondData);
        nSubjectsInGroup = arrCondDataShape(end);
        nSubjects = nSubjects + nSubjectsInGroup;
    end
end

arrResults = zeros(nConditions, nSubjects); % Matrix of outputs of shape [conditions x subjects]


% erspdata has shape [freqs x times x channels x subjects], or [1 x channels x subjects]

% For each group
nSubjectsInPrevGroup = 0;
for nGrp = 1:nGroups
    % For each condition
    for nCond = 1:nConditions 
        arrCondData = erspdata{nCond, nGrp}; % Matrix of that condition's data  
        
        arrCondDataShape = size(arrCondData);
        nSubjectsInGroup = arrCondDataShape(end);
        
        % For each subject in the group
        for nSub = nSubjectsInPrevGroup+1:nSubjectsInGroup+nSubjectsInPrevGroup
            % non subject dimensions
            strOtherDims = repmat({':'},1,ndims(arrCondData)-1);      

            % Reshape condition data for a subject to be [1 x freqs*times*channels]
            arrReshapedData = reshape(arrCondData(strOtherDims{:}, nSub), 1, []);

            % Take the mean over the second dimension, leaving 1 number for each subject
            arrResults(nCond, nSub) = mean(arrReshapedData, 2);
        end
    end
    nSubjectsInPrevGroup = nSubjectsInGroup;
end

% Output results to a csv file
cHeader = STUDY.subject;
%turn the headers into a single comma seperated string if it is a cell array, 
header_string = cHeader{1};
for i = 2:length(cHeader)
    header_string = [header_string,',',cHeader{i}];
end
%write header to file
fid = fopen(strOutputCsv,'w'); 
fprintf(fid,'%s\n',header_string);
fclose(fid);
%write data to end of file
dlmwrite(strOutputCsv,arrResults,'-append');