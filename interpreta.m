clc 
clear variables
close all

% SNR = 'GERAL';
cnt = 1;
for SNR = [-2,-4,-7,-10,-13]
if isnumeric(SNR)
    fname = ['SNR' num2str(SNR) '.mat'];
else
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
linha = 1;
coluna = 1;
for i = 1:LX
    coluna = 1;
    x = X(i);
    p = t(t.(1) == x,:);
    best{linha,coluna} = x;
    best{linha+1,coluna} = ' ';
    if PLOT
    fh = figure();
    fh.WindowState = 'maximized';
    u = ceil(sqrt(N));
    n = floor(N/u)+1;
    end
    
    coluna = 2;
    best{linha,coluna} = Z.ResFinal{(i-1)*10+1,2};
    best{linha+1,coluna} = ' ';
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
            best{linha+1,coluna} = floor(vm/sum(GC)*100);
        %end
        coluna = coluna + 1;
    end
    best{linha,coluna} = Z.ResFinal{(i-1)*10+1,3};
    best{linha+1,coluna} = ' ';
    coluna = coluna + 1;
    n_max = ceil(log2(Z.ResFinal{(i-1)*10+1,2}));
    n_ = Z.ResFinal{(i-1)*10+1,12};
    best{linha,coluna} = n_max-n_;
    best{linha+1,coluna} = floor((n_max-n_)/n_max*100);
    coluna = coluna + 1;
    best{linha,coluna} = ' ';
    best{linha+1,coluna} = mean(cell2mat(best(linha+1,3:coluna-3)));
    
    if PLOT
    if isnumeric(SNR)
        suptitle(['Parâmetros dos filtros para o pulso ' num2str(i) ' e SNR = ' num2str(SNR) ' dB'])
    else
        suptitle(['Parâmetros dos filtros para o pulso ' num2str(i)])
    end
%     print(strcat("hist\Pulso_",num2str(i)),"-dpng");
    end
    linha = linha + 2;
end
bests{cnt} = best;
cnt = cnt + 1;
end
   
function plotPulsos
    figure;
    for i=1:25
        subplot(5,5,i);
        plot(Z.ResFinal{(i-1)*10+1,2});
    end
end

