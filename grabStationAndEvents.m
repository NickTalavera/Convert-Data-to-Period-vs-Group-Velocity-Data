%% For a set of surface wave ASCii files process the data to filter out bad data and
%% remove the first twenty seconds as well as any data that does not fit within
%% a certain standard deviation of the mean
%%
%% Created by Nick Talavera on October 26, 2015, modified from swmod by Anibal Sosa
%%
%% To run, type:
%% SW_Data_QC_NT(maximumStandardDeviation)
%%
%% For example:
%% SW_Data_QC_NT(0.5)
%% SW_Data_QC_NT(1,'/Users/nicktalavera/Dropbox/Research/Dispersion Data/Dispersion_Auto_ascii')
%%
%% maximumStandardDeviation=an integer maximum standard deviation allowed versus the mean
%%
function [] = grabStationAndEvents(maximumStandardDeviation,folder)
clear -maximumStandardDeviation %kill all previous data but the input
clc %clear the console
clf %close all the figures
if nargin>1 %if there is a folder input go to it
    cd(folder) %move to the specified folder
end
files = dir('*.ga'); %this is the list of the ASCII surface wave data files
count_bad = 0; %this is to count bad files\
q=0; %the counter to create a structured array of fixed surface wave data
for j = 1:length(files)
    fid = fopen(files(j).name,'rt');
    files(j).name
%     datacell = textscan(fid, '# Station %s %s %s');
    datacell = textscan(fid, '%s',3,'Delimiter','\n');
    stationInfo=textscan(datacell{1}{2}, '#%sInfo: %s %f %f');
    [stationInfo{3} stationInfo{4}]
    eventInfo=textscan(datacell{1}{3}, '#%sInfo: %f %f');
    [eventInfo{2} eventInfo{3}]
    fclose(fid); %close the file so matlab wont crash
end
% stationInfo{1}
% eventInfo{1}
% stationInfo{1}(5:6)'
% eventInfo{1}(4:5)'
% num2str(datacell{1}{2})
% num2str(datacell{2}{2})
% num2str(datacell{1}{3})
% num2str(datacell{2}{3})
end