function [ wavesTrimmed, meanSurfaceWave ] = SurfaceWaveTrimmer(waves)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
times=[];
for i=1:length(waves)
    wavesTrimmed(i).name = waves(i).name;
    wavesTrimmed(i).time = waves(i).time(find(waves(i).time>20));
    wavesTrimmed(i).surfaceWave =  waves(i).surfaceWave(find(waves(i).time>20));
    times = [times setdiff(wavesTrimmed(i).time,times)'];
end
meanSurfaceWave.time=sort(times);
timeOccurences=meanSurfaceWave.time.*0;
surfaceWaveTotalsAtEachTimeOccurences=meanSurfaceWave.time.*0;
for i=1:length(meanSurfaceWave.time)
    [locationInTimes,locationInWavesTrimmed] = ismember(meanSurfaceWave.time,wavesTrimmed(i).time);
    timeOccurences=timeOccurences+locationInTimes;
    for k=locationInWavesTrimmed(find(locationInWavesTrimmed>0))
        surfaceWaveTotalsAtEachTimeOccurences(k)=surfaceWaveTotalsAtEachTimeOccurences(k)+wavesTrimmed(i).surfaceWave(k);
    end
    meanSurfaceWave.surfaceWave = surfaceWaveTotalsAtEachTimeOccurences./timeOccurences;
end
end