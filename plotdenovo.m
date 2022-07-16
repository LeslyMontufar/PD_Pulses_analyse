clc 
clear variables
close all

SNR = 'GERAL';
if isnumeric(SNR)
    fname = ['SNR' num2str(SNR) '.mat'];
else
    fname = [num2str(SNR) '.mat'];
end
load(fname)
Z.ResFinal(:,2) = num2cell(cellfun('length',Z.ResFinal(:,13)));
Z.ResFinal(:,13) = [];
t = cell2table(Z.ResFinal);
variables=4:13;
N = length(variables);
X = unique(t.(1));
LX = length(X);
best = cell(LX,N+1);
names = {'Combined Information','modoExt','mThresR','mThresC','estRuidoR','estRuidoC','thresR','thresC','n','2J'};


for i = 1:LX
    x = X(i);
    p = t(t.(1) == x,:);
    best{i,1} = x;
    fh = figure();
    fh.WindowState = 'maximized';
    u = ceil(sqrt(N));
    n = floor(N/u)+1;
    for k = 1:N
        colData = p.(variables(k));
        [GC,GR] = groupcounts(colData);
        subplot(u,n,k)
        bar(GC,'BarWidth', 0.2);
        set(gca,'xtick',[1:length(GR)],'xticklabel',GR)
        title(names{k})
        if max(GC)/sum(GC) > 0.5 
            [~,m] = max(GC);
            best{i,k+1} = GR(m);
        end
    end
    if isnumeric(SNR)
        suptitle(['Parâmetros dos filtros para o pulso ' num2str(i) ' e SNR = ' num2str(SNR) ' dB'])
    else
        suptitle(['Parâmetros dos filtros para o pulso ' num2str(i)])
    end
    nome = ['hist\Pulso_' num2str(i) '_SNR' num2str(SNR)];
    print(nome,"-dpng");
end
    
function [GC,GR] = groupcounts(colData)
    [xx0,GR] = findgroups(colData);  % GROUP
    [GC,~] = histc(xx0,unique(xx0)); % GROUP_COUNTS
    
%     [GC,I] = sort(GC,'descend');
%     GR = GR(I);
end 