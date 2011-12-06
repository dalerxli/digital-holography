function I = sacarNaNInf(I)

idx = [find(isnan(I)); find(isinf(I))];
while(length(idx)>0)
    newidx = idx + 1;
    newidx(newidx>length(I(:))) = newidx(1);
    I(idx) = I(newidx);
    idx = [find(isnan(I)); find(isinf(I))];
end