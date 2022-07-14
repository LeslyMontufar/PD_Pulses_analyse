function ncc = findNCC(filtro,best,tab,pulso)   
    ix = 1;
    yinit = 1;
    for coluna = 3:12
       iy = 1;
       for linha = yinit:240*pulso
           if tab{linha,coluna}==best{filtro,coluna}
               ids(iy,ix) = linha;
               iy=iy+1;
           end
       end
       yinit = ids(1,ix);
       ix = ix + 1;
    end
    ncc = tab{ids(1,end),2};
end