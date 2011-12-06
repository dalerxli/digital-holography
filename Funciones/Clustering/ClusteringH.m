% Método jerárquico


% Función que realiza un clustering de Ejs
function [idx C X] = ClusteringH(Ejs,tamQuad,Clusters,plotear)
s_Ejs = size(Ejs);
% dimF = tamQuad^2*n_esc; % Para el caso en que no quiera promediar los
% valores de Ej de los pixeles del cuadradito.
dimF = s_Ejs(4);
cantMuestras = (s_Ejs(1)-tamQuad+1)*(s_Ejs(2)-tamQuad+1);
Ejsper = permute(Ejs,[4 3 1 2]);
saltoClus = ceil(cantMuestras/100);

% Clustering
idx = zeros(cantMuestras, s_Ejs(3));
X = zeros(cantMuestras,dimF,s_Ejs(3));
for k_bloque = 1:s_Ejs(3)
    k = 1;
    for k_col = 1:s_Ejs(2)-tamQuad+1
        for k_fil = 1:s_Ejs(1)-tamQuad+1
            a=repmat( ((k_fil+(k_col-1)*s_Ejs(1) ):( k_fil+tamQuad-1+(k_col-1)*s_Ejs(1)))',1,tamQuad );
            dire_directa = a+repmat((0:tamQuad-1)*s_Ejs(1),tamQuad,1);
            dire_directa = dire_directa(:);
            vectorF = permute(Ejsper(:,k_bloque,dire_directa),[1 3 2]);
            vectorF = mean(vectorF,2); % comentar esto si no quiero promediar.
            X(k,:,k_bloque) = vectorF(:)';
            k = k+1;
        end
    end

    idx(1:saltoClus:end,k_bloque) = clusterdata(X(1:saltoClus:end,:,k_bloque),'maxclust',Clusters,'distance','mahalanobis');

    for k_cluster = 1:Clusters
        C(k_cluster,:) = mean(X(idx(1:saltoClus:end,1)==k_cluster,:,1));
    end

    invCov = inv(cov(X));
    
    for k = 1:cantMuestras
        if sum(k==(1:saltoClus:cantMuestras)) == 0
            resta = repmat(X(k,:,k_bloque),Clusters,1) - C;
            distancias = sum(resta.*(resta * invCov),2);
            [d idx(k,k_bloque)] = min(distancias);
        end
    end
end

if (nargin > 3) && (plotear)
    imagenclus = zeros(s_Ejs(1)-tamQuad+1,s_Ejs(2)-tamQuad+1);
    imagenclus(:) = idx(:,k_bloque);
    %     C_ord = (C-repmat(min(C),Clusters,1))./repmat(max(C)-min(C),Clusters,1);
    %     fC = sum(C_ord,2);
    if min(min(C)) < 0
        C_ord = C-repmat(min(C,[],2),1,dimF);
    end
    C_ord = C_ord./repmat(sum(C_ord,2),1,dimF);
    for k_cluster = 1:Clusters
        mayoresQcero = C_ord(k_cluster,find(C_ord(k_cluster,:)>0));
        fC(k_cluster) = -sum(mayoresQcero.*log2(mayoresQcero),2);
    end
    imagenclus=fC(imagenclus);
    figure;
    imagesc(imagenclus);
    figure;
    plot(C_ord')
end