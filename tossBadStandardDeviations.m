function [ wavesAfterBadStandardDeviationsTossed, meanSurfaceWave, count_bad ] = tossBadStandardDeviations(waves, times, badDataFolder, maximumStandardDeviation, minimumTimeLength )
arrayOfElementsToRemove=zeros(1,length(waves'));
for i=1:length(times) %for each point in time for the trimmed surface wave
    [meanSurfaceWave.surfaceWave(i)] = calculateMeanWaveAtTime(waves, times(i), i);
    for j=1:length(waves) %for each trimmed wave
        if arrayOfElementsToRemove(j)==0
            if max(waves(j).time) < minimumTimeLength
                arrayOfElementsToRemove(j)=1;
                [meanSurfaceWave.surfaceWave(i)] = calculateMeanWaveAtTime(waves(arrayOfElementsToRemove==0), times(i), i);
            else
                if length(waves(j).time)>= i %if the trimmed surface wave is longer in length than the current point in time
                    if (waves(j).time(i) ~=  times(i))
                        waves(j).time(i)
                        times(i)
                        'OH NO FIX THIS'
                    end
                    standardDeviationTest=abs(std([waves(j).surfaceWave(i) meanSurfaceWave.surfaceWave(i)])); %calculate the standard deviation
                    if standardDeviationTest>(maximumStandardDeviation) %if the standard deviation is greater, then remove data points past and including that value
                        waves(j).time=waves(j).time(1:i-1);%only keep the time data up to the bad point
                        waves(j).surfaceWave=waves(j).surfaceWave(1:i-1);%only keep the surface wave data up to the bad point
                        if max(waves(j).time) < minimumTimeLength
                            arrayOfElementsToRemove(j)=1;
                            [meanSurfaceWave.surfaceWave(i)] = calculateMeanWaveAtTime(waves(arrayOfElementsToRemove==0), times(i), i);
                        end
                    end
                end
            end
        end
    end
end
for i=1:length(arrayOfElementsToRemove)
    if arrayOfElementsToRemove(i)==1
        movefile(waves(i).name,badDataFolder) %put the bad files in the badDataFolder
    end
end
count_bad = sum(arrayOfElementsToRemove);
wavesAfterBadStandardDeviationsTossed=waves(arrayOfElementsToRemove==0);
meanSurfaceWave.time=times;
end