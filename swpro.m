%% For a set of SW  ASCii files process the data to filter out bad datae
%%
%% Created by Anibal Sosalast modified August 24
%%
%%
function [] = swpro()
clear
files = dir('*.ga');
rvals = linspace(0,1,length(files));
count_bad = 0;

for j = 1:length(files)
    fid = fopen(files(j).name,'rt');
    datacell = textscan(fid, '%f%f%f%f%f%f%f%f', 'HeaderLines',12);
    t0 = datacell{1};
    V_s = datacell{3};
    mu = mean(V_s);
    l = length(t0);
    sigma = std(V_s);
    fclose('all');
%     plot(t0,V_s,'-.','Color', [rvals(j),0.5,rvals(j)])
    hold on
    
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
    le = length(new_swv);
    if (length(new_swv) < 15)
        count_bad = count_bad +1;
        fprintf('Bad data: only %d data points in %s \n',le,files(j).name)
        continue
    end
    hold on
    plot(new_T,new_swv,'k')
end
fprintf('bad data files %d \n',count_bad)
end