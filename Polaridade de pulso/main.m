clc;close all; clearvars;
load('dadosLesly.mat');
PLOT = 0;

if PLOT
x = 4;
fh = figure;
fh.WindowState = 'maximized';
for i=25*(x-1)+1:25*x%size(pulsos,1)
    subplot(5,5,i-25*(x-1));
    plot(pulsos(i,:));
    hold on;
    line ([1000 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
    line ([1000 0], [-iPeak(i,1) -iPeak(i,1)], "linestyle", "-", "color", "r"); 
    title([min(pulsos(i,:)) max(pulsos(i,:))]);
end
end

myiPeak = zeros(length(iPeak),1);
cnt = 0;
for i=1:size(pulsos,1)
    myiPeak(i) = max(abs(min(pulsos(i,:))),abs(max(pulsos(i,:))));
    if myiPeak(i)>abs(iPeak(i))*1.001 || myiPeak(i)<abs(iPeak(i))*0.999
        fprintf("%d: %d %d\n",i,myiPeak(i),abs(iPeak(i)))
        cnt=cnt+1;
    end
end
coincidiram = size(pulsos,1)-cnt;
% erro de aproximadamente 0.1%

% pulso com uma oscilação gigante no final
erro = 4158;
i = erro;

if PLOT
fh = figure;
fh.WindowState = 'maximized';
plot(pulsos(i,:));
hold on;
line ([1000 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
line ([1000 0], [-iPeak(i,1) -iPeak(i,1)], "linestyle", "-", "color", "r"); 
title([min(pulsos(i,:)) max(pulsos(i,:))]);
end

myiPeak(i) = max(abs(min(pulsos(i,1:end-5))),abs(max(pulsos(i,1:end-5))));
if myiPeak(i)<=abs(iPeak(i))*1.001 && myiPeak(i)>=abs(iPeak(i))*0.999
    coincidiram = coincidiram + 1;
    fprintf("%d: %d %d",i,myiPeak(i),abs(iPeak(i)))
    fprintf(" -> sucesso\n");
end

% ---- Determinando se a primeira oscilação é um mínimo ou máximo local ----

if PLOT
x = 1;
row = 1;
fh = figure;
fh.WindowState = 'maximized';
for i=row^2*(x-1)+1:row^2*x%size(pulsos,1)
    if row>1; subplot(row,row,i-row^2*(x-1)); end
    pulso = pulsos(i,:);
    pulso = resample(pulso,100,1);
    plot(pulso);
    n = 1:size(pulso,2);
    hold on;
    line ([size(pulso,2) 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
    line ([size(pulso,2) 0], [-iPeak(i,1) -iPeak(i,1)], "linestyle", "-", "color", "r"); 
    
    %derivada
    k = 5;
    derivada = diff(pulsos(i,:));
    derivada = conv(derivada,ones(1,k)/k,'same');
    derivada = [derivada 0];
    derivada = resample(derivada,100,1);
    plot(derivada);
    
    condicao = (abs(derivada)<=1e-3) & (abs(pulso)>=1/100*max(abs(pulso))) ;
    equal0 = pulso(condicao);
    n = n(condicao);

    scatter(n,equal0,'r','filled');
    
    title([min(pulsos(i,:)) max(pulsos(i,:))]);
    xlim([0 2e4]);
end
end

r = 100;
% k = 3; % 291 naocoincidem
% k = 5; % 79 naocoincidem
% k = 8; % 76 naocoincidem
k = 10;
for i=1:size(pulsos,1)
    pulso = pulsos(i,:);
    pulso = resample(pulso,r,1);
    n = 1:size(pulso,2);
    derivada = diff(pulsos(i,:));
    derivada = resample(derivada,r,1);
    
    derivada = conv(derivada,ones(1,k)/k,'same');
    derivada(end+1:end+(size(pulso,2)-size(derivada,2))) = 0;
    
    s = pulso((abs(derivada)<=1e-3) & (abs(pulso)>=1/100*max(abs(pulso))));
    s = s(1);
    myiPeak(i) = s/abs(s) * myiPeak(i);
end

naocoincidem = sum(abs(myiPeak-iPeak)>=50/100);
v_erros = abs((myiPeak(:)-iPeak(:))./iPeak(:)*100);
v = [myiPeak(:),iPeak(:), v_erros.*(v_erros>100)];
