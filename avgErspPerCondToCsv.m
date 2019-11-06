% Script to obtain average ersp power across specified times, freqs, channels. 
% Output is of shape [conditions x subjects]
%
% Author : Vyom Raval
% Email: vmr160030@utdallas.edu
% Date created: 09/12/2019
% Last modified: 11/06/2019
% Tested on: eeglab14.0.0b, eeglab14.1.1b
% Tested using: K:\Dept\CallierResearch\Maguire\RA Folders\Manju\Working Memory\14yrs All 091919.study 

% TODO: Make this a function that takes inputs

%%%%%%%%%%%%%%%%%%%%%%%% USER INPUT ZONE BEGINS %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable prefixes indicate data type
strOutputCsv = 'K:\Dept\CallierResearch\Maguire\RA Folders\Vyom\ManjuTest_norepeats.csv'; % Path to file you want to save
arrTimeRange = [0 4000];
arrFreqRange = [9 12];
cElecs = {'FP1', 'FPZ', 'AF3', 'F7', 'F5', 'F3', 'F1', 'FZ',...
          'F2', 'F4', 'FT7', 'FCZ', 'FC2', 'CZ', 'C2', ' Tp8',...
          'P2', 'P4', 'P6', 'P8', 'CB1','PO7', 'PO5', 'POZ', 'PO4',...
          'PO6', 'PO8', 'CB2', 'O1', 'OZ', 'O2'}; % Ensure that this has no repeats
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
arrCondDataShape = size(erspdata{1, 1}); % Shape of each condition's data

% Number of subjects, obtained from number of elements in each condition's data's last dimension
nSubjects = arrCondDataShape(end); 

arrResults = zeros(nConditions, nSubjects); % Matrix of outputs of shape [conditions x subjects]


% erspdata has shape [freqs x times x channels x subjects], or [1 x channels x subjects]

% For each condition
for nCond = 1:nConditions 
    arrCondData = erspdata{nCond,1}; % Matrix of that condition's data    
    % For each subject
    for nSub = 1:nSubjects        
        % non subject dimensions
        strOtherDims = repmat({':'},1,ndims(arrCondData)-1);      
        
        % Reshape condition data for a subject to be [1 x freqs*times*channels]
        arrReshapedData = reshape(arrCondData(strOtherDims{:}, nSub), 1, []);
        
        % Take the mean over the second dimension, leaving 1 number for each subject
        arrResults(nCond, nSub) = mean(arrReshapedData, 2);
    end
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