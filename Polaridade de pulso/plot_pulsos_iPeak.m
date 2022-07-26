function plot_pulsos_iPeak(x)
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