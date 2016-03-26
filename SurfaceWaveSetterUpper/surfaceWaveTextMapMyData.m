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
function [] = surfaceWaveTextMapMyData(waves,fname)
for i=1:length(waves)
    %     date
    textInfo(i,1)={waves(i).eventDate};
    %     eventTime
    textInfo(i,2)={waves(i).eventTime};
    %     eventLat
    textInfo(i,3)={num2str(waves(i).eventLocLat)};
    %     eventLon
    textInfo(i,4)={num2str(waves(i).eventLocLon)};
    %     stationLat
    textInfo(i,5)={num2str(waves(i).stationLocLat)};
    %     stationLon
    textInfo(i,6)={num2str(waves(i).stationLocLon)};
    %     station
    textInfo{i,7}={waves(i).stationName};
end
tableFAT=cell2table(textInfo, 'VariableNames',{'date','eventTime','eventLat','eventLon','stationLat','stationLon','station'});
fileID = fopen(fname,'w');
fprintf(fileID,'%s %s %s %s %s %s %s \n',tableFAT.Properties.VariableNames{:});
for i=1:length(tableFAT.date)
    fprintf(fileID,'%s,%s,%3.4f,%3.4f,%3.4f,%3.4f,%s\n',tableFAT.date{i},tableFAT.eventTime{i},str2num(tableFAT.eventLat{i}),str2num(tableFAT.eventLon{i}),str2num(tableFAT.stationLat{i}),str2num(tableFAT.stationLon{i}),tableFAT.station{i});
end
fclose(fileID);
end