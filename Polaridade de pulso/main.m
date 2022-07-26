clc;close all; clearvars;
load('dadosLesly.mat');

% plot_pulsos_iPeak(1);

err_per = 0.1; % erro de aproximadamente 0.1%
myiPeak = zeros(length(iPeak),1);
cnt = 0;
for i=1:size(pulsos,1)
    myiPeak(i) = max(abs(pulsos(i,:)));
    if myiPeak(i)-abs(iPeak(i))> err_per/100*abs(iPeak(i))
        fprintf("%d: %d %d\n",i,myiPeak(i),abs(iPeak(i)))
        cnt=cnt+1;
    end
end
coincidiram = size(pulsos,1)-cnt;

% pulso com uma oscila��o gigante no final
i = 4158;
% plot_pulso_erro(4158,pulsos,iPeak);
myiPeak(i) = max(abs(pulsos(i,1:end-5)));
if myiPeak(i)-abs(iPeak(i))<= err_per/100*abs(iPeak(i))
    coincidiram = coincidiram + 1;
    fprintf("%d: %d %d",i,myiPeak(i),abs(iPeak(i)))
    fprintf(" -> sucesso\n");
end

% ---- Determinando se a primeira oscila��o � um m�nimo ou m�ximo local ----

if 0
x = 2;
row = 1;
fh = figure;
fh.WindowState = 'maximized';
for i=row^2*(x-1)+1:row^2*x%size(pulsos,1)
    if row>1; subplot(row,row,i-row^2*(x-1)); end
    pulso = pulsos(i,1:250);
    pulso = resample(pulso,100,1);
    n = 1:size(pulso,2);
    
    % M�dia m�vel
    k = 8/100*size(pulso,2);
    pulso_mm = conv(pulso,ones(1,k)/k,'same');
    derivada = diff(pulso_mm);
    derivada = [0 derivada];
    condicao = ((abs(derivada)<=1/100*max(abs(derivada))) & (abs(pulso_mm)>=20/100*max(abs(pulso_mm)))); 
    s = pulso_mm(condicao);
    n = n(condicao);
    myiPeak(i) = s(1)/abs(s(1)) * myiPeak(i);
    
    % Gr�fico
    plot(pulso);
    hold on;
    plot(pulso_mm);
    line ([size(pulso,2) 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
    scatter(n,s,'r','filled');
    
    yyaxis right
    plot(derivada);
    
    v_err = abs((myiPeak(i,1)-iPeak(i,1))/iPeak(i,1)*100);
    title([myiPeak(i,1),iPeak(i,1), v_err*(v_err>50)]);
    xlim([0 2e4]);
    legend("original","mm","derivada");
end
end

% Gerando resultado final

for i=1:size(pulsos,1)
    pulso = pulsos(i,1:250);
    pulso = resample(pulso,100,1);
    n = 1:size(pulso,2);
    
    % M�dia m�vel
    k = 8/100*size(pulso,2);
    pulso_mm = conv(pulso,ones(1,k)/k,'same');
    derivada = diff(pulso_mm);
    derivada = [0 derivada];
    condicao = ((abs(derivada)<=1/100*max(abs(derivada))) & (abs(pulso_mm)>=20/100*max(abs(pulso_mm)))); 
    s = pulso_mm(condicao);
    myiPeak(i) = s(1)/abs(s(1)) * myiPeak(i);
end
[v,naocoincidem] = log_v(myiPeak,iPeak);
