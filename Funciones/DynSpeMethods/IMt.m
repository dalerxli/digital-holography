function IMts = IMt(THSP,V,dimt)
% Funci�n que encuentra la evoluci�n del momento de inercia en un conjunto
% de THSPs.
% IMts = Imt(THSP,V)
% THSP: cubo con THSPs, la tercera dimensi�n es el tiempo
% V: tama�o de la ventana
% dimt: dimensi�n temporal
if nargin < 3
    dimt = 3;
end

Nsim = size(THSP,dimt);
Cp = Nsim-V;
IMts = zeros(1,Cp);
colores = 256;

switch dimt
    case 1
        THSP = permute(THSP,[2 3 1]);
    case 2
        THSP = permute(THSP,[1 3 2]);
end

com = zeros(colores);
for k=1:Cp
    com = norm_COM(THSP(:,:,k:k+V),colores);
    IMts(k) = IM(com);
end