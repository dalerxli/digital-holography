function ImKF = KF(carpeta,L,N,L2,tipo)

extension = 'dat';
if nargin < 4
    resol = [L L];
else
    resol = [L L2];
end
bloques = 1;
imxbloque = N;
imagenes = bloques * imxbloque;
ImKF = zeros(resol);

if nargin < 5
    tipo = 'uchar';
end

for k_col = 1:resol(2)
    thsp_total = obtener_columna(carpeta,resol,imagenes,k_col,tipo);
    for k_bloque = 1:imxbloque:imagenes
        bloque = (k_bloque-1)/imxbloque+1;
        thsp = thsp_total(:,k_bloque+(0:imxbloque-1));
        
        % Se usa la f�rmula de Konishi - Fujii
        medias = mean(thsp,2);
        thsp = thsp - repmat(medias,1,imxbloque); % Se quita la media
        pseudo_std = sum(abs(thsp),2) / imxbloque;
        try
            pseudo_std(find(pseudo_std==0)) = pseudo_std(find(pseudo_std==0)+1);
            medias(pseudo_std==0) = medias(find(pseudo_std==0)+1);
        catch
            pseudo_std(find(pseudo_std==0)) = 1;
            medias(pseudo_std==0) = 0;
        end
        ImKF(:,k_col) = medias ./ pseudo_std;
    end
end