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
function [] = periodRunAbdulFormat(folder,importName,matOutput,dataFname,contourFname)
close all %close all the figures
cd(folder)
load(importName)
clear -waves
[~, times]=SurfaceWaveTrimmer(waves, 0); %run the trimmer function
wavesSpeeder=1:length(waves);
for i=1:length(times) %for each filtered wave
    valueAtTimes(i).time=times(i);
    for j=wavesSpeeder(wavesSpeeder>=1)
        if max(ismember(waves(j).time,times(i)))==1
            valueAtTimes(i).waves(j)=waves(j);
            valueAtTimes(i).waves(j).surfaceWave=waves(j).surfaceWave(i);
            valueAtTimes(i).waves(j).time=times(i);
        else
            wavesSpeeder(j)=0;
        end
    end
end
clear -valueAtTimes
save(importName,'waves','valueAtTimes')
figureFolderName='periodFigures/';
textFolderName='periodMapTextData/';
overwrite=1;
if overwrite==1
    if exist(figureFolderName, 'dir') %if the badDataFolder doesn't exist...
        rmdir(figureFolderName(1:end-1),'s')
    end
    if exist(textFolderName, 'dir') %if the badDataFolder doesn't exist...
        rmdir(textFolderName(1:end-1),'s')
    end
end
if ~exist(figureFolderName, 'dir') %if the badDataFolder doesn't exist...
    mkdir(figureFolderName(1:end-1));%make the badDataFolder folder
end
if ~exist(textFolderName, 'dir') %if the badDataFolder doesn't exist...
    mkdir(textFolderName(1:end-1));%make the badDataFolder folder
end
pause
for i=1:length(valueAtTimes) %for each filtered wave
    titleString=[num2str(valueAtTimes(i).time) 's'];
    if overwrite==1 || (overwrite==0 && ~exist([figureFolderName titleString '.fig'], 'file'))
        figure(1)
        title(titleString)
        hold on %keep between plot
        for j=1:length(valueAtTimes(i).waves)
            if max(ismember(waves(j).time,times(i)))==1
                scatter(valueAtTimes(i).time,valueAtTimes(i).waves(j).surfaceWave,'k')
            end
        end
        axis([valueAtTimes(i).time-15 valueAtTimes(i).time+15 0 max([valueAtTimes(i).waves.surfaceWave])*1.05]) % set a nice axis
        savefig(1,[figureFolderName titleString '.fig'],'compact')
        clf 'reset'
        titleString=strrep(titleString,'.','_');
        surfaceWaveTimePeriodTextMapMyData(valueAtTimes(i).waves,[textFolderName titleString '_map_data.txt'])
    end
end
end