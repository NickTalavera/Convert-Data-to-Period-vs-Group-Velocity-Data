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
function [] = surfaceWaveTextMap(waves)
for i=1:length(waves)
    %     EVENTID
    textInfo{i,1}={''};
    %     AUTHOR
    textInfo{i,2}={'aaron'};
    %     DATE
    textInfo(i,3)={waves(i).eventDate};
    %     TIME
    textInfo(i,4)={waves(i).eventTime};
    %     LAT
    textInfo(i,5)={num2str(waves(i).eventLocLat)};
    %     LON
    textInfo(i,6)={num2str(waves(i).eventLocLon)};
    %     DEPTH
    textInfo{i,7}={''};
    %     DEPFIX
    textInfo{i,8}={''};
    %     AUTHOR
    textInfo{i,9}={''};
    %     TYPE
    textInfo{i,10}={''};
    %     MAG
    textInfo{i,11}={''};
    %     STATION
    textInfo{i,12}={waves(i).stationName};
end
tableFAT=cell2table(textInfo, 'VariableNames',{'EVENTID', 'AUTHOR','DATE','TIME','EVENTLAT','EVENTLON','DEPTH','DEPFIX','mThing','TYPE','MAG','STATION'});
fileID = fopen('exp.txt','w');
% fprintf(fileID,'DATA_TYPE EVENT_CATALOGUE\nISC Bulletin');
% fprintf(fileID,'\n--EVENT--|--------------------ORIGIN (PRIME HYPOCENTRE)-------------------|------MAGNITUDES-----...');
% fprintf(fileID,'\nEVENTID,AUTHOR   ,DATE      ,TIME       ,LAT     ,LON      ,DEPTH,DEPFIX,AUTHOR   ,TYPE  ,MAG \n');
fprintf(fileID,'DATE      ,TIME       ,LAT     ,LON      ,STATION\n');
for i=1:length(tableFAT.DATE)
%     fprintf(fileID,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',tableFAT.EVENTID{i},tableFAT.AUTHOR{i},tableFAT.DATE{i},tableFAT.TIME{i},tableFAT.LAT{i},tableFAT.LON{i},tableFAT.DEPTH{i},tableFAT.DEPFIX{i},tableFAT.mThing{i},tableFAT.TYPE{i},tableFAT.MAG{i});
    fprintf(fileID,'%s,%s,%s,%s,%s\n',tableFAT.DATE{i},tableFAT.TIME{i},tableFAT.LAT{i},tableFAT.LON{i},tableFAT.STATION{i});
end
fclose(fileID);
end