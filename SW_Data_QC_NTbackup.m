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
function [] = SW_Data_QC_NT(maximumStandardDeviation,folder)
clear -maximumStandardDeviation %kill all previous data but the input
clc %clear the console
clf %close all the figures
if nargin>1 %if there is a folder input go to it
    cd(folder) %move to the specified folder
end
files = dir('*.ga'); %this is the list of the ASCII surface wave data files
count_bad = 0; %this is to count bad files
[~, deepestFolder, ~] = fileparts(pwd); %get the current directory title
badDataFolder = [deepestFolder '_bad_data']; %generate a folder name with the title 'bad_data' appended to the current folder
waves = struct; %instantiate waves
minimumTimeLength=40; %minimum time of surface wave data to keep included
if ~exist(badDataFolder, 'dir') %if the badDataFolder doesn't exist...
    mkdir(badDataFolder);%make the badDataFolder folder
end
q=0; %the counter to create a structured array of fixed surface wave data
for j = 1:length(files)
    fid = fopen(files(j).name,'rt');
    stationEventScanner = textscan(fid, '%s',5,'Delimiter','\n');
    stationInfo=textscan(stationEventScanner{1}{2}, '#%sInfo: %s %f %f');
    eventInfo=textscan(stationEventScanner{1}{3}, '#%sInfo: %f %f');
    dateInfo=textscan(stationEventScanner{1}{5}, '# File name: Event_%s');
    dateInfo=strsplit(dateInfo{1}{1}(1:19), '_')
    datacell = textscan(fid, '%f%f%f%f%f%f%f%f', 'HeaderLines',12);
    t0 = datacell{1};
    V_s = datacell{3};
    mu = mean(V_s);
    l = length(t0);
    sigma = std(V_s);
    index = [];
    index(1) = 1;
    for i = 1:30
        d = abs(V_s(i)-V_s(i+1));
        if ((V_s(i) <= mu ) && (d <= sigma) )
            index(1) = i;
        end
    end
    index(2) = l;
    for i = 31:l-1
        d2 = V_s(i)-V_s(i+1);
        d = abs(d2);
        if d >= sigma
            index(2)  = i;
            break;
        end
    end
    
    new_swv = V_s(index(1):index(2));
    new_T = t0(index(1):index(2));
    [max_nv,I] = max(new_swv);
    
    r = max_nv - .5 * sigma;
    
    for k = I:length(new_swv)-1
        if (new_swv(k) < r)
            index(3) = k - 1;
            new_swv = new_swv(1:index(3));
            new_T = new_T(1:index(3));
            break;
        end
    end
    if (length(new_swv) < 15) || max(new_T) < minimumTimeLength %tests for bad data
        count_bad = count_bad +1; %increase the count of bad data files
        movefile(files(j).name,badDataFolder) %put the bad files in the badDataFolder
    else
        q=q+1; %move to next spot in the surface wave structured array
        waves(q).stationLocLat=stationInfo{3};
        waves(q).stationLocLon=stationInfo{4};
        waves(q).eventLocLat=eventInfo{2};
        waves(q).eventLocLon=eventInfo{3};
%         waves(q).arrivalDate=[dateInfo{1} '-' dateInfo{2} '-' dateInfo{3}]
%         waves(q).arrivalTime=[dateInfo{4} ':' dateInfo{5} ':' dateInfo{6}];
        waves(q).name=files(j).name; %put the name in its spot of the wave structured array
        waves(q).time=new_T; %put the time in its spot of the wave structured array
        waves(q).surfaceWave=new_swv; %put the surfaceWave data in its spot of the wave structured array
    end
    fclose(fid); %close the file so matlab wont crash
end
[filteredWaves, times]=SurfaceWaveTrimmer(waves,maximumStandardDeviation, minimumTimeLength); %run the trimmer function
[filteredWaves, meanSurfaceWave, count_bad_add ] = tossBadStandardDeviations(filteredWaves, times, badDataFolder, maximumStandardDeviation, minimumTimeLength );
[filteredWaves, count_bad_add2 ] = tossBadIncreases(filteredWaves, times, badDataFolder, maximumStandardDeviation, minimumTimeLength );
[filteredWaves, meanSurfaceWave, count_bad_add3 ] = tossBadStandardDeviations(filteredWaves, times, badDataFolder, maximumStandardDeviation, minimumTimeLength );
count_bad=count_bad+count_bad_add+count_bad_add2+count_bad_add3;
for i=1:length(filteredWaves) %for each filtered wave
    clear -filteredWaves -count_bad -meanSurfaceWave % clear everything we don't need
    figure(1) %choose figure 1
    hold on %keep between plot
    plot(filteredWaves(i).time,filteredWaves(i).surfaceWave,'k') %plot the filterd surface waves in black
    plot(meanSurfaceWave.time,meanSurfaceWave.surfaceWave,'r') %plot the mean in red
    axis([0 inf -inf inf]) % set a nice axis
end
filteredWaves(1)
fprintf('Bad data files moved: %d \n',count_bad) %print number of bad data files moved
surfaceWaveTextMap(filteredWaves)
end