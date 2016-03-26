function [ wavesBadStandardDeviationsTossed, count_bad ] = tossBadStandardDeviations(waves, times, badDataFolder, maximumStandardDeviation, minimumTimeLength )
arrayOfElementsToRemove=zeros(1,length(waves'));
for i=1:length(times) %for each point in time for the trimmed surface wave
    for j=1:length(waves) %for each trimmed wave
        if length(waves(j).surfaceWave)>=i %if the trimmed surface wave is longer in length than the current point in time
            if i>=2 && length(waves(j).surfaceWave)>=i
                y2=waves(j).surfaceWave(i);
                y1=waves(j).surfaceWave(i-1);
                x2=waves(j).time(i);
                x1=waves(j).time(i-1);
                angle=(tand((y2-y1)/(x2-x1)))*20000;
                if waves(j).time(i) <=50
                    angleCheck=50;
                    if angle <=-10 || abs(angle) > angleCheck
                        arrayOfElementsToRemove(j)=1;
                        waves(j).time=waves(j).time(1:i-1);%only keep the time data up to the bad point
                        waves(j).surfaceWave=waves(j).surfaceWave(1:i-1);%only keep the surface wave data up to the bad point
                    end
                else
                    angleCheck=15;
                    if abs(angle) > angleCheck
                        arrayOfElementsToRemove(j)=1;
                        waves(j).time=waves(j).time(1:i-1);%only keep the time data up to the bad point
                        waves(j).surfaceWave=waves(j).surfaceWave(1:i-1);%only keep the surface wave data up to the bad point
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
wavesBadStandardDeviationsTossed=waves(arrayOfElementsToRemove==0);
end

