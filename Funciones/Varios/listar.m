% function [list cant] = listar(V)
%
%   Se obtiene una lista de los vectores de N valores de V y la cantidad de
%   veces que se repite cada vector. V es una matriz de M filas y N
%   columnas.

function [list cant] = listar(V)

list = V(1,:);
cant = 1;
lenList = 1;
[M N] = size(V);

for k = 2:M
    buscar = 1;
    d = 1;
    restan = 1:lenList;
    while d <= N && buscar
        restan = restan(list(restan,d) == V(k,d));
        if  isempty(restan)
            buscar = 0;
        end
        d = d + 1;
    end
    if buscar == 0
        lenList = lenList + 1;
        list(lenList,:) = V(k,:);
        cant = [cant; 1];
    else
        cant(restan) = cant(restan) + 1;
    end
end