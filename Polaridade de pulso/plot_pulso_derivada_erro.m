function plot_pulso_derivada_erro(i,pulsos,myiPeak,iPeak,kk,pp,sub)
    myiPeak_ = abs(myiPeak(i));
    
    pulso = pulsos(i,:);
    pulso = resample(pulso,100,1);
    n = 1:size(pulso,2);
    
    % Média móvel
    k = kk/100*size(pulso,2);
    pulso_mm = conv(pulso,ones(1,k)/k,'same');
    derivada = diff(pulso_mm);
    derivada = [0 derivada];
    condicao = ((abs(derivada)<=1/100*max(abs(derivada))) & (abs(pulso_mm)>=pp/100*max(abs(pulso_mm)))); 
    s = pulso_mm(condicao);
    n = n(condicao);
    myiPeak_ = s(1)/abs(s(1)) * myiPeak_;
    
    % Gráfico
    if sub ~= 0
        fh = figure;
        fh.WindowState = 'maximized';
    end
    plot(pulso);
    hold on;
    plot(pulso_mm);
    line ([size(pulso,2) 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
    scatter(n,s,'r','filled');
    
    yyaxis right
    plot(derivada);
    
    v_err = abs((myiPeak_-iPeak(i,1))/iPeak(i,1)*100);
    title([myiPeak_,iPeak(i,1), v_err]);
    xlim([0 size(pulso,2)]);
    if sub ~= "~"
        legend("original","mm","derivada");
    end
end