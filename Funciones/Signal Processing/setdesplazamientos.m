

%%% Queda por la mitad


% function vectores = desplazamientos(S1,S2,w)
%
% La funci�n calcula los vectores de desplazamiento de cada ventana de S1,
% teniendo en cuenta la imagen final S2. El par�metro w indica el ancho de
% la ventana utilizada para el c�culo. Se toma un valor de 8 como default.

function Des = setdesplazamientos(S1,S2,w)

if nargin < 3
    w = 8;
end

% Tama�o de las im�genes
sS1 = size(S1);

% Tama�o de ventana m�ximo
wmax = max(w);

% El pixel al que pertenece la primer flecha est� en la posici�n [a a] para
% todos los w.
a = 

% Inicializaciones
% Tama�o de la matriz de salida
sDes = [sS1(1)-w+1 sS1(2)-w+1 2];
Des = zeros(sDes);

for kf = 1:sS1(1)-w+1
    for kc = 1:sS1(2)-w+1
        % Transformadas de Fourier de las ventanas
        FS1 = fft2(S1(kf:kf+w-1,kc:kc+w-1));
        FS2 = fft2(S2(kf:kf+w-1,kc:kc+w-1));
        % Producto de las transformadas
        prodF = FS1.*conj(FS2);
        F = zeros(w);
        % F conserva el �ngulo de la transformada y su norma
        F(prodF ~=0) = prodF(prodF ~=0) ./ sqrt(abs(prodF(prodF ~=0)));
        % Halo function
        G = fft2(F);
        G = fftshift(G);
        % El paper propone sacar el m�ximo pero...
%        [val pos] = max(G(:));
        % Normalizo
        G = abs(G) / sum(abs(G(:)));
        % Ventaneo
        Wdow = hann(w)*hann(w)';
        Gw = Wdow.*G;
        % Saco la media de G como histograma.
        [X Y] = meshgrid(1:w,1:w);
        pos(1) = sum(sum(X.*G));
        pos(2) = sum(sum(Y.*G));
        % Guardo el vector de desplazamiento
%         Des((kf-1)/w+1,(kc-1)/w+1,:) = [rem(pos,w) ceil(pos/w)]; % esto vale si se sacara el m�ximo.      
        Des(kf,kc,:) = pos;
    end
end
Des(:,:,1) = Des(:,:,1) - (w+1)/2;
Des(:,:,2) = Des(:,:,2) - (w+1)/2;

quiver(Des(:,:,1),Des(:,:,2))