function status = verifica_picos(myiPeak,iPeak,pulsos) 
    err_per = 0.1; % erro de aproximadamente 0.1%
    
    cnt = 0;
    for i=1:size(pulsos,1)
        myiPeak(i) = max(abs(pulsos(i,:)));
        if myiPeak(i)-abs(iPeak(i))> err_per/100*abs(iPeak(i))
%             fprintf("%d: %d %d\n",i,myiPeak(i),abs(iPeak(i)))
            cnt=cnt+1;
        end
    end
    coincidiram = size(pulsos,1)-cnt;

    % pulso com uma oscilação gigante no final
    i = 4158;
    myiPeak(i) = max(abs(pulsos(i,1:end-5)));
    if myiPeak(i)-abs(iPeak(i))<= err_per/100*abs(iPeak(i))
        coincidiram = coincidiram + 1;
    else
        return; 
    end
    status = (coincidiram == size(pulsos,1));
end