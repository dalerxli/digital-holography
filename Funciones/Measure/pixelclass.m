% C = pixelclass(A,B)
%
% Cij contiene la cantidad de pixels de la clase j en B que fueron
% clasificados como clase i en A

function C = pixelclass(A,B,Bval)

% Valores de A y B
numVal = length(Bval);
C = zeros(numVal);

for i = 1:numVal
    for j = 1:numVal
        C(i,j) = sum(A(B==Bval(j))==Bval(i));
    end
end