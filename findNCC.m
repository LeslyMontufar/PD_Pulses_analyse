% function ncc,ids = findNCC(filtro,best)
    clear ids    
    filtro = 3;
    
    load('GERAL.mat', 'Z')
    tab = [Z.ResFinal(:,1) Z.ResFinal(:,3:end-2) Z.ResFinal(:,end)];
    tab = sortrows(tab,[1]);
    
    ids = ones(1,10);
    ix = 1;
    yinit = 1;
    for coluna = 3:12
        fprintf('coluna %d ix %d',coluna,ix)
       iy = 1;
       for linha = yinit:240
           if tab{linha,coluna}==best{filtro,coluna}
               ids(iy,ix) = linha;
               iy=iy+1;
           end
           1 240
           241 480
       end
       disp(iy);
       yinit = ids(1,ix);
       ix = ix + 1;
       
       
    end
    ncc = ids(1,10)
% end