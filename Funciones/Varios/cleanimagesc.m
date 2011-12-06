function cleanimagesc(I)

idx = [find(isnan(I)); find(isinf(I))];
while(length(idx)>0)
    newidx = idx + 1;
    newidx(newidx>length(I(:))) = newidx(1);
    I(idx) = I(newidx);
    idx = [find(isnan(I)); find(isinf(I))];
end

flag = 1;
cotam = 0.999;
cotaM = 0.995;

while flag

    [h x] = hist(I(:),100);
    h = h / sum(h);
    suma = 0;
    i = 1;
    while suma < cotaM
        suma = suma + h(i);
        i = i + 1;
    end
    j = 100;
    suma = 0;
    while suma < cotam
        suma = suma + h(j);
        j = j - 1;
    end

    flag = 0;
    if j > 0
        I(I<x(j)) = x(j);
        flag = 1;
    end
    if i < 100
        I(I>x(i)) = x(i);
        flag = 1;
    end

end

imagesc(I)