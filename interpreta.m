clc 
clear variables %-except Z tab
close all
load('base_dados_para_NCC'); % var: tab

names = {'Combined Information','modoExt','mThresR','mThresC','estRuidoR','estRuidoC','thresR','thresC','n','2J'};

PLOT = 0;
COMP = 1; %completo
cnt = 1;
bests = [];
if COMP; cadaSNR = []; end
if ~COMP; resumo_por = []; end

for SNR = [22,0,-2,-4,-7,-10,-13]
    if isnumeric(SNR) && SNR~=22
        fname = ['SNR' num2str(SNR) '.mat'];
    else
        SNR = 'GERAL';
        fname = [SNR '.mat'];
    end
    load(fname) % var: Z
    Z.ResFinal(:,2) = num2cell(cellfun('length',Z.ResFinal(:,2)));
    Z.ResFinal(:,13) = [];
    t = cell2table(Z.ResFinal);
    variables=4:13;
    N = length(variables);
    X = unique(t.(1));
    LX = length(X);
    best = cell(LX,N+1);

    linha = 1;
    coluna = 1;

    for i = 1:LX
        coluna = 1;
        x = X(i);
        p = t(t.(1) == x,:);
        best{linha,coluna} = x;

        if COMP
            best{linha+1,coluna} = x;
        end

        if PLOT
            fh = figure();
            fh.WindowState = 'maximized';
            u = ceil(sqrt(N));
            n = floor(N/u)+1;
        end

        coluna = 2;
        best{linha,coluna} = Z.ResFinal{(i-1)*10+1,2};
        if COMP
            best{linha+1,coluna} = ' ';
        end
        coluna = coluna + 1;
        for k = 1:N
            colData = p.(variables(k));
            [xx0,GR] = findgroups(colData);
            [GC,~] = histc(xx0,unique(xx0));

            if PLOT
                subplot(u,n,k)
                bar(GC,'BarWidth', 0.2);
                set(gca,'xtick',[1:length(GR)],'xticklabel',GR)
                title(names{k})
            end
            
            [~,I] = sort(GC,'descend');
            GR = GR(I);
%             [vm,m] = max(GC);
            vm = GC(1);
            best{linha,coluna} = GR(1);

            por{k} = floor(vm/sum(GC)*100);
            
            porcentagens = sort(floor(GC/sum(GC)*100),'descend');
            best{linha+1,coluna} = [GR(GC>mean(GC)); porcentagens(GC>mean(GC))];
            coluna = coluna + 1;
        end

        best{linha,coluna} = findNCC(linha,best,tab,i);
        if COMP
            best{linha+1,coluna} = ' ';
        end

        coluna = coluna + 1;
        n_max = ceil(log2(Z.ResFinal{(i-1)*10+1,2}));
        n_ = Z.ResFinal{(i-1)*10+1,12};
        best{linha,coluna} = n_max-n_;
        if COMP
            best{linha+1,coluna} = floor((n_max-n_)/n_max*100); 
        end

        coluna = coluna + 1;
        if COMP
            best{linha,coluna} = ' ';
            best{linha+1,coluna} = (mean(cell2mat(por)) + best{linha,coluna-2}*100)/2;
        else
            best{linha,coluna} = (mean(cell2mat(por)) + best{linha,coluna-2}*100)/2;
        end

        if PLOT
            if isnumeric(SNR)
                suptitle(['Parâmetros dos filtros para o pulso ' num2str(i) ' e SNR = ' num2str(SNR) ' dB'])
            else
                suptitle(['Parâmetros dos filtros para o pulso ' num2str(i)])
            end
        end
        linha = linha + 1 + COMP;
    end
    
    if SNR == 22
        bests = best; 
    else
        bests = [bests; best]; 
    end

    if COMP
        cadaSNR{cnt} = best;
        cnt = cnt+1;
    else
        if SNR == 22
            resumo_por = best(:,15);
        else
            resumo_por = [resumo_por best(:,15)];
        end
    end
end
bests = sortrows(bests,[1]);


    


