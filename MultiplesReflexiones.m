% Basado en "Transmission coefficient of a one-dimensional multi-layer
% medium from a sum over all light-rays."
% 
% Hay N capas de �ndices de refracci�n y espesores distintos (ls) entre dos
% medios con �ndice n_0 y n_{N+1}. Los N+2 �ndices se ingresan en el array
% n por lo cual hay que tener esto en cuenta para acceder a los �ndices.
function [refl tran] = MultiplesReflexiones(n,ls)
longOnda = 680e-9;
k0 = 2*pi/longOnda;
N = length(ls);
% Coeficientes de Fresnel
r = -diff(n)./(n(1:end-1)+n(2:end)); % Reflexi�n hacia adelante, en el otro sentido va cambiado de signo.
t = 2*n(1:end-1) ./ (n(1:end-1)+n(2:end));
tr = 2*n(2:end) ./ (n(1:end-1)+n(2:end));
% Pi. Contiene los factores de propagaci�n a trav�s de las N capas.
Pi = exp(1i*k0*n(2:end-1).*ls);
% Matriz de loops. Los loops pueden formarse s�lo dentro de las capas, no
% en los medios externos.
lambda = zeros(N);
rho = zeros(N);
for p = 1:N % Existen N+1 interfaces pero el loop no puede empezar en la �ltima.
    for q = p:N % ... ni terminar en la primera
        rho(p,q) = -r(p)*Pi(p)*prod(t(p+1:q).*Pi(p+1:q));
        lambda(p,q) = r(q+1)*Pi(q)*prod(tr(p+1:q).*Pi(p:q-1));        
    end
end
loop = rho.*lambda;

% Coeficientes de transmisi�n y reflexi�n total
refl = r(1);
tran = t(1);
tk0 = tran;
trk0 = 1;
Lk = zeros(N+1,1);
for k = 1:N
    % Coeficiente de transmisi�n directo para el caso de k capas
    tk0 = tk0 * t(k+1)*Pi(k);
    % Coeficiente de transmisi�n directo en direcci�n opuesta para el caso
    % de k capas, sin la primera transmisi�n
    trk0 = trk0 * tr(k)*Pi(k);
    % C�lculo de Lk
    Lk(k+1) = Lk(k) + sum((1-Lk(1:k)).*loop(1:k,k));
    % C�lculo de (1-Lk)^-1
    auxLk = 1/(1-Lk(k+1));
    % Acumulamiento de coeficiente reflexi�n para k capas
    refl = refl + tran*Pi(k)*r(k+1)*trk0*auxLk;
    % C�lculo de coeficiente transmisi�n para k capas
    tran = tk0*auxLk;    
end