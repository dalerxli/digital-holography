function A = tirar_atras(M,v,dim)

if nargin == 2
    dim = 2;
end
natras = length(v);
N = size(M,dim);
Cubo = size(M,3);
ind = zeros(N,1);
ind(end-natras+1:end) = v;
k = 1;
for i = 1:N
    if isempty(find(v==i))
        ind(k) = i;
        k = k +1;
    end
end

if Cubo == 1
    if dim == 1
        A = M(ind,:);
    else
        A = M(:,ind);
    end
else
    if dim == 1
        A = M(ind,:,:);
    elseif dim == 2
        A = M(:,ind,:);
    elseif dim == 3
        A = M(:,:,ind);
    end
end
    