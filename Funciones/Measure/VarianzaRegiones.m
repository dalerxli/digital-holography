% varR = VarianzaRegiones(ImFeat, A)
%
%   Función que calcula las varianzas de los pixeles para los distintos
%   features en las regiones de segmentación obtenidas en A. La matriz
%   ImFeat puede ser una imagen multidimensional. El resultado es un vector
%   cuya longitud viene dada por la cantidad de regiones en A.
%   También se guarda la cantidad de pixels por región.

function [varR Sj] = VarianzaRegiones(ImFeat, A)

[Reg contR] = Regionalizar(A);
valA = listar(A(:));
N = length(valA);
sIm = size(ImFeat);
if length(sIm) < 3
    sIm(3) = 1;
end
varR = zeros(N,1);
Sj = zeros(N,1);
ImFeat = permute(ImFeat,[3 1 2]);

% Cálculo de varianza para cada región
for j = 1:N
    % Pixels de la región
    indices = find(A == valA(j));
    % Tratamiento individual de cada feature
    for k = 1:sIm(3)
        vector = ImFeat(k,indices);
        % Se agrega la varianza sesgada del feature k en la región j.
        varR(j) = varR(j) + var(vector(:),1);
    end
    % Cantidad de pixels en la región
    Sj(j) = length(indices);
    % Normalización
    varR(j) = varR(j) / Sj(j);
end