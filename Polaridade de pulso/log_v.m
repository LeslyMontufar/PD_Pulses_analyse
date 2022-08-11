function [v,naocoincidem,i_erros] = log_v(myiPeak,iPeak,ss)
    v_erros = (myiPeak(:)~=(iPeak(:)./abs(iPeak(:)))*100;
    v = [myiPeak(:),iPeak(:), v_erros];
    n = 1:size(iPeak,1);
    i_erros = n(v_erros>10);
    naocoincidem = [i_erros',myiPeak(v_erros>10),iPeak(v_erros>10),v_erros(v_erros>10),ss'];
end