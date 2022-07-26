function ncc = findNCC(filtro,best,tab,pulso)   
    if ~pulso; yend = size(tab,1); else; yend = 240*pulso; end
    ix = 1;
    yinit = 1;
    for coluna = 1:10
       iy = 1;
       for linha = yinit:yend
           if tab{linha,coluna+2}==best{filtro,coluna}
               ids(iy,ix) = linha;
               iy=iy+1;
           end
       end
       yinit = ids(1,ix);
       ix = ix + 1;
    end
    ncc = tab{ids(1,end),2};
end