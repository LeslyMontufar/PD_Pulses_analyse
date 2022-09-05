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

etot = 97;
te = segmenta_e(etot,pulso,ti);



fh = figure(1);
fh.Position(1:2) = [1000 300];
% fh.WindowState = 'maximized';
plot(pulso);
line_v(te(1,1),"m",pulso); % tstart
line_v(te(1,2),"c",pulso); % t0
line_v(te(1,3),"m",pulso); % tstop

title(te(2,:));
ylabel("Corrente");
xlabel("Tempo/Amostras");

fprintf("\n")

fprintf("tstart: %d\n",te(1,1));
fprintf("t0: %d\n",te(1,2));
fprintf("tstop: %d\n",te(1,3));

fprintf("\n")

fprintf("Energia do pulso original: %d\n", energia(pulso_original,1,t_end));
fprintf("Energia do pulso: %d\n", energia(pulso,1,t_end));
fprintf("Divisão da energia: %.4g e %.4g\n",energia_div(pulso,ti,t0));
fprintf("e: %d\n",te(2,3));

function te = segmenta_e(etot,y,x)
    t0 = centroide(x,y,0.5);
    t0_c = ceil(t0);
    tstart = t0_c;
    tstop = t0_c;
    
    e = 0;
    e1 = 0;
    e2 = 0;
    e1_init = energia(y,1,t0_c);
    e2_init = energia(y,t0_c,x(end));
    etot_init = e1_init + e2_init;
    fprintf("%g + %g = %g\n\n",e1_init,e2_init,etot_init)
    while (e1/etot_init < e1_init*etot/100)
        tstart = floor(centroide(x(1:tstart),y(1:tstart),0.5));
        if (e2/etot_init < e2_init*etot/100)
            tstop = ceil(centroide(x(tstop:end),y(tstop:end),0.5));
        end
        e1 = energia(y,tstart,t0_c);
        e2 = energia(y,t0_c,tstop);
        e = e1+e2;
        fprintf(":: %g %g\t\t e: %.4g + %.4g = %.4g >= %.4g + %.4g\n",tstart,tstop,e1/etot_init,e2/etot_init,e,e1_init*etot/100,e2_init*etot/100);
    end
    te = [tstart, t0, tstop;e1,e2,e];
end
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