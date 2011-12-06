function MatDist = distancias(X)

[n p] = size(X);
MatDist = zeros(p);

for k = 1:p-1
    restas = X(:,k+1:p) - repmat(X(:,k),1,p-k);
    MatDist(k,k+1:end) = sum(restas.^2);
    MatDist(k:end,k) = MatDist(k,k:end)';
end

MatDist = sqrt(MatDist);