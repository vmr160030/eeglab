% Script to obtain average ersp power across specified times, freqs, channels. 
% Output is of shape [conditions x subjects]
%
% Author : Vyom Raval
% Email: vmr160030@utdallas.edu
% Date created: 09/12/2019

% TODO: Make this a function that takes inputs

% Variable prefixes indicate data type
strOutputCsv = 'K:\Dept\CallierResearch\Maguire\RA Folders\Vyom\Test.csv'; % Path to file you want to save
arrTimeRange = [3000 4000];
arrFreqRange = [9 12];
cElecs = {'FPZ', 'FP4', 'AF4', 'F3', 'F1', 'FZ', 'F2',...
    'F4', 'F6', 'FC2', 'FC4', 'FC6', 'FT8', 'C2', 'C4', 'C6', 'CP2', 'CP4', 'CP6', 'TP8'};

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