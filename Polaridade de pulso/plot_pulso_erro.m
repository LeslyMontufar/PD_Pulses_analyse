function plot_pulso_erro(i,pulsos,iPeak,sub)
    if sub ~= 0
        fh = figure;
        fh.WindowState = 'maximized';
    end
    plot(pulsos(i,:));
    hold on;
    line ([1000 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
    line ([1000 0], [-iPeak(i,1) -iPeak(i,1)], "linestyle", "-", "color", "r"); 
    title([min(pulsos(i,:)) max(pulsos(i,:))]);
end