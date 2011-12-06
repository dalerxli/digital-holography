% Ver M. Pajuelo, G. Baldwin, H. Rabal, N. Cap, R. Arizaga,
% M. Trivi, Bio-speckle assessment of bruising in fruits, Opt Eng 2003
%
% R. A. Braga Jr., B Oliveira Silva, G. Rabelo, R. Marques Costa, A.
% Machado Enes, N. Cap, H. Rabal, R. Arizaga, M. Trivi, G. Horgand, 
% Reliability of biospeckle image analysis, Opt. Laser Eng. 45(2007)

function ImLASCA = LASCA(carpeta,L,tQ,N,L2,tipo)
if nargin < 5
    resol = [L L];
else
    resol = [L L2];
end
bloques = 1;
imxbloque = N;
imagenes = bloques * imxbloque;
ImInt = zeros(resol);
ImLASCA = zeros(resol);
if nargin < 6
    tipo = 'uchar';
end

for k_col = 1:resol(2)
    thsp_total = obtener_columna(carpeta,resol,imagenes,k_col,tipo);
    for k_bloque = 1:imxbloque:imagenes
        bloque = (k_bloque-1)/imxbloque+1;
        ImInt(:,k_col) = sum(thsp_total(:,k_bloque+(0:imxbloque-1)),2);       
    end
end

% Inicializaciones
for k_fil = 1:L
    filas = k_fil : min(k_fil+tQ-1,L);
    for k_col = 1:resol(2)
        columnas = k_col : min(k_col + tQ-1,resol(2));
        v = ImInt(filas,columnas);
        v = v(:);
        ImLASCA(k_fil,k_col) = std(v)/mean(v);
    end
end
