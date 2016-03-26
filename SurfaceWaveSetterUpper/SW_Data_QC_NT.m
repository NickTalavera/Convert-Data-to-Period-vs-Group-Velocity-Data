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
%% minimumSurfaceWaveTimeExtent= minimum time of surface wave data to keep included
function [] = SW_Data_QC_NT(maximumStandardDeviation,minimumSurfaceWaveTimeExtent,folder,exportName)
tic;
clear -maximumStandardDeviation -folder -minimumSurfaceWaveTimeExtent %kill all previous data but the input
close all %close all the figures
startingFolder=pwd;
mapExtremes.maxLat=-inf;
mapExtremes.maxLon=-inf;
mapExtremes.minLat=inf;
mapExtremes.minLon=inf;
waves = struct; %instantiate waves
count_bad = 0; %this is to count bad files
if nargin>2 %if there is a folder input go to it
    cd(folder) %move to the specified folder
end
[highestDirectoryPath, highestDirectoryName, ~] = fileparts(pwd); %get the current directory title
badDataFolder = [highestDirectoryName '_bad_data']; %generate a folder name with the title 'bad_data' appended to the current folder
if ~exist(badDataFolder, 'dir') %if the badDataFolder doesn't exist...
    mkdir(badDataFolder);%make the badDataFolder folder
end
badDataFolderWithPath=[highestDirectoryPath '/' badDataFolder];
files = rdir('**/*.ga');
q=0; %the counter to create a structured array of fixed surface wave data
for j = 1:length(files)
    fid = fopen(files(j).name,'r');
    stationEventScanner = textscan(fid, '%s',2,'Delimiter','\n', 'HeaderLines',1);
    stationInfo=textscan(stationEventScanner{1}{1}, '#%sInfo: %s %f %f %s');
    eventInfo=textscan(stationEventScanner{1}{2}, '#%sInfo: %f %f');
    dateInfo=textscan(fid, '# File name: Event_%s', 'HeaderLines',1);
    dateInfo=strsplit(dateInfo{1}{1}(1:19), '_');
    datacell = textscan(fid, '%f%f%f%f%f%f%f%f', 'HeaderLines',7);
    fclose(fid); %close the file so matlab wont crash
    V_s = datacell{3};
    
    if length(V_s)<=30
        count_bad = count_bad +1; %increase the count of bad data files
        movefile(files(j).name,badDataFolderWithPath) %put the bad files in the badDataFolder
        continue
    end
    t0 = datacell{1};
    mu = mean(V_s);
    l = length(t0);
    sigma = std(V_s);
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
    if  max(new_T) < minimumSurfaceWaveTimeExtent %tests for bad data
        count_bad = count_bad +1; %increase the count of bad data files
        movefile(files(j).name,badDataFolderWithPath) %put the bad files in the badDataFolder
        continue
    else
        q=q+1; %move to next spot in the surface wave structured array
        waves(q).stationLocLat=stationInfo{3};
        waves(q).stationLocLon=stationInfo{4};
        waves(q).stationName=stationInfo{2}{1};
        waves(q).eventLocLat=eventInfo{2};
        waves(q).eventLocLon=eventInfo{3};
        waves(q).velocity=mu;
        waves(q).eventDate=[dateInfo{1} '-' dateInfo{2} '-' dateInfo{3}];
        waves(q).eventTime=[dateInfo{4} ':' dateInfo{5} ':' dateInfo{6}];
        waves(q).name=files(j).name; %put the name in its spot of the wave structured array
        waves(q).time=new_T; %put the time in its spot of the wave structured array
        waves(q).surfaceWave=new_swv; %put the surfaceWave data in its spot of the wave structured array
    end
    mapExtremes.maxLat=max([-inf mapExtremes.maxLat waves(q).stationLocLat waves(q).eventLocLat]);
    mapExtremes.maxLon=max([-inf mapExtremes.maxLon waves(q).stationLocLon waves(q).eventLocLon]);
    mapExtremes.minLat=min([inf mapExtremes.maxLat waves(q).stationLocLat waves(q).eventLocLat]);
    mapExtremes.minLon=min([inf mapExtremes.maxLon waves(q).stationLocLon waves(q).eventLocLon]);
    clear -files -waves -badDataFolderWithPath -maximumStandardDeviation -mapExtremes
end
[waves, times]=SurfaceWaveTrimmer(waves, minimumSurfaceWaveTimeExtent); %run the trimmer function
[waves, meanSurfaceWave, count_bad_add ] = tossBadStandardDeviations(waves, times, badDataFolderWithPath, maximumStandardDeviation, minimumSurfaceWaveTimeExtent );
% sprintf([num2str(toc) ' seconds calculation time to toss bad std'])
[waves, count_bad_add2 ] = tossBadIncreases(waves, times, badDataFolderWithPath, maximumStandardDeviation, minimumSurfaceWaveTimeExtent );
[waves, meanSurfaceWave, count_bad_add3 ] = tossBadStandardDeviations(waves, times, badDataFolderWithPath, maximumStandardDeviation, minimumSurfaceWaveTimeExtent );
% sprintf([num2str(toc) ' seconds calculation time to toss bad increases'])
count_bad=count_bad+count_bad_add+count_bad_add3+count_bad_add2;
% sprintf([num2str(toc) ' seconds calculation time to trimmer completion'])
for i=1:length(waves) %for each filtered wave
    clear -filteredWaves -count_bad -meanSurfaceWave % clear everything we don't need
    figure(1) %choose figure 1
    hold on %keep between plot
    plot(waves(i).time,waves(i).surfaceWave,'k') %plot the filtered surface waves in black
%     plot(meanSurfaceWave.time,meanSurfaceWave.surfaceWave,'r') %plot the mean in red
    axis([0 inf -inf inf]) % set a nice axis
end
title('Surface Wave Dispersion Curves (After Filtering)')
xlabel('Period (s)')
ylabel('Amplitude')
fprintf('Bad data files moved: %d \n',count_bad) %print number of bad data files moved
surfaceWaveTextMapMyData(waves,'StationAndEventInfoNT.txt')
save(exportName,'waves','mapExtremes')
sprintf([num2str(toc) ' seconds calculation time to set up plot'])
end