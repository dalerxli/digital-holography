%   [S C E W] = LAC(X,K,h)
%
% Esta función implementa el LAC (Locally Adaptive Clustering), las
% entradas son: X: matriz cuyas filas son muestras observadas de N features
% (columnas), K es la cantidad de clusters y h es un parámetro mayor a
% cero.
% Las salidas son:
%   S = vector que indica el cluster al que pertenece cada muestra
%   C = matriz cuyas filas contienen los centroides
%   E = vector que indica la evolución de la función costo en la corrida
%   W = matriz de pesos final, en sus filas estan los pesos
%   correspondientes a cada cluster.
%
% C. Domeniconi, "Locally Adaptive Techniques for Pattern
% Classification," PhD dissertation, 2002.
% C. Domeniconi, "Locally AdaptiveMetrics for Clustering High Dimensional
% Data," 2006

function [S C E W] = invLACv2(X,K,h)

% M : cantidad de muestras
% N : dimensión de vector de features
[M N] = size(X); 
h = h/log(N); % Queda normalizado en cuanto a N
% Matriz de covarianza de las muestras
CovTotal = cov(X);
% Media de las muestras
med = mean(X);
% Transformación de la normal a la gaussiana que llena el espacio de
% muestras para la inicialización de los clusters
CholCT = chol(CovTotal);
C = randn(K,N)*CholCT + repmat(med,K,1);
% Inicialización uniforme de los pesos de cada feature en cada cluster
invW = ones(K,N)/N;
% Error
E = 1;

% Inicialización de variables usadas en el loop
L = zeros(M,K); % Distancias con pesos
CardS = zeros(K,1); % Cardinalidad de los sets
Ast = zeros(N,1);

paso = 1;
Emantenido = 6;
stdE = 1;
lambda = ones(N,1);

% Actualizaciones
while paso <= Emantenido || stdE > 0.00001  
% Actualización de asignaciones S
    for k = 1:K
        L(:,k) = sum(repmat(invW(k,:),M,1).*(repmat(C(k,:),M,1) - X).^2,2);
    end
    [LS S] = min(L,[],2);
    
    ActualE = 0;
    for k = 1:K
        CardS(k) = sum(S == k);
        D = sum((repmat(C(k,:),CardS(k),1) - X(S == k ,:)).^2) / CardS(k);
% Cálculo del error actual
        ActualE = ActualE + sum(invW(k,:).*D - h*invW(k,:).^-1.*log(invW(k,:).^-1));
% Asterisco en la deducción
        for k_i = 1:N
            Ast(k_i) = sum(log(invW(k,:)/invW(k,k_i))./invW(k,:))/sum(invW(k,:));
        end
% Cálculo de lambda por método de punto fijo                
        for paso = 1:10
            lambda = repmat(D(1),N,1) + (sum(1./sqrt(repmat(lambda,1,N-1)-repmat(D(2:end)',N,1)),2) - 1./sqrt(h*Ast)).^-2;
        end
% Actualización de pesos W        
        invW(k,:) = sqrt(h*Ast./(lambda-D));
% Actualización de los centroides        
        C(k,:) = sum(X(S == k,:)) / CardS(k);
    end
    if paso == 1
        E = ActualE;
        stdE = 1;
    else
        E = [E ActualE];
        stdE = std(E(max(paso-Emantenido+1,1):paso))/E(paso);
    end       
    paso = paso + 1;
end

% Cálculo del error final
ActualE = 0;
for k = 1:K
    CardS(k) = sum(S == k);
    D = sum((repmat(C(k,:),CardS(k),1) - X(S == k ,:)).^2) / CardS(k);
    ActualE = ActualE + sum(invW(k,:).*D - h*invW(k,:).^-1.*log(invW(k,:).^-1));
end
E = [E ActualE];