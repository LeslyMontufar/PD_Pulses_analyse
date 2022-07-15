data = best_pulso;
names = {'Combined Information','modoExt','mThresR','mThresC','estRuidoR','estRuidoC','thresR','thresC','n','2J'};


N = 10;
fh = figure();
% fh.WindowState = 'maximized';
u = ceil(sqrt(N));
n = floor(N/u)+1;
t = cell2table(data);
for k=1:N
    colData = t.(k);
    [GC,GR] = groupcounts(colData);
    subplot(u,n,k)
    bar(GC,'BarWidth', 0.2);
    set(gca,'xtick',[1:length(GR)],'xticklabel',GR)
    title(names{k})
end