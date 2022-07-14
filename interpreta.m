clc 
clear variables -except Z
close all

bests = [];
for SNR = [22,0,-2,-4,-7,-10,-13]
if isnumeric(SNR) & SNR~=22
    fname = ['SNR' num2str(SNR) '.mat'];
else
    SNR = 'GERAL';
    fname = [SNR '.mat'];
end
load(fname)
Z.ResFinal(:,2) = num2cell(cellfun('length',Z.ResFinal(:,2)));
Z.ResFinal(:,13) = [];
t = cell2table(Z.ResFinal);
variables=4:13;
N = length(variables);
X = unique(t.(1));
LX = length(X);
best = cell(LX,N+1);
names = {'Combined Information','modoExt','mThresR','mThresC','estRuidoR','estRuidoC','thresR','thresC','n','2J'};

PLOT = 0;
COMP = 0; %completo
linha = 1;
coluna = 1;
for i = 1:LX
    coluna = 1;
    x = X(i);
    p = t(t.(1) == x,:);
    best{linha,coluna} = x;
    if COMP;best{linha+1,coluna} = x;end
    if PLOT
    fh = figure();
    fh.WindowState = 'maximized';
    u = ceil(sqrt(N));
    n = floor(N/u)+1;
    end
    
    coluna = 2;
    best{linha,coluna} = Z.ResFinal{(i-1)*10+1,2};
    if COMP; best{linha+1,coluna} = ' ';end
    coluna = coluna + 1;
    for k = 1:N
        colData = p.(variables(k));
%         [GC,GR] = groupcounts(colData);
        [xx0,GR] = findgroups(colData);
        [GC,~] = histc(xx0,unique(xx0));%/max(GC)*100;
        
        if PLOT
        subplot(u,n,k)
        bar(GC,'BarWidth', 0.2);
        set(gca,'xtick',[1:length(GR)],'xticklabel',GR)
        title(names{k})
        end
        
        %if max(GC)/sum(GC) > 0.5 
            [vm,m] = max(GC);
            best{linha,coluna} = GR(m);
            por{k} = floor(vm/sum(GC)*100);
            if COMP; best{linha+1,coluna} = floor(vm/sum(GC)*100); end
        %end
        coluna = coluna + 1;
    end
    best{linha,coluna} = Z.ResFinal{(i-1)*10+1,3};
%     best{linha,coluna} = findNCC(linha,best,i);
    if COMP; best{linha+1,coluna} = ' '; end
    coluna = coluna + 1;
    n_max = ceil(log2(Z.ResFinal{(i-1)*10+1,2}));
    n_ = Z.ResFinal{(i-1)*10+1,12};
    best{linha,coluna} = n_max-n_;
    if COMP; best{linha+1,coluna} = floor((n_max-n_)/n_max*100); end
    coluna = coluna + 1;
    if COMP
    best{linha,coluna} = ' ';
    best{linha+1,coluna} = mean([mean(cell2mat(best(linha+1,3:coluna-3))),best{linha,coluna-2}*100]);
    else
        best{linha,coluna} = mean([mean(cell2mat(por)),best{linha,coluna-2}*100]);
    end
    if PLOT
    if isnumeric(SNR)
        suptitle(['Parâmetros dos filtros para o pulso ' num2str(i) ' e SNR = ' num2str(SNR) ' dB'])
    else
        suptitle(['Parâmetros dos filtros para o pulso ' num2str(i)])
    end
%     print(strcat("hist\Pulso_",num2str(i)),"-dpng");
    end
    linha = linha + 1 + COMP;
end
if SNR == 22; bests = best; else bests = [bests; best]; end

end
bests = sortrows(bests,[1]);

function plotPulsos
    figure;
    for i=1:25
        subplot(5,5,i);
        plot(Z.ResFinal{(i-1)*10+1,2});
    end
end


    


