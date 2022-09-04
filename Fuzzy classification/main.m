clc; clearvars; close all; 
load('..\dadosLesly.mat');
plot_info_pulso = 1;
i = 1;

fh = figure(2);
n_pulsos = size(pulsos,1);

pulso_original = pulsos(i,:);
f_norm = sqrt(sum(pulso_original.^2)); % fator de normalizacao
pulso = pulso_original/f_norm;
peak = iPeak(i)/f_norm;
ti = 1:numel(pulso);
Ts = ti(2)-ti(1);
t_end = ti(end);
t0 = sum(ti.*(pulso.^2)) / sum(pulso.^2);
T2 = sum((ti-t0).^2 .* pulso.^2) / sum(pulso.^2);

pulso_fft = fftshift(fftn(pulso)/t_end);
freqs = ((-t_end/2:t_end/2-1)/(t_end*Ts)); % divide o passo tbm
W2 = sum(freqs.^2 .* abs(pulso_fft).^2) / sum(abs(pulso_fft).^2);

T = sqrt(T2);
W = sqrt(W2);
scatter(W2,T2,10,'b','filled');
if i==1; hold on; end

ylabel("T2");
xlabel("W2");

err_eq = 0.0045;
trigger = (err_eq*1.001)/f_norm;
start = find(pulso>trigger,1);
stop = find(pulso>trigger,1,"last");
t_start = sum(ti(start:floor(t0)).*(pulso(start:floor(t0)).^2))/ sum(pulso(start:floor(t0)).^2);
t_stop = sum(ti(ceil(t0):stop).*(pulso(ceil(t0):stop).^2))/ sum(pulso(ceil(t0):stop).^2);

if plot_info_pulso
fh = figure(1);
fh.WindowState = 'maximized';
subplot(121);
plot(pulso);
line_h(peak,"g")
line_v(t0,"m",[min(pulso) max(pulso)]);
line_v(t_start,"m",[min(pulso) max(pulso)]);
line_v(t_stop,"m",[min(pulso) max(pulso)]);
line_v(start,"g",[min(pulso) max(pulso)]);
line_v(stop,"g",[min(pulso) max(pulso)]);
ylabel("Corrente");
xlabel("Tempo/Amostras");

subplot(122);
plot(freqs(ceil(t_end/2)+1:end),abs(pulso_fft(ceil(t_end/2)+1:end)),'linewidth',1.5,'color',[0 0 0]);
line_v(W,"m",[min(abs(pulso_fft)) max(abs(pulso_fft))]);
ylabel("Magnitude");
xlabel("Freqs (Hz)");
suptitle("\fontsize{16}Dados do pulso");

fprintf("t_start: %d\n",t_start);
fprintf("t0: %d\n",t);
fprintf("t_stop: %d\n",t_stop);

fprintf("T: %d\n",T);
fprintf("W: %d\n",W);
fprintf("Energia do pulso original: %d\n", sum(pulso_original.^2));
end

function line_h(peak,color)
line ([1000 0], [peak peak], "linestyle", "-", "color", color); 
end
function line_v(t0,color,extremos)
line ([t0 t0], extremos, "linestyle", "-", "color", color); 
end