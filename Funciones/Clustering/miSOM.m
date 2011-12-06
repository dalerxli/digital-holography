close all;
longitud = 500000;
i = 1;
cant_neuronas = 20;
eta1 = 0.5;
sigma = 1;
decr_s = 0.999995;           % En cada paso se multiplica a sigma por esta cantidad.
decr_eta1 = 0.999995;        % En cada paso se multiplica a eta1 por esta cantidad.
umbral = 1e-6;

%Se inicializa la matriz de pesos sinapticos.
W = (2*rand(cant_neuronas, cant_neuronas,2)-1)*.1;
out = rand(cant_neuronas, cant_neuronas);

% Matriz de etas. (Mascara)
patron = zeros(2*cant_neuronas-1);

% Triangulo de distancias que se repite.
for a = 1:(cant_neuronas-1)
    for b = 0:a
        patron( cant_neuronas+b , cant_neuronas+a )= sqrt(a^2+b^2);
    end
end
% Bloque cuadrado inferior derecha.
patron = patron + patron'- diag(diag(patron));
% Parte inferior de la matriz.
patron = patron + fliplr(patron);
patron(:,cant_neuronas) = patron(:,cant_neuronas)/2;
% Se completa la matriz.
patron = patron + flipud(patron);
patron(cant_neuronas,:) = patron(cant_neuronas,:)/2;
% Se calculan los eta iniciales.
patron = gaussmf(patron, [sigma 0]);

while i <= longitud
    x =rand*2-1;
    y = rand*2-1;
    if (x^2+y^2) <= 1
        % Se consigue al indice de fila y columna del ganador.
        condicion = (W(:,:,1)- x).^2 + (W(:,:,2)- y).^2;
        [minimos, indices] = min(condicion);
        [minimo, indice_c] = min(minimos);
        indice_c = indice_c(1);    % Me aseguro de no tener varios minimos.
        indice_f = indices(indice_c);
        % Se aplica la mascara para saber que eta le corresponde a cada
        % neurona.
        eta = patron((cant_neuronas-indice_f+1):(2*cant_neuronas-indice_f),(cant_neuronas-indice_c+1):(2*cant_neuronas-indice_c));        
        % Se actualiza la matriz de eta.
        eta = eta .^ (1/(decr_s^i));
        eta1 = eta1 * decr_eta1;
        eta = eta * eta1;
        sub_umbral = find(eta < umbral);
        eta(sub_umbral) = 0;
        % Actualizacion de los pesos.
        W(:,:,1) = W(:,:,1) - eta.*(W(:,:,1)-x);
        W(:,:,2) = W(:,:,2) - eta.*(W(:,:,2)-y);
        i = i + 1;
        % Animacion.
%         if mod(i,10000)==0
        if i==longitud
            pause(0.01)
            hold off
            for dib = 1 : cant_neuronas
                plot(W(:,dib,1),W(:,dib,2))
                axis([-1 1 -1 1]);
                hold on
                plot(W(dib,:,1),W(dib,:,2))
            end
        end
    end
end