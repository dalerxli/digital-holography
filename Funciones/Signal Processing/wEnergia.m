function energias = wEnergia(C, L)
% Se obtiene la energía relativa en cada escala. En realidad es potencia
% porque se divide por Nj (el contenido de largos)
escalas = length(L);
energias = zeros(size(C,1),escalas);
posicion=1;
C_cuad = C.^2;
for k_escala = 1:escalas
    indices = posicion+(0:L(k_escala)-1);
    energias(:,k_escala) = sum(C_cuad(:,indices),2);
    posicion = posicion + L(k_escala);
end
% energias = energias / sum(energias);
