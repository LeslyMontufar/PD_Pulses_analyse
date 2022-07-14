% function ncc = findNCC(filtro,best,pulso)   
clc; clear variables; close all;
load('bests_simp.mat');
load('base_dados_para_NCC');

% filtro = 8;
% pulso = 2;
pulso = 1;
for filtro = 1:size(bests,1)
ix = 1;
yinit = 1;
for coluna = 3:12
   iy = 1;
   value = bests{filtro,coluna};
   if isnumeric(value); value=num2str(value); end
%    fprintf('%d -%s: ',((pulso-1)*240+yinit),value);
   for linha = yinit:240*pulso
       if tab{linha,coluna}==bests{filtro,coluna}
           ids(iy,ix) = linha;
           iy=iy+1;
       end
       if tab{linha,coluna}~=value
           value = tab{linha,coluna};
           if isnumeric(value); value=num2str(value); end
%            fprintf('%s,',value);
       end
   end
%    fprintf('\n%d-%d',iy,ix);
   yinit = ids(1,ix);
   ix = ix + 1;
%    fprintf('\n');
end
ncc(filtro,1) = tab{ids(1,end),2};
if ~mod(filtro,7); pulso = pulso + 1; end
idss{filtro}=ids;
end