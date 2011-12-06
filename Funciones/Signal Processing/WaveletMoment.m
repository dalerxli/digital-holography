function Ejs = WaveletMoment(CarpetaMCol,L,Nsim,madreWav,mom)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Script para obtener el momento wavelet de las señales de las THSP

extension = 'dat';
resol = [L L];
imagenes = Nsim;
cant_escalas = wmaxlev(imagenes,madreWav)+1;
Ejs = zeros([resol cant_escalas]);


for k_col = 1:resol(2)
    thsp = obtener_columna(CarpetaMCol,resol,imagenes,k_col,'uchar');
    
    % Normalizaciï¿½n
    thsp = thsp - repmat(mean(thsp,2),1,imagenes);
    thsp = thsp ./ repmat(sqrt(sum(thsp.^2,2)),1,imagenes);
    
    Ej = MomentoRelativoEscala(thsp,cant_escalas,madreWav,mom);
    % Se guardan los resultados de las energï¿½as relativas
    Ejs(:,k_col,:) = Ej;
    
end
