% function Des = desplazamientos(S1,S2,w,numflechas,ventaneo)
%
% La función calcula los vectores de desplazamiento de cada ventana de S1,
% teniendo en cuenta la imagen final S2. El parámetro w indica el ancho de
% la ventana utilizada para el cálculo. Se toma un valor de 9 como default.
% La cantidad de flechas mostradas es un vector que contiene el tamaño de
% la imagen de salida y puede ser elegida entre 1 y la cantidad de filas (o
% columnas) menos w, más 1.
% El ventaneo puede elegirse en 1 para ventanear con hanning los bloques.

function Des = desplazamientos(S1,S2,w,numflechas,ventaneo)

S1 = double(S1);
S2 = double(S2);

if isempty(w)
    w = 9;
end
if nargin < 5
    ventaneo = 0;
else
    % Ventaneo
    if rem(w,2) == 0
        hann1D = hann(w+1);
        hann1D = hann1D(1:w);
    else
        hann1D = hann(w);
    end
    Wdow = hann1D*hann1D';   
end

% Tamaï¿½o de las imï¿½genes
sS1 = size(S1);

% Inicializaciones
% Tamaï¿½o de la matriz de salida
sDesmax =  [sS1(1)-w+1 sS1(2)-w+1];
sDes = [numflechas 2];
sDes(find(numflechas > sDesmax)) = sDesmax(find(numflechas > sDesmax));
Des = zeros(sDes);
% Posiciones de las flechas
paso = floor(sDesmax ./ (sDes(1:2)-1));
restan = sDesmax - paso .* (sDes(1:2)-1);
posF = floor(restan(1)/2)+(1:paso(1):paso(1)*sDes(1));
posC = floor(restan(2)/2)+(1:paso(2):paso(2)*sDes(2));

% Para sacar la media de G como histograma.
[X Y] = meshgrid(1:w,1:w);
% Pre FOR
FS1 = zeros(w);
FS2 = FS1;
prodF = FS1;
F = FS1;
G = FS1;
pos = zeros(2,1);

fila = 1;
for kf = posF
    columna = 1;
    for kc = posC
        % Ventanas
        v1 = S1(kf:kf+w-1,kc:kc+w-1);
        v2 = S2(kf:kf+w-1,kc:kc+w-1);
        if ventaneo == 1
            v1 = v1.* Wdow;
            v2 = v2.* Wdow;
        end
        % Transformadas de Fourier de las ventanas
        FS1 = fft2(v1);
        FS2 = fft2(v2);
        % Producto de las transformadas
        prodF = FS1.*conj(FS2);
        F = zeros(w);
        % F conserva el ï¿½ngulo de la transformada y su norma
        F(prodF ~=0) = prodF(prodF ~=0) ./ sqrt(abs(prodF(prodF ~=0)));
        % Halo function
        G = ifft2(F); % El paper propone fft2
        G = fftshift(G);
%         G = fftshift(G);
        
        % Normalizo para sacar la media
        G = abs(G) / sum(abs(G(:)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        % El paper propone sacar el máximo pero da cualquier cosa
        % Busqueda del máximo
%         [Gmax I] = max(G(:));
%         pos(1) = rem(I,w);
%         pos(2) = ceil(I/w);

%         % Búsqueda del valor medio
        pos(1) = sum(sum(X.*G));
        pos(2) = sum(sum(Y.*G));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Guardo el vector de desplazamiento
%         Des((kf-1)/w+1,(kc-1)/w+1,:) = [rem(pos,w) ceil(pos/w)]; % esto vale si se sacara el mï¿½ximo.      
        Des(fila,columna,:) = pos;
        columna = columna + 1;
    end
    fila = fila + 1;
end
if ventaneo == 1
    Des(:,:,1) = Des(:,:,1) - ceil((w+1)/2);
    Des(:,:,2) = Des(:,:,2) - ceil((w+1)/2);
else
    Des(:,:,1) = Des(:,:,1) - (w+1)/2;
    Des(:,:,2) = Des(:,:,2) - (w+1)/2;
end

% Posiciones de las flechas
X = ceil((w+1)/2) : (sS1(1)-w+ceil((w+1)/2));
Y = ceil((w+1)/2) : (sS1(2)-w+ceil((w+1)/2));
X = X(posF);
Y = Y(posC);

h = figure;
quiver(Y,X,Des(:,:,1),Des(:,:,2))
ax = get(h,'CurrentAxes');
set(h,'Position',[1 27 1024 638])
axis image
set(ax,'XTick',[])
set(ax,'XTickLabel',{[]})
set(ax,'YTick',[])
set(ax,'YTickLabel',{[]})
axis([1 sS1(2) 1 sS1(1)])

% Valor medio y desvio
DesMed = [mean2(Des(:,:,1)) mean2(Des(:,:,2))]
DesSTD = [std2(Des(:,:,1)) std2(Des(:,:,2))]