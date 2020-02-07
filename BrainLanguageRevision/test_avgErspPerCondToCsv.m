% Script to obtain average ersp power across specified times, freqs, channels. 
% Output is of shape [subjects x electrodes] for each condition
%
% For multiple conditions, multiple csv files will be output with condition
% number appended like {filename}_{condition_number}.csv
%
% Author : Vyom Raval
% Email: vmr160030@utdallas.edu
% Date created: 09/12/2019
% Last modified: 02/07/2020
% Tested on: eeglab14.0.0b, eeglab14.1.1b, eeglab 14.1.2b
% Tested using: K:\Dept\CallierResearch\Maguire\RA Folders\Manju\Working Memory\14yrs All 091919.study 
%               G:\EEGfiles\Research\WLNSF\DevDiff_3ages\3ages_devdiff_022119.study

% TODO: Make this a function that takes inputs

%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT ZONE BEGINS %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Path to file you want to save. Please do not include the .csv extension.
strOutputCsv = 'C:\eeglab14_1_2b\vyom-git-eeglab-master\BrainLanguageRevision\test';

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

arrResults = zeros(nConditions, nSubjects, nElecs); % Matrix of outputs of shape [conditions x subjects]


% erspdata has shape [1 x channels x subjects]


nShift = 0;
% For each condition
for nCond = 1:nConditions 
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
    tableResults = array2table(squeeze(arrResults(nCond, :, :)),...
        'VariableNames', cElecs, 'RowNames', cHeader);
    
    % Append condition number to csv name
    strOutputFileName = strcat(strOutputCsv, '_cond',num2str(nCond), '.csv');
    writetable(tableResults,strOutputFileName, 'WriteRowNames',true);
end
fclose('all');