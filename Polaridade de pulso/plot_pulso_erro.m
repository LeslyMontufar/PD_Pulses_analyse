function plot_pulso_erro(i,pulsos,iPeak)
    fh = figure;
    fh.WindowState = 'maximized';
    plot(pulsos(i,:));
    hold on;
    line ([1000 0], [iPeak(i,1) iPeak(i,1)], "linestyle", "-", "color", "g"); 
    line ([1000 0], [-iPeak(i,1) -iPeak(i,1)], "linestyle", "-", "color", "r"); 
    title([min(pulsos(i,:)) max(pulsos(i,:))]);
end