function s_pulso = processa_pulso(pulso,peak)
    n = 1:numel(pulso);
    n_end = n(end);
    Ts = 1;
    pulso_fft = fftshift(fftn(pulso)/n_end);
    freqs = ((-n_end/2:1:n_end/2-1)/(n_end*Ts)); % o n*Ts divide o 1 tambem
    
    figure;
    plot(freqs(ceil(n_end/2)+1:end),abs(pulso_fft(ceil(n_end/2)+1:end)),'linewidth',1.5,'color',[0 0 0]);
    
    pulso2_fft = pulso_fft .* (freqs<0.5e-1);
    pulso2 = ifft(pulso2_fft(ceil(n_end/2)+1:end),n_end)*n_end;
%     s_pulso = smooth(pulso);
    s_pulso = real(pulso2);
end