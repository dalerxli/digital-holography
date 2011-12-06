% [Y_Best J_Best] = MDS(X,m)
% 
% Esta función implementa la rutina de Multidimensional Scaling para poder
% llevar L vectores de dimensión n a otros de dimensión m < n.
% Las entradas son: la matriz X de n filas y L columnas, la dimensión
% resultado m.
%
% [Y_Best J_Best] = MDS(X,m,lambda)
% [Y_Best J_Best] = MDS(X,m,lambda,intentos)
%
% lambda es la constante de convergencia del método (default 0.5) y puede
% indicarse la cantidad de intentos del algoritmo, por default es 10.
% Las salidas son: la matriz Y de m filas y L columnas y el valor de J
% (función costo) alcanzado.
% Ver Duda & Hart page 60 Chapter 10

function [Y_Best J_Best] = MDS(X,m,lambda,intentos)

if nargin < 4
    intentos = 10;
end
if nargin < 3
    lambda = 0.5;
end

[n L] = size(X);
MatDelta = distancias(X);
Y_Best = zeros(m,L);
epsilon = 0.001;

for k_int = 1:intentos

    Y = randn(m,L);
    norm_e = 1;
    k_paso = 1;

    while norm_e > epsilon && k_paso < 1000        
        MatD = distancias(Y);
        % Cálculo del gradiente de Jef
        grad = zeros(m,L);
        MatConst = 4/sum(MatDelta(:)).*(MatDelta-MatD)./(MatDelta+eye(L))./(MatD+eye(L));
        for k = 1:L
            restas = Y - repmat(Y(:,k),1,L);
            restas = restas.*repmat(MatConst(k,:),m,1);
            grad(:,k) = sum(restas,2);
        end    
        % Steepest Descent
        e = lambda * grad;
        Y = Y - e;
        k_paso = k_paso+1;
        norm_e = sum(sqrt(sum(e.^2))/m);
    end
    MatDelta = distancias(X);
    MatD = distancias(Y);
    J = (MatDelta-MatD).^2./(MatDelta+eye(L))/sum(MatDelta(:));
    J = sum(J(:));
    if k_int == 1
        J_Best = J;
        Y_Best = Y;
    elseif J < J_Best
        J_Best = J;
        Y_Best = Y;
    end
end
