% [C error] = FitImageLS(A,B,orden)
%
%   Una matriz C es obtenida a partir de B que es la que mejor ajusta a A.
%   También se obtiene el error cuadrático medio entre la salida y A.

function [C error] = FitImageLS(A,B,orden)

sA = size(A);
Coef = zeros(orden+1,1);
M = sA(1)*sA(2);
C = zeros(sA);

% Armado de la matriz C
Phi = [ones(M,1) zeros(M,orden)];
for k = 1:orden
    Phi(:,k+1) = B(:).^k;
end

% Least Squares
MatLS = inv(Phi'*Phi)*Phi';
Coef = MatLS*A(:);

% Se aplica LS
C(:) = Phi * Coef;

% Medición optativa del error
if nargout == 2
    
    dif = (A - C).^2;
    error = sum(dif(:)) / M;
    
end