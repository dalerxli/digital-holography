function Ej = EnergiaRelativaEscala(thsp,escalas,filtro)
% Se ingresa un THSP y calcula la energía de la señal en cada escala. Es
% relativa a la energía total de la señal.
if nargin==1
    escalas = fix(log2(size(thsp,2)));  % Cantidad de escalas fijada por el número de muestras.
end
[C L] = mi_dwt(thsp,escalas-1,filtro);
% Ej = zeros(size(thsp,1),escalas); 
Ej = wEnergia(C,L); % Energía de la escala para cada pixel.
% for k_fil = 1:size(thsp,1)
%     vector = thsp(k_fil,:);
%     vector = vector(:);
% %     % Se calculan los coeficientes de la DWT
% %     [Adwt_thsp Ddwt_thsp largos] = mi_dwt(vector,escalas,'db8');
%     [C largos] = wavedec(vector,escalas-1,filtro);
%     % Se encuentra la energía relativa de la señal en cada escala
% %     Ej(k_fil,:) = wEnergia(C, largos(1:(end-1)));
%     [Ea, Ed] = wenergy(C, largos);
%     Ej(k_fil,:) = [Ea fliplr(Ed)];
% end
