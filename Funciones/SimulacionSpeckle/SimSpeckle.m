function I = SimSpeckle(L,TamGra)

D = L/TamGra;   % Diametro del c�rculo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Se arma el circulo de unos.

% Calculo las distancias al centro de la imagen.
DistanciaAlCentro = zeros(L);
Centro = (L+1)/2;
for k_fil = 1:L
    for k_col = 1:L
        DistanciaAlCentro(k_fil,k_col) = sqrt((k_fil-Centro)^2+(k_col-Centro)^2);
    end
end

% Se crea una matriz de unos y ceros con el circulo central de tama�o D
Circulo = DistanciaAlCentro < D;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M�todo FFT_H_IFFT, se llena la matriz completas con n�meros complejos de
% norma 1 y fase aleatoria
dimT = L;
dim2 = L;

minimo = 0;         % Intensidad m�nima en todo el speckle
maximo = 0;         % Intensidad m�xima en todo el speckle
T = rand(dimT,dim2);  % Primer vector aleatorio
I = zeros(L); % Im�genes resultantes

% M�todo FFT_H_IFFT
Uf = exp(1i*T*2*pi);
Uf = fftshift(fft2(Uf));
Uf = Uf.*Circulo;
I = abs(ifft2(fftshift(Uf))).^2;

% Registro el minimo y el m�ximo para conservarlos por que el 0 y el 1
% de la salida de mat2gray deber�a ser el mismo para todas las im�genes
% del cubo.
minimo = min(min(I));
maximo = max(max(I));

I = (I-minimo)/(maximo - minimo);