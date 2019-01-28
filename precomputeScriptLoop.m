%{
===================================basicPrecompute Script===================================
Summary of function:
This script loads datasets and precomputes multiple studies

Written by Vyom
10/29/2018
%}
path = 'C:\Users\vmr160030\Desktop\VTC Study Data v2\';
studyName = {'FirstWordCat', 'FirstWordTheme', 'SecondWordCat', 'SecondWordTheme', 'ThirdWordCat', 'ThirdWordTheme'};
epochFileName = 'noBS.set';
whichWay = {2,2,1,1,2,2};
group1 = { {[51 71] [61 81]}, {[11 31] [21 41]},{[52 72] [62 82]},{[12 32] [22 42]},{[531 532 73] [631 634 83]},{[131 132 331 332] [23 43]} };
group2 = { {[51 61] [71 81]}, {[11 21] [31 41]},{[52 62] [72 82]},{[12 22] [32 42]},{[531 532 631 634] [73 83]},{[131 132 23] [331 332 43]} };


% path = 'C:\Users\vmr160030\Desktop\VTC Study Data v2\';
% studyName = 'SecondWordTheme';
% group1 = {[12 32] [22 42] };
% epochFileName = 'noBS.set';


for c = 1:numel(studyName)
    precomputeFunction( path, studyName{1, c}, group1{1,c}, epochFileName, group2{1,c}, whichWay{1,c} );
end
