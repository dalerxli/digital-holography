% CT = ContrasteTemporal(Carpeta,resol,N,BLOQUES,PASO)
% Encuentra el contraste temporal y el tiempo de correlación en distintos
% puntos de las imágenes. Toma los bloques de datos ingresados en BLOQUES y
% realiza un paso temporal para el cálculo del contraste dado por PASO.

function CT = ContrasteTemporal(Carpeta,resol,N,BLOQUES,PASO)

% Inicialización de variables no ingresadas
if nargin < 3
    N = 256;
end
% Para que el nombre de la carpeta pueda ser ingresado con o sin '\'
if Carpeta(end) ~= '\'
    Carpeta = [Carpeta '\'];
end

CT = zeros(N-PASO+1,size(BLOQUES,1));

for k_B = 1:size(BLOQUES,1)
    
    nCols = BLOQUES(k_B,4)-BLOQUES(k_B,3)+1;
    thsps = zeros(resol(1),N,nCols);
    for k=0:nCols-1
        thsps(:,:,k+1) = obtener_columna(Carpeta, resol(1), N, BLOQUES(k_B,3)+k, 'uchar');
    end
    thsps = thsps(BLOQUES(k_B,1):BLOQUES(k_B,2),:,:);
    
    desvios = zeros(N-PASO+1,1);
    medias = zeros(N-PASO+1,1);
    % tc = zeros(N-PASO+1,1);
    % Desvios locales
    for k = 1:N-PASO+1
        d = std(thsps(:,k:min(k+PASO-1,N),:),0,2);
        d = mean(d,3);
        desvios(k) = mean(d);
        medias(k) = mean(mean(mean(thsps(:,k:min(k+PASO-1,N),:),3)));
        %     tc(dvIdx) =
        %     mean(CorrelationTime(thsps(k_f,k:min(k+PASO-1,N),k_c)));
    end
    
    CT(:,k_B) = desvios ./ medias;
end