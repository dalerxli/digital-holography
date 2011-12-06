% ImWGD = WGD(CarpetaMCol,L,N,Ld,L2,normalizar)

function ImWGD = WGD(CarpetaMCol,L,N,Ld,L2,tipo,normalizar)

extension = 'dat';
if nargin < 5
    resol = [L L];
else
    resol = [L L2];
end
bloques = 1;
imxbloque = N;
imagenes = bloques * imxbloque;
ImWGD = zeros(resol);
if nargin < 6
    tipo = 'uchar';
end
if nargin < 7
    normalizar = 1;
end

for k_col = 1:resol(2)
    thsp_total = obtener_columna(CarpetaMCol,resol,imagenes,k_col,tipo);
    for k_bloque = 1:imxbloque:imagenes
        bloque = (k_bloque-1)/imxbloque+1;
        thsp = thsp_total(:,k_bloque+(0:imxbloque-1));
       
        medias = mean(thsp,2);
        thsp = thsp - repmat(medias,1,imxbloque); % Se quita la media
        
        % Normalizaci�n
        if normalizar
            thsp = thsp ./ repmat(sqrt(sum(thsp.^2,2)),1,imxbloque);
        end
        
        % Se usa la f�rmula de WGD
        for k_dif = 1:Ld
            ImWGD(:,k_col) = ImWGD(:,k_col) + sum(abs(thsp(:,1:end-k_dif) - thsp(:,k_dif+1:end)),2);
        end
        
    end
end

ImWGD(isnan(ImWGD)) = 0;