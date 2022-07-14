clear variables
close all 

% load('resumo_por.mat');
% resumo_por = cell2mat(resumo_por);
% 
% figure();
% for pulso = 1:25
%     subplot(13,2,pulso);
%     SNR = [0,-2,-4,-7,-10,-13];
%     plot(SNR,resumo_por(pulso,2:end));
% end

load('bests_simp.mat');
SNR = [0,-2,-4,-7,-10,-13];

fh = figure();
fh.WindowState = 'maximized';
for pulso = 1:25
    n = cell2mat(bests((pulso-1)*7+2:pulso*7,11));
    J2 = cell2mat(bests((pulso-1)*7+2:pulso*7,12));
    subplot(5,5,pulso);
    yyaxis left
    plot(SNR,n);
    
    yyaxis right
    plot(SNR,J2);
    legend('n','2J');
end
suptitle('SNR vs Parâmetros por pulso');