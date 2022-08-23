clc;close all; clearvars;
load('dadosLesly.mat');

myiPeak = ones(length(iPeak),1);
iPolaridade = iPeak./abs(iPeak);

% ---- Determinando se a primeira oscilação é um mínimo ou máximo local ----

err_eq = 0.0045; % 20%
min_max_pulsos = 0.02256; % 5*err_eq

% Gerando resultado final
r = 30;
kk = .8;
pp = 15;
k = floor(kk/100*size(pulsos,2)*r);
derivada = zeros(1,size(pulsos,2)*r);
n = 1:size(pulsos,2)*r;

for i=1:size(pulsos,1)
    pulso = pulsos(i,:);
    pulso = resample(pulso,r,1);
    
    % Média móvel
    pulso_mm = conv(pulso,ones(1,k)/k,'same');
    derivada(2:end) = diff(pulso_mm);

    condicao = ((abs(derivada)<=1/100*max(abs(derivada))) & (abs(pulso_mm)>=pp/100*max(abs(pulso_mm)))); 
    s = pulso_mm(condicao);
    myiPeak(i) = s(1)/abs(s(1)) * myiPeak(i);
    if iPeak(i)/abs(iPeak(i)) ~= myiPeak(i)/abs(myiPeak(i))
        ss(end+1) = s(1);
    end
end
v_erros = (myiPeak(:)~=iPolaridade)*100;
v = [myiPeak(:),iPolaridade(:), v_erros];
n = 1:size(iPolaridade,1);
condicao = (v_erros==100);
i_erros = n(condicao);
naocoincidem = [i_erros',myiPeak(condicao),iPolaridade(condicao),v_erros(condicao),ss'];

% [v,naocoincidem,i_erros] = log_v(myiPeak,iPeak,ss);

% Para testar
% close all;
fh = figure;
fh.WindowState = 'maximized';
for sub=1:9
    i=i_erros(sub);
    subplot(3,3,sub);
    plot_pulso_derivada_erro(i,pulsos,myiPeak,iPeak,r,kk,pp,1,1);
end 

figure;
plot(iPeak(i_erros));

% Com alta amplitude

i_erros_alto = i_erros([41,64,72]);
fh = figure;
fh.WindowState = 'maximized';
for sub=1:3
    i=i_erros_alto(sub);
    subplot(3,1,sub);
    plot_pulso_derivada_erro(i,pulsos,myiPeak,iPeak,r,kk,pp,1,1);
end 


fprintf("\nNão coincidem: %d\n\n",numel(i_erros));