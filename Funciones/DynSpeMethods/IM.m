% im = IM(M)
%
%   Se obtiene el momento de inercia de una matriz de co-ocurrencia M. Si M
%   es un set de matrices entonces se calcula un IM para cada una de las
%   matrices de co-ocurrencia.

function im = IM(M)

im = zeros(size(M,3),1);
% Se arma la matriz de distancias y pesos
dif_ind = zeros(size(M,1),size(M,2));
for k = 1:size(M,1)
    dif_ind(k,:) = (1-k):(size(M,2)-k);
end
dif_ind = dif_ind.^2;

for n = 1:size(M,3)
    im(n) = sum(sum(M(:,:,n).*dif_ind));
end