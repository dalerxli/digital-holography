function [Ejsm Ejsd] = ImagenEnergia(CarpetaMCol,L,Nsim,L2,tipo)
% Función para obtener una imagen de la energía de la evolución de
% intensidad en cada pixel

extension = 'dat';
if nargin < 5
    resol = [L L];
else
    resol = [L L2];
end
imagenes = Nsim;
Ejs = zeros(resol);
if nargin < 6
    tipo = 'uchar';
end

for k_col = 1:resol(2)
    thsp = obtener_columna(CarpetaMCol,resol,imagenes,k_col,tipo);
    Ejsm(:,k_col) = mean(thsp,2);
    thsp = thsp - repmat(Ejsm(:,k_col),1,imagenes);
    Ejsd(:,k_col) = sqrt(sum(thsp.^2,2));
    
end
