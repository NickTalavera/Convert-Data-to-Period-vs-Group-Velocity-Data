function [ wavesTrimmed, meanSurfaceWave ] = SurfaceWaveTrimmer(waves)
times=[];
for i=1:length(waves)
    wavesTrimmed(i).name = waves(i).name;
    wavesTrimmed(i).time = waves(i).time(find(waves(i).time>20));
    wavesTrimmed(i).surfaceWave =  waves(i).surfaceWave(find(waves(i).time>20));
    times = [times setdiff(wavesTrimmed(i).time,times)'];
end
meanSurfaceWave.time=sort(times);
waveTotal=zeros(length(meanSurfaceWave.time));
for i=1:length(meanSurfaceWave.time)
    count=0;
    for j=1:length(wavesTrimmed)
        if length(wavesTrimmed(j).surfaceWave)>=i && wavesTrimmed(j).surfaceWave(i)>0
            count=count+1;
            waveTotal(i)=waveTotal(i)+wavesTrimmed(j).surfaceWave(i);
        end
    end
    meanSurfaceWave.surfaceWave(i)=waveTotal(i)/count; %have average at time i
    
    
    for k=1:length(meanSurfaceWave.surfaceWave)
        for j=1:length(wavesTrimmed)
            if length(wavesTrimmed(j).surfaceWave)>k
                a=std([meanSurfaceWave.surfaceWave(k) wavesTrimmed(j).surfaceWave(k)]);
                if a>1
                    wavesTrimmed(j).surfaceWave=wavesTrimmed(j).surfaceWave(1:k-1)
                    wavesTrimmed(j).time=wavesTrimmed(j).time(1:k-1)
%                     pause
                end
            end
            %             if length(wavesTrimmed(j).surfaceWave)>=i && wavesTrimmed(j).surfaceWave(i)>0
            %                 count=count+1;
            %                 waveTotal(i)=waveTotal(i)+wavesTrimmed(j).surfaceWave(i);
            %             end
        end
    end
    
    
end

end