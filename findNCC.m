% function ncc = findNCC(filtro,best,pulso)   
clc; clear variables;
load('bests_simp.mat');
filtro = 8;
pulso = 2;

load('base_dados_para_NCC');
tab = sortrows(tab,[1]);

% pulso = 1;
% for filtro = 1:10%size(bests,1)
    ids = ones(1,10);
    ix = 1;
    yinit = 1;
    for coluna = 3:12
       iy = 1;
       
       value = bests{filtro,coluna};
       if isnumeric(value); value=num2str(value); end
       fprintf('%d -%s: ',yinit,value);
       for linha = (((pulso-1)*240+yinit):240*pulso)
           if tab{linha,coluna}==bests{filtro,coluna}
               ids(iy,ix) = linha;
               iy=iy+1;
           end
           value = tab{linha,coluna};
           if isnumeric(value); value=num2str(value); end
           fprintf('%s,',value);
       end
       fprintf('%d-%d',iy,ix);
       yinit = ids(1,1);
%         yinit = 1;
       ix = ix + 1;
       fprintf('\n');
    end
    ncc{filtro} = ids(1,10);
    if ~mod(filtro,7); pulso = pulso + 1; end
    idss{filtro}=ids;
% end
% end