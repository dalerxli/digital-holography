% [W A] = laSOM(X,Neuronas,PA,p)
%
% Función para entrenar una red neuronal SOM.
% X contiene a los datos usados para el aprendizaje. Cada fila es una
% entrada.
% Neuronas es un vector que contiene las dimensiones de la grilla de
% neuronas. Si es un valor se tiene entonces una topología lineal.
% PA es una estructura de parámetros de aprendizaje que contiene a los
% campos:
% - epocas: cantidad de veces que se repiten los datos a la entrada de la
% red. Default = 100;
% - PA.orden: proporción de pasos de ordenamiento. Default = 0.1.
% - PA.alfaIni: valor de factor de aprendizaje inicial. Default = 0.9.
% - PA.alfaTun: valor de factor de aprendizaje de tuning. Default = 0.01.
% - PA.NeighIni: distancia relativa de vecindario inicial. Default = 0.5.
% - PA.NeighTun: distancia absoluta de vecindario de tuning. Defalut = 1.
% - p: norma p para el cálculo de la distancia entre neurona y muestra.
% Default = 2.

function [W A] = laSOM(X,Neuronas,PA,p)

% Validación de entradas
if ~isfield(PA,'epocas')
    PA.epocas = 100;
end
if ~isfield(PA,'orden')
    PA.orden = 0.1;
end
if ~isfield(PA,'alfaIni')
    PA.alfaIni = 0.9;
end
if ~isfield(PA,'alfaTun')
    PA.alfaTun = 0.01;
end
if ~isfield(PA,'NeighIni')
    PA.NeighIni = 0.5;
end
if ~isfield(PA,'NeighTun')
    PA.NeighTun = 1;
end
if ~exist('p','var')
    p = 2;
end

% Cantidad de muestras
N = size(X,1);
% Dimensión
d = size(X,2);

% Matriz de asignaciones
A = zeros(N,1);

% Se inicializa la matriz de pesos sinapticos.
W = (randn(Neuronas(1), Neuronas(2),d))*.1;

% Matriz de distancias.
[Xs,Ys] = meshgrid(-Neuronas(1)+1:Neuronas(1)-1,-Neuronas(2)+1:Neuronas(2)-1);                                
Z = sqrt(Xs.^2 + Ys.^2);

% Esta es la cantidad de veces que se tendrá una actualización
Pasos = PA.epocas * N;

% Orden aleatorio de muestras
alea = randperm(N);

% Fase de ordenamiento
PasosOrden = floor(PA.orden * Pasos);
FactorAlfa = exp(log(PA.alfaTun/PA.alfaIni)/(PasosOrden-1));
NeighIni = PA.NeighIni * max(Neuronas);
FactorNeigh = exp(log(PA.NeighTun/NeighIni)/(PasosOrden-1));

Neigh = NeighIni;
FA = PA.alfaIni;
errores = zeros(size(W));
Dist = zeros(Neuronas);
condicion = zeros(size(W));
alfa = zeros(Neuronas);
ini = clock;
for k = 1:PasosOrden
    % Se consigue al indice de fila y columna del ganador.
    errores = W - repmat(permute(X(alea(mod(k,N)+1),:),[3 1 2]),[Neuronas(1) Neuronas(2) 1]);
    condicion = abs((errores).^p);
    condicion = sum(condicion,3);
    [minimos, indices] = min(condicion);
    [minimo, indice_c] = min(minimos);
    indice_c = indice_c(1);    % Me aseguro de no tener varios minimos.
    indice_f = indices(indice_c);
    % Asignación
    A(alea(mod(k,N)+1)) = (indice_c-1)*Neuronas(1) + indice_f;
    % Vecinos
    Dist = Z((Neuronas(1)-indice_f+1):(2*Neuronas(1)-indice_f),(Neuronas(2)-indice_c+1):(2*Neuronas(2)-indice_c));
    alfa(Dist > Neigh) = 0;
    alfa(Dist <= Neigh) = 0.5;
    alfa(indice_f,indice_c) = 1;
    alfa = alfa * FA;
    % Actualizacion de los pesos.
    W = W - repmat(alfa,[1 1 d]) .* errores;
    % Actualización de parámetros de ordenamiento
    Neigh = Neigh * FactorNeigh;
    FA = FA * FactorAlfa;
end
etime(clock,ini)
disp('Tuning')
% Fase de tuning
for k = PasosOrden+1 : Pasos
    % Se consigue al indice de fila y columna del ganador.
    errores = W - repmat(permute(X(alea(mod(k,N)+1),:),[3 1 2]),[Neuronas(1) Neuronas(2) 1]);
    condicion = abs((errores).^p);
    condicion = sum(condicion,3);
    [minimos, indices] = min(condicion);
    [minimo, indice_c] = min(minimos);
    indice_c = indice_c(1);    % Me aseguro de no tener varios minimos.
    indice_f = indices(indice_c);
    % Asignación
    A(alea(mod(k,N)+1)) = (indice_c-1)*Neuronas(1) + indice_f;
    % Vecinos
    Dist = Z((Neuronas(1)-indice_f+1):(2*Neuronas(1)-indice_f),(Neuronas(2)-indice_c+1):(2*Neuronas(2)-indice_c));
    alfa(Dist > Neigh) = 0;
    alfa(Dist <= Neigh) = 0.5;
    alfa(indice_f,indice_c) = 1;
    alfa = alfa * FA;
    % Actualizacion de los pesos.
    W = W - repmat(alfa,[1 1 d]) .* errores;
end