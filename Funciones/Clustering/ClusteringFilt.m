% Función que realiza un clustering de Ejs
function [idx C X Calidad betaCl ContrasteCl] = ClusteringFilt(Ejs,tamQuad,Clusters,plotear,fuzzy)
s_Ejs = size(Ejs);

% Filtro 2D
% [Lo_D Hi_D Lo_R Hi_R] = wfilters(['db' num2str(ceil(tamQuad/2-1))]);
X = AVectorFilt(Ejs,tamQuad,'@chebwin');

% dimF = tamQuad^2*n_esc; % Para el caso en que no quiera promediar los
% valores de Ej de los pixeles del cuadradito.
dimF = s_Ejs(4);
cantMuestras = (s_Ejs(1)-tamQuad+1)*(s_Ejs(2)-tamQuad+1);

NHOOD_STD = ones(11);

% Clustering
saltosClus = ceil(s_Ejs(1)/20); % 5% para el primer clustering.
idx = zeros(cantMuestras, s_Ejs(3));
for k_bloque = 1:s_Ejs(3)
    %     % Como el método de clustering jerárquico es sensible a outliers hay
    %     % que sacar más clústeres y quedarse con los más poblados
    %     ClustersHC = 40*Clusters;
    %     Datos_1er_clus = X(1:saltosClus:end,:,k_bloque);
    %     aux = clusterdata(Datos_1er_clus,'distance','cityblock','maxclust',ClustersHC);
    %     miembros = zeros(ClustersHC,1);
    %     for k_cl = 1:ClustersHC
    %         miembros(k_cl) = sum(aux == k_cl);
    %     end
    %     [n_cls I_cl] = sort(miembros);
    %     C = zeros(Clusters,dimF);
    %     utiles = I_cl(end-Clusters+1:end)';
    %     for k_cl = 1:3
    %         C(k_cl,:) = mean(Datos_1er_clus(aux == utiles(k_cl),:));
    %     end

    %%% K-Means
    if fuzzy == 0
        % Primer clustering con menos muestras, se usa sólo el C que resulta
        [aux C] = kmeans(X(1:saltosClus:end,:,k_bloque),Clusters,'distance','city','replicates',10);
        % Segundo clustering con todas las muestras para hacer la
        % clasificación en todos los cuadraditos.
        [idx(:,k_bloque) C] = kmeans(X(:,:,k_bloque),Clusters,'distance','city','start',C,'emptyaction','singleton');
    else
        %%% Fuzzy C-Means

        [C, U, obj_fcn] = fcm(X(:,:,k_bloque),Clusters,[2 100 1e-5 0]);
        [pert idx(:,k_bloque)] = max(U);
    end
    % Testeo del proceso de clustering.
    Calidad = 0;
    %     if nargout > 3
    %         silh = silhouette(X(1:saltosClus:end,:,k_bloque),idx(1:saltosClus:end,k_bloque));
    %         Calidad = mean(silh);
    %     end
end
if (nargin > 3) && (plotear)
    %     C_ord = C-repmat(min(C,[],2),1,dimF);
    %     C_ord = C_ord./repmat(sum(C_ord,2),1,dimF);
    %     for k_cluster = 1:Clusters
    %         mayoresQcero = C_ord(k_cluster,find(C_ord(k_cluster,:)>0));
    %         fC(k_cluster) = -sum(mayoresQcero.*log2(mayoresQcero),2);
    %     end

    % % Esto funciona si se entra con algo a lo que se le sacó el log10
    %     C_ord = 10.^C;
    %     C_ord = C_ord ./ repmat(sum(C_ord,2),1,dimF);
    %     fC = -sum(C_ord.*log2(C_ord),2);

    % Se multiplica por -1 a los números negativos de energía relativa en dBs y
    % luego se escala para que sumen 1 para poder calcular la entropía
    C_ord = -C;
    C_ord = C_ord./repmat(sum(C_ord,2),1,dimF);
    for k_cluster = 1:Clusters
        mayoresQcero = C_ord(k_cluster,find(C_ord(k_cluster,:)>0));
        fC(k_cluster) = -sum(mayoresQcero.*log2(mayoresQcero),2);
    end

    imagenclus = zeros(s_Ejs(1)-tamQuad+1,s_Ejs(2)-tamQuad+1);
    imagenclus(:) = idx(:,k_bloque);

    imagenclus=fC(imagenclus);
    figure;
    imagesc(imagenclus);
    title('Resultado del clustering.')
    figure;
    plot(C')
%     %%
%     % Para el caso de cuartos esto calcula un factor de acierto
%     cuad = imagenclus(1:200,1:200);
%     V(1)=mean(mean(cuad));
%     Cont(1) = mean(mean(stdfilt(cuad,NHOOD_STD)))/V(1);
%     cuad = imagenclus(end-200:end,1:200);
%     V(2)=mean(mean(cuad));
%     Cont(2) = mean(mean(stdfilt(cuad,NHOOD_STD)))/V(2);
%     cuad = imagenclus(1:200,end-200:end);
%     V(3)=mean(mean(cuad));
%     Cont(3) = mean(mean(stdfilt(cuad,NHOOD_STD)))/V(3);
%     cuad = imagenclus(end-200:end,end-200:end);
%     V(4)=mean(mean(cuad));
%     Cont(4) = mean(mean(stdfilt(cuad,NHOOD_STD)))/V(4);
%     ContrasteCl = mean(Cont);
% 
% 
%     p=diff(V); % Para analizar las diferencias, pasa que esto no considera el
%     % % contraste en el vector, sólo las diferencias.
% 
%     % p=p/sum(p);
%     % betaLASCA = -sum(p.*log2(p))/log2(3) % Enfoque de entropía máxima, no
%     % considera al vector de correlación real.
% 
% %     p = V / sum(V);
% 
% %     rkkmas1 = [0.7520 0.7417 0.7327 0.7239];
%     rkkmas1 = [0.7495 0.7151 0.6779 0.6375];
% %     rkkmas1 = [0.9964 0.9949 0.9931 0.9911];
% 
%     % Enfoque por factor de correlación entre vectores
%     drkkmas1 = diff(rkkmas1) / norm(diff(rkkmas1));
%     betaCl = abs(drkkmas1*p' / norm(p));
% 
%     % Enfoque de divergencia de Kullback Leibler
% %     pkkmas1 = rkkmas1 / sum(rkkmas1);
% %     betaCl = sum(pkkmas1 .* log2(pkkmas1./p));
% 
% figure, plot(p' / norm(p)), hold on, plot(drkkmas1,'r')
end