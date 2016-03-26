%indice = indice of currenttly evaluated time out of times
function [ meanValue ] = calculateMeanWaveAtTime( waves, time, index)
    waveSum=0; %sum of all surface waves at this indice of time
    count=0; %count for each occurence in that point of time for the average
    for j=1:length(waves) %for each trimmed wave
        if length(waves(j).surfaceWave)>=index && waves(j).time(index) ~= time
            error('Fix the program to compare times') %maybe I shouldn't be lazy but the other way is harder
        end
        if length(waves(j).surfaceWave)>=index && waves(j).surfaceWave(index)>0 %if the wave has more data points than the current index and the surface wave value at that time not 0
            count=count+1; %increment the count
            waveSum=waveSum+waves(j).surfaceWave(index); %add the surface wave value to that spot in time
        end
    end
    meanValue=waveSum/count; %have average at time i
end

