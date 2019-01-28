
%{
===================================ImageToVideo Script===================================
Summary of function:
This script converts an image sequence into an AVI video file with
specified frameRate

Written by Vyom
8/24/2018
edited 1/7/2019
%}

%Path for folder containing image sequence
%Make sure this ends with a backslash
workingDir = 'C:\Users\vmr160030\Desktop\ImageToVideo\';

%desired frame rate, i.e., how many images to show per second
frameRate = 1;



imageNames = dir(fullfile(workingDir,'*.jpeg'));
imageNames = {imageNames.name}';
myVideo = VideoWriter(strcat(workingDir,'\output.avi'));
myVideo.FrameRate = frameRate;
open(myVideo)

for i=1:length(imageNames)
    img = imread(fullfile(workingDir,imageNames{i}));
    writeVideo(myVideo, img);
end
close(myVideo)