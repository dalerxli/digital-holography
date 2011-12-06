% varR = VarianzaRegiones(A,B)
%
%   Funci�n que calcula las varianzas de los pixeles para los distintos
%   features en las regiones de segmentaci�n ideales marcadas por la matriz
%   B. La matriz A puede ser una imagen multidimensional. El resultado es
%   un vector cuya longitud viene dada por la cantidad de regiones en B.
%   Tambi�n se guardan la cantidad de pixels por regi�n.

function [varR Sj] = VarianzaRegiones(A,B)

valB = min(B(:)):max(B(:));
N = length(valB);
sA = size(A);
if length(sA) < 3
    sA(3) = 1;
end
varR = zeros(N,1);
Sj = zeros(N,1);
A = permute(A,[3 1 2]);

for j = 1:N
    indices = find(B == valB(j));
    for k = 1:sA(3)
        vector = A(k,indices);
        % Se agrega la varianza sesgada del feature k en la regi�n j.
        varR(j) = varR(j) + var(vector(:),1);
    end
    Sj(j) = length(indices);
    varR(j) = varR(j) / Sj(j);
end