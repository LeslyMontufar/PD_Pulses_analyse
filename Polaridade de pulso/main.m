clc; clearvars; close all; 
load('dadosErros.mat');

myiPeak = ones(length(iPeak),1);
iPolaridade = iPeak./abs(iPeak);
PLOT = 1;

err_eq = 0.0045; % 20%
min_max_pulsos = 0.02256; % 5*err_eq

% plot_pulsos_iPeak(1,pulsos,iPeak);
for i=1:1%size(pulsos,1)
    pulso = pulsos(i,:);
    peak = iPeak(i);
    
    s_pulso = processa_pulso(pulso, peak);
%     offset_pos = sum(s_pulso(s_pulso>0))/1000;
%     offset_neg = sum(abs(s_pulso(s_pulso<=0)))/1000;
%     offset = offset_pos - offset_neg;
    
%     s_pulso = s_pulso + offset;
    
    trigger = 20/100*max(s_pulso);
    
    if PLOT
        figure;
        plot(pulso); hold on;
        plot(s_pulso);
        line ([size(pulso,2) 0], [peak peak], "linestyle", "-", "color", "g"); 
        line ([size(pulso,2) 0], [trigger trigger], "linestyle", "-", "color", "m"); 
        line ([size(pulso,2) 0], [-trigger -trigger], "linestyle", "-", "color", "m");
        title(i);
        xlim([0 size(pulso,2)]);
        legend("Pulso","Pulso processado");
    end
end

% Gerando resultado final
% r = 30;
% kk = .8;
% pp = 15;
% k = floor(kk/100*size(pulsos,2)*r);
% n = 1:size(pulsos,2)*r;
% 
% for i=1:size(pulsos,1)
%     processa_pulso(i,pulsos,myiPeak,iPeak,r,k,pp);
% end
% v_erros = (myiPeak(:)~=iPolaridade)*100;
% v = [myiPeak(:),iPolaridade(:), v_erros];
% n = 1:size(iPolaridade,1);
% condicao = (v_erros==100);
% i_erros = n(condicao);
% naocoincidem = [i_erros',myiPeak(condicao),iPolaridade(condicao),v_erros(condicao),ss'];


fprintf("\nNão coincidem: %d de %d\n\n",numel(i_erros),size(pulsos,1));