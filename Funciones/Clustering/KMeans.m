%   [pert_estf Cf] = KMeans(X,Clusters,repeticiones,fmt_dist)
% Esta función implementa el algoritmo de K-Means.
% X contiene los vectores de features en columnas.
% Clusters es la cantidad de clusters.
% repeticiones es la cantidad de veces que se realiza el clustering, dado
% que el resultado obtenido depende de la inicialización conviene tomar un
% número mayor a 1.
% fmt_dist puede ser Mahalanobis, Euclidea o City
% La salida pert_estf contiene los índices a los que pertenece cada una de
% las muestras.
% Cf tiene en sus columnas a las posiciones de los centroides de los
% clusters.

function [pert_estf Cf] = KMeans(X,Clusters,repeticiones,fmt_dist)

dimF = size(X,1);
N = size(X,2);

% Se aumentan las variables para hacer cuentas rápido
X_aug = repmat(X,[1 1 Clusters]);

% Se repetirá el clustering varias veces y se conservará el que tenga menor
% error.
error = inf;

for k_rep = 1:repeticiones

    % Realizo un ordenado aleatorio para la inicialización de clusters
    orden = randperm(N);

    % Clustering
    C = X(:,orden(1:Clusters));
    C = permute(C,[1 3 2]);
    C_aug = zeros(2,N,Clusters);

    dif = 1;
    pert_est = ceil(rand(1,N)*Clusters);
    Covar = repmat(eye(dimF),[1 1 Clusters]);
    %     pasos = 0;

    % Mientras se detecten diferencias en la clasificación...
    while dif ~= 0
        C_aug = repmat(C,[1 N 1]);
        % Diferencias
        difer = X_aug - C_aug;
        % Distancias
        
        if strcmp(fmt_dist,'Mahalanobis')
        %   Mahalanobis
            for k_cl = 1:Clusters
                D(1,:,k_cl) = sum(difer(:,:,k_cl) .* (inv(Covar(:,:,k_cl)) * difer(:,:,k_cl)));
            end
        elseif strcmp(fmt_dist,'Euclidea')
        %   Norma euclidea
            D = sum((difer).^2);
        elseif strcmp(fmt_dist,'City')
        %   City distance
            D = sum(abs(difer));
        end
            
        % Conservo la clasificación anterior para ver si hubo mejoras
        pert_est_ = pert_est;

        % Se clasifica calculando el centroide que está a menor distancia de la
        % muestra.
        [Distancias2 pert_est] = min(D,[],3);

        % La condición de salida es que no se produzcan cambios en la clasificación
        if sum(pert_est_ ~= pert_est) == 0
            dif = 0;
        end

        % Actualización de los clusters al punto medio de las muestras de cada
        % cluster.
        for k_cl = 1:Clusters
            C(:,1,k_cl) = mean(X(:,pert_est == k_cl),2);
            if strcmp(fmt_dist,'Mahalanobis')
                Covar(:,:,k_cl) = cov(X(:,pert_est == k_cl)');
            end
            %plot(C(1,1,k_cl),C(2,1,k_cl),'ks','MarkerSize',9,'LineWidth',3);
            %             hold on;
        end
    end

    error_rep = sum(Distancias2)/N;
    if error > error_rep
        Cf = C;
        pert_estf = pert_est;
        error = error_rep;
    end
end
Cf = permute(Cf,[1 3 2]);