clc;
clearvars %-except bests best_pulso;
close all;
names = {'Combined Information','modoExt','mThresR','mThresC','estRuidoR','estRuidoC','thresR','thresC','n','2J'};

% if ~exist('bests','var')
    load('base_dados_para_NCC'); % var: tab
    variables=4:13;
    N = length(variables);
    PLOT = 0;
    COMP = 1; %completo
    cnt = 1;
    bests = [];
    if COMP; cadaSNR = []; end
    if ~COMP; resumo_por = []; end

    poss = cell(25,N);
    best_pulso  = cell(25,N+1);

    for SNR = [22,0,-2,-4,-7,-10,-13]
        if isnumeric(SNR) && SNR~=22
            fname = ['SNR' num2str(SNR) '.mat'];
        else
            fname = 'GERAL.mat';
        end
        load(fname) % var: Z
        Z.ResFinal(:,2) = num2cell(cellfun('length',Z.ResFinal(:,2)));
        Z.ResFinal(:,13) = [];
        t = cell2table(Z.ResFinal);
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

            coluna = 2;
            best{linha,coluna} = Z.ResFinal{(i-1)*10+1,2}; % tamanho do pulso
            if COMP
                best{linha+1,coluna} = ' ';
            end
            coluna = coluna + 1;

            for k = 1:N
                colData = p.(variables(k));
                [GC,GR]=groupcounts(colData); % GROUP_COUNTS, GROUP
                best{linha,coluna} = GR(1);

                GC_por = floor(GC/sum(GC)*100); % GC_percentual
                por{k} = GC_por(1); % max GC_portagem

                % Acumulando as possibilidades por pulso e parâmetro
                % Definindo limiar para considerar elegível
                sup_mean = GC_por(GC_por>=mean(GC_por));
                l_sup_mean = length(sup_mean);
                if l_sup_mean == 1
                    limiar = mean(GC);
                elseif l_sup_mean == 2
                    if sup_mean(1)>=65
                        limiar = 65;
                    else
                        limiar = sup_mean(1);
                    end
                else
                    limiar = 100/l_sup_mean;
                    if limiar < mean(GC)
                        limiar = mean(GC);
                    elseif sup_mean(1) < limiar
                        limiar = sup_mean(1)*0.95;
                    end
                end
                poss_label = GR(GC>=limiar);
                poss_counts = GC(GC>=limiar);
                poss{i,k}(end+1:end+length(poss_label)) = poss_label;
    %             poss{i,k} = {poss_label, poss_freq};

                if COMP
                    if sum(GC>=mean(GC))==1
                        if por{k}>70
                            labels = "";
                        else
                            labels = [por{k}; mean(GC_por)];
                        end    
                    elseif sum(GC>=mean(GC))==2 && GC_por(1)>70
                        labels = "";
                    else
                        labels = [GR(GC>=mean(GC)); GC_por(GC>=mean(GC)); mean(GC_por)];
                    end

                    if isnumeric(labels(1)); labels = string(labels); end
                    best{linha+1,coluna} = join(labels,', ');
                end

                coluna = coluna + 1;
            end

            best{linha,coluna} = findNCC(linha,best(:,3:12),tab,i);
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
    
    % Determina melhor filtro por pulso
    for i = 1:25
        for k = 1:10
            [GC,GR] = groupcounts(poss{i,k});
            best_pulso{i,k} = GR(1);
        end
        best_pulso{i,k+1} = findNCC(i,best_pulso,tab,i);
    end
% end
% hist_parametros(best_pulso,names);

function [GC,GR] = groupcounts(colData)
    [xx0,GR] = findgroups(colData);  % GROUP
    [GC,~] = histc(xx0,unique(xx0)); % GROUP_COUNTS
    
    [GC,I] = sort(GC,'descend');
    GR = GR(I);
end
