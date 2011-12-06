function [C L] = mi_dwt(matriz,escalas,madre)
[LO_D,HI_D,LO_R,HI_R] = wfilters(madre);
C = [];
L = zeros(1,escalas+1);
for k = 1:escalas
    Acoef = filter2(LO_D,matriz,'full');
    Acoef = Acoef(:,2:2:end);
    Dcoef = filter2(HI_D,matriz,'full');
    Dcoef = Dcoef(:,2:2:end);
    matriz = Acoef;
    C = [Dcoef C];
    L(end-k+1) = size(Dcoef,2);
end
C = [Acoef C];
L(1) = size(Acoef,2);