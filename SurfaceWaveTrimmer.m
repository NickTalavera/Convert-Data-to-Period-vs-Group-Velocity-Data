%% Remove the first 20 seconds of data from a structured array of surface wave
%% data. Then it will calculate a mean up to a point in time and then remove
%% data past the point where the data at that time is greater than the
%% standard deviation, then calculate a new mean with the shortened data when
%% it repeats the process.
%%
%% Created by Nick Talavera on October 26, 2015
%%
%% To run, type:
%% [wavesTrimmed, meanSurfaceWave] = SurfaceWaveTrimmer(waves,maximumStandardDeviation)
%%
%% For example:
%% [filteredWaves, meanSurfaceWave] = SurfaceWaveTrimmer(waves,maximumStandardDeviation);
%%
%% waves=structured array of waves with the file name (.name), time (.time)
%% and surface wave data (.surfaceWave) corresponding to that time
%% maximumStandardDeviation=an integer maximum standard deviation allowed
%% versus the mean
%%
function [wavesTrimmed, times] = SurfaceWaveTrimmer(waves, minimumTimeLength)
times=[];%set up for the list of possible times
for i=1:length(waves) %for every wave in the structured array wave input
    wavesTrimmed(i) = waves(i); %put the name in its spot of the wave structured array
    wavesTrimmed(i).time = waves(i).time(waves(i).time>=20);%put the time in its spot of the wave structured array but only keep after 20 seconds
    wavesTrimmed(i).surfaceWave =  waves(i).surfaceWave(waves(i).time>=20); %put the name in its spot of the wave structured array but only keep after 20 seconds
    times = [times setdiff(wavesTrimmed(i).time, times)']; %add any missing time to the list of possible times
end
times=sort(times);%sort the times numerically
end