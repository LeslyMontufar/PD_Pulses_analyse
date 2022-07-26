function [v,naocoincidem] = log_v(myiPeak,iPeak)
    naocoincidem = sum(abs(myiPeak-iPeak)>=50/100);
    v_erros = abs((myiPeak(:)-iPeak(:))./iPeak(:)*100);
    v = [myiPeak(:),iPeak(:), v_erros.*(v_erros>100)];
end