function MSj = MomentoStdRelativoEscala(thsp,escalas,filtro,mom)
% Se ingresa un THSP y calcula el momento estandarizado de la señal en cada
% escala.
if nargin==1
    escalas = fix(log2(size(thsp,2)));  % Cantidad de escalas fijada por el número de muestras.
end
[C L] = mi_dwt(thsp,escalas-1,filtro);

%Cálculo de la media
escalas = length(L);
Medj = zeros(size(C,1),escalas);
posicion=1;
for k_escala = 1:escalas
    indices = posicion+(0:L(k_escala)-1);
    Medj(:,k_escala) = sum(C(:,indices),2) / length(indices);
    posicion = posicion + L(k_escala);
end

% Calculo de momento, desvio y momento estandarizado
Mj = zeros(size(C,1),escalas);
Dj = zeros(size(C,1),escalas);
posicion=1;
for k_escala = 1:escalas
    indices = posicion+(0:L(k_escala)-1);
    n = length(indices);
    resta = C_cuad(:,indices) - repmat(Medj(:,k_escala),1,n);
    Mj(:,k_escala) = sum(resta.^mom / n,2);
    Dj(:,k_escala) = sum(resta.^2 / n,2);
    MSj(:,k_escala) = Mj(:,k_escala) ./ Dj(:,k_escala)^(mom/2);
    posicion = posicion + L(k_escala);
end