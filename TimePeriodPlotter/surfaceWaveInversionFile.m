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
function [] = surfaceWavePeriodTimeAbdulFormat(folder,importName,dataFname,contourFname)
close all %close all the figures
cd(folder)
load(importName)
clear -waves -mapExtremes
for i=1:length(waves)
    %     idNumber
    textInfo(i,1)={num2str(i)};
    %     stationLat
    textInfo(i,2)={num2str(waves(i).stationLocLat)};
    %     stationLon
    textInfo(i,3)={num2str(waves(i).stationLocLon+180)};
    %     eventLat
    textInfo(i,4)={num2str(waves(i).eventLocLat)};
    %     eventLon
    textInfo(i,5)={num2str(waves(i).eventLocLon+180)};
    %     vel_obs -> observed velocity, (km/s)
    textInfo{i,6}={num2str(waves(i).velocity)};
    %     weight -> weight of observed data, must be non zero
    textInfo{i,7}={num2str(1)};
    %     orbit -> =1 - orbit 1, =2 - orbit 2, not equal 1 or 2 - orbit 1
    textInfo{i,8}={num2str(1)};
        %     orbit -> =1 - orbit 1, =2 - orbit 2, not equal 1 or 2 - orbit 1
    textInfo{i,9}={waves(i).stationName};
end
format long
tableFAT=cell2table(textInfo, 'VariableNames',{'idNumber','stationLat','stationLon','eventLat','eventLon','vel_obs','weight','orb','stationName'});
fileID = fopen(dataFname,'w');
for i=1:length(tableFAT.idNumber)
    if i>1
        fprintf(fileID,'\n');
    end
    fprintf(fileID,'% 4d   % 7.3f   % 7.3f   % 7.3f   % 9.3f   % 7.3f %.1f   %d  %s',str2num(tableFAT.idNumber{i}),str2num(tableFAT.stationLat{i}),str2num(tableFAT.stationLon{i}),str2num(tableFAT.eventLat{i}),str2num(tableFAT.eventLon{i}),str2num(tableFAT.vel_obs{i}),str2num(tableFAT.weight{i}),str2num(tableFAT.orb{i}),tableFAT.stationName{i});
end
fclose(fileID);
fileID = fopen(contourFname,'w');
fprintf(fileID,'%0.3f %0.3f\n',mean([mapExtremes.maxLat mapExtremes.minLat]),mean([mapExtremes.maxLon mapExtremes.minLon])+180);
fprintf(fileID,'4\n');
fprintf(fileID,'%0.3f %0.3f\n',mapExtremes.maxLat, mapExtremes.minLon+180);
fprintf(fileID,'%0.3f %0.3f\n',mapExtremes.maxLat, mapExtremes.maxLon+180);
fprintf(fileID,'%0.3f %0.3f\n',mapExtremes.minLat, mapExtremes.maxLon+180);
fprintf(fileID,'%0.3f %0.3f\n',mapExtremes.minLat, mapExtremes.minLon+180);
fprintf(fileID,'4\n1 2\n2 3\n3 4\n4 1');
fclose(fileID);
end