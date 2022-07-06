clc; clearvars -except allSNR; close all;
pasta = '..\data\SNRs';
filename = 'dados_snr.xlsx';
SAVE = 0;
GERAL = 0;

if ~exist('allSNR','var')
    files = dir(strcat('.\',pasta,'\*.mat'));
%     allSNR = cell(6000,15);
    if GERAL
        geral = cell(1000,13);
        cnt2 = 1;
    end
    cnt = 1;
    ii = 1;
    sizes = cell(25,1);
    SNR = cell(25,1);
    nro = cell(25,1);
    for file = files(1:1)'
        load(strcat('.\',pasta,'\',file.name));
        disp(file.name);
        for i=1:size(ResFinal,1)
            sizes{i,1} = size(ResFinal{i,2},1);
            if (file.name(6)=='_' || file.name(6)=='.')
                SNR{i,1} = str2num(file.name(5));
                if file.name(6)=='.'; nro{i,1} = 0;
                else; nro{i,1} = str2num(file.name(7));end
            else
                SNR{i,1} = str2num(file.name(5:6));
                if file.name(7)=='.'; nro{i,1} = 0;
                else; nro{i,1} = str2num(file.name(8));end
            end
        end
        C = ResFinal(:,4:11);
        aux = horzcat(C{:});
        B = convertStringsToChars(reshape([aux], [size(C)]));
        
        d = [ResFinal(:,1) sizes ResFinal(:,3) B ResFinal(:,12) ResFinal(:,14) SNR nro]; 
        if cnt == 1
            allSNR = d;
        else allSNR = [allSNR; d]; end
        %         for i=1:250
%             for j=1:13
%                 allSNR{iii,j} = d{i,j};
%                 if GERAL;geral{ii,j} = d{i,j};end
%             end
%             ii = ii + 1;
%             iii = iii + 1;
%         end
        
        if (~mod(cnt,4) & GERAL)
            if SAVE & GERAL; xlswrite(filename, geral, file.name);end
            ii = 1;
            cnt2 = cnt2 + 1;
        end
        cnt = cnt + 1;
    end
end
% Pulso=1; tam=2; MelhorNCC=3; CombinedInfo=4; modoExtensao=5; mThresR=6; mThresC=7; estRuidoR=8; estRuidoC=9; thresR=10; thresC=11; n=12; o2J=13;

% porNCC = sortrows(geral,[MelhorNCC,Pulso]);
% porPulso = sortrows(geral,[Pulso]); % são 40 linhas por pulso
% 
% stembyPulse(MelhorNCC,n,geral); suptitle('NCC vs n');
% stembyPulse(o2J,n,geral); suptitle('2*J vs n');
% stembyPulse(tam,o2J,geral); suptitle('tam vs 2*J');
% 
% if ~exist('pulsos','var')
%     load('data/resultado3.mat');
% end
% 
% d = plot_pulsos(pulsos);

%% ----- Funções ----- %%

function stembyPulse(X,Y,d)
    d = sortrows(d,[1]);    
    figure;
    for i = 1:25
       subplot(5,5,i);
       stem(cell2mat(d(40*(i-1)+1:40*i,X)),cell2mat(d(40*(i-1)+1:40*i,Y)));       
    end
end

function d = plot_pulsos(pulsos)
    figure;
    d = zeros(1,25);
    for i=1:25
        subplot(5,5,i); plot(pulsos{i,1}); 
        d(i) = max(abs(diff(pulsos{i,1}./rms(pulsos{i,1}))));
        title(d)
        xlim([0 8000]);
    end
end
