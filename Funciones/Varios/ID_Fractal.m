function m = ID_Fractal(X,lim1,lim2)

puntos = 40;
% Distancias = dist(X);
load DistanciasparaID_Fractal
N = size(X,2);
maxima = max(Distancias(:));
Distancias = Distancias + eye(N)*maxima;
minima = min(Distancias(:));
erres = logspace(log10(minima),log10(maxima/2),puntos+1);
erres = erres(2:end);
k = 1;
Cnr = zeros(1,puntos);
for r = erres
    comp = Distancias < r;
    Cnr(k) = sum(comp(:))/N/(N-1);
    k = k + 1;
end

loglog(erres(lim1:lim2),Cnr(lim1:lim2))

x = log10(erres(lim1:lim2));
A = [x' ones(length(x),1)];
y = log10(Cnr(lim1:lim2));
b = inv(A'*A)*A'*y';
m = b(1);