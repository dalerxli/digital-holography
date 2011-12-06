function ImF = Fujii(carpeta,L,N,L2,tipo)

extension = 'dat';
bloques = 1;
imxbloque = N;
imagenes = bloques * imxbloque;
if nargin < 4
    resol = [L L];
else
    resol = [L L2];
end
ImF = zeros(resol);
if nargin < 5
    tipo = 'uchar';
end

for k_col = 1:resol(2)
    thsp_total = obtener_columna(carpeta,resol,imagenes,k_col,tipo);
    for k_bloque = 1:imxbloque:imagenes
        bloque = (k_bloque-1)/imxbloque+1;
        thsp = thsp_total(:,k_bloque+(0:imxbloque-1));
        
        % Se usa la fórmula de Fujii
        restas = diff(thsp,1,2);
        sumas = thsp(:,1:end-1) + thsp(:,2:end);
        sumas(sumas==0) = 1;
        ImF(:,k_col) = sum(abs(restas) ./ sumas,2);
    end
end