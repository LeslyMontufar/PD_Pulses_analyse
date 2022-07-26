data = best_pulso;
names = {'Combined Information','modoExt','mThresR','mThresC','estRuidoR','estRuidoC','thresR','thresC','n','2J'};

N = 10;
fh = figure();
fh.WindowState = 'maximized';
u = ceil(sqrt(N));
n = floor(N/u)+1;
t = cell2table(data);

for k=1:N
    colData = t.(k+2);
    [GC,GR] = groupcounts(colData);
    subplot(u,n,k)
    bar(GC,'BarWidth', 0.2);
    set(gca,'xtick',[1:length(GR)],'xticklabel',GR)
    title(names{k})
end

print('melhor_filtro_pulso','-dpng')

function [GC,GR] = groupcounts(colData)
    [xx0,GR] = findgroups(colData);  % GROUP
    [GC,~] = histc(xx0,unique(xx0)); % GROUP_COUNTS
    
    [GC,I] = sort(GC,'descend');
    GR = GR(I);
end

% verificar se essa lógica pode ser usada para o n e 2J, considerando a
% SNR, tem o n_max que pode ser usado
