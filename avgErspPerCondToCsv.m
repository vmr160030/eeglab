% Script to obtain average ersp power across specified times, freqs, channels. 
% Output is of shape [subjects x electrodes] for each condition
%
% For multiple conditions, multiple csv files will be output with condition
% number appended like {filename}_{condition_number}.csv
%
% Please note that this script assumes same number of subjects for each
% condition. If this is not true for your study, output may be wrong.
%
% Author : Vyom Raval
% Email: vmr160030@utdallas.edu
% Date created: 09/12/2019
% Last modified: 02/18/2020
% Tested on: eeglab14.0.0b, eeglab14.1.1b, eeglab 14.1.2b
% Tested using: K:\Dept\CallierResearch\Maguire\RA Folders\Manju\Working Memory\14yrs All 091919.study 
%               G:\EEGfiles\Research\WLNSF\DevDiff_3ages\3ages_devdiff_022119.study
%               K:\Dept\CallierResearch\Maguire\Tina\TEST study for Vyom\teststudyforvyom02122020.study

% TODO: Make this a function that takes inputs

%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT ZONE BEGINS %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Path to file you want to save. Please do not include the .csv extension.
strOutputCsv = 'C:\eeglab14_1_1b\git-eeglab-master\BrainLanguageRevision\TinaTestStudy';

% Time and frequency range
arrTimeRange = [0 4000];
arrFreqRange = [4 8];

% Ensure that this has no repeats and each electrode is
% typed correctly with no spaces. eg- 'C1'
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
nElecs = size(cElecs, 2); % Number of electrodes

% Get total subjects in each condition. 
nSubjects = size(STUDY.design(STUDY.currentdesign).cases.value,2);

% Array of outputs of shape [conditions x subjects x electrodes]
arrResults = zeros(nConditions, nSubjects, nElecs); 


% erspdata has shape [1 x channels x subjects]



% For each condition
for nCond = 1:nConditions 
    nShift = 0;
    % For each group
    for nGrp = 1:nGroups
        arrCondData = erspdata{nCond, nGrp}; % Matrix of that condition's data  
        
        nSubjectsInGroup = size(arrCondData, 3);
        
        % For each subject in the group
        for nSub = 1:nSubjectsInGroup
            % Reshape condition data for a subject to be [1 x channels]
            arrReshapedData = reshape(arrCondData(:, :, nSub), 1, []);

            % Save values for each electrode
            arrResults(nCond, nSub+nShift, :) = arrReshapedData;
        end    
        nShift = nSubjectsInGroup + nShift;
    end  
end

% Output results to a csv file for each condition
for nCond = 1:nConditions
    cRowNames = {STUDY.design(STUDY.currentdesign).cases.value}};
    cRowNames = {cRowNames{1:nSubjects}};
    % If duplicate subjects, concatenate value to subject ID
    if numel(cRowNames) ~= numel(unique(cRowNames))
        for nSub=1:nSubjects
           strToCat = '';
           cValue = STUDY.design(STUDY.currentdesign).cell(nSub).value;
           for nVal=1:numel(cValue)
               strToCat = strcat(strToCat, num2str(cValue{nVal}));
           end
           
           cRowNames{nSub} = strcat(cRowNames{nSub}, '_', strToCat);
        end        
    end
    
    tableResults = array2table(squeeze(arrResults(nCond, :, :)),...
        'VariableNames', cElecs, 'RowNames', cRowNames);
    
    % Append condition number to csv name
    strOutputFileName = strcat(strOutputCsv, '_cond',num2str(nCond), '.csv');
    writetable(tableResults,strOutputFileName, 'WriteRowNames',true);
end
fclose('all');