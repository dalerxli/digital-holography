function IMts = IMt(THSP,V,dimt)
% Función que encuentra la evolución del momento de inercia en un conjunto
% de THSPs.
% IMts = Imt(THSP,V)
% THSP: cubo con THSPs, la tercera dimensión es el tiempo
% V: tamaño de la ventana
% dimt: dimensión temporal
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