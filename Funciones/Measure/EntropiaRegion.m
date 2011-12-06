% [HRj Sj] = EntropiaRegion(A,listA,B);
%
%   Se calcula la entrop�a por segmento de A teniendo en cuenta el
%   histograma de los valores que toman los pixels de A en las regiones
%   ideales de B.
%   Se obtiene un valor para cada regi�n de B.

function [HRj Sj] = EntropiaRegion(A,Bval,B)

N = length(Bval);
Sj = zeros(1,N);
Lj = zeros(N);

% Para cada regi�n
for j = 1:N
    indices = find(B == Bval(j));
    Sj(j) = length(indices);
    vector = A(indices);
    Lj(:,j) = hist(vector,Bval);
end

prj = Lj./repmat(Sj,N,1);
logprj = log10(prj);
logprj(isinf(logprj)) = 0;
HRj = -sum(prj.*logprj);