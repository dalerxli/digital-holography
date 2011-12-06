% [Aout Bval] = AsociarSegm(A,listA,B)
%
% Se asocian los valores de la imagen segmentada A a los valores de
% la imagen de referencia B, la cantidad de valores que puede tomar un
% pixel de A se reduce a la propia para B o queda igual si ya es menor.
% listA contiene la lista de valores que puede tomar un pixel de A.

function [Aout Bval] = AsociarSegm(A,listA,B,Bval,cantidad)

% Cuenta en valores de B
count = [Bval zeros(length(Bval),1)];
% Inicializo la salida
Aout = zeros(size(A));
% Para cada valor que puede tomar A...
for k = listA'
    % Para cada valor que puede tomar B...
    for m = 1:size(count,1)
        % Se cuentan los pixels en B que valen count(m,1) y que est�n en la
        % posici�n de pixels que en A valen k.
        count(m,2) = sum(B(A == k) == count(m,1));
    end
    % Se obtiene el valor m�s probable de B para un cierto valor de A
    count(:,2) = count(:,2)./cantidad;
    [num Bmax] = max(count(:,2));
    % Donde A vale k se ubica el valor m�s probable de B
    Aout(A == k) = count(Bmax,1);
end