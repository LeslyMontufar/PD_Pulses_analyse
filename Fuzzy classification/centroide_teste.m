clc; clearvars; close all
load('..\dadosLesly.mat');
err_eq = 0.0045;
i = 1;

n_pulsos = size(pulsos,1);

pulso_original = pulsos(i,:);
f_norm = sqrt(sum(pulso_original.^2)); 

% Normaliza
pulso = pulso_original/f_norm;
peak = iPeak(i)/f_norm;

ti = 1:numel(pulso);
Ts = ti(2)-ti(1);
t_end = ti(end);
t0 = centroide(ti,pulso,0.5);


p1 = 80;
figure(1);
plot(ti);
hold on;
new_t = (((ti-ti(t_end/2)).*(t_end*p1/100)).^3);
new_t = new_t/(max(new_t)-min(new_t))+0.5;
new_t = [(new_t(t_end/2+1:end)-.5).*t_end ti(t_end/2+1:t_end)];
% new_t = ti;
plot(new_t);




fh = figure(2);
fh.Position(1:2) = [1000 300];
plot(pulso);
line_v(t0,"c",pulso);


teste = centroide(new_t,pulso,0.5);
line_v(teste,"m",pulso);
fprintf("Divisão da energia: %.4g e %.4g\n",energia_div(pulso,ti,teste))

title(energia_div(pulso,ti,t0));
ylabel("Corrente");
xlabel("Tempo/Amostras");

fprintf("teste: %d\n",teste);
fprintf("t0: %d\n",t0);

fprintf("\n")

fprintf("Energia do pulso original: %d\n", energia(pulso_original,1,t_end));
fprintf("Divisão da energia: %.4g e %.4g\n",energia_div(pulso,ti,t0))


function e = energia_div(y,x,x0)
    x0 = x0/(x(2)-x(1));
    e1 = energia(y,1,x0);
    e2 = energia(y,x0,numel(x));
    etot = energia(y,1,numel(x));
    e = [e1 e2]/etot*100;
end

function e = energia(y,xinit,xend)
    try
        e = sum(abs(y(floor(xinit):ceil(xend))).^2);
    catch
        fprintf("index: %d %d\n\t\t %d %d\n",xinit,xend,floor(xinit),ceil(xend))
    end
end
function c = centroide(x,y,n)
    c = sum(x.^(2*n) .* abs(y).^2) / sum(abs(y).^2);
end

function line_h(yconst,color)
line ([1000 0], [yconst yconst], "linestyle", "-", "color", color); 
end
function line_v(xconst,color,y)
line ([xconst xconst], [min(y) max(y)], "linestyle", "-", "color", color); 
end