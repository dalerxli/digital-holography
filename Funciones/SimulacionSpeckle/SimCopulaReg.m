%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Generación de patrones de speckle utilizando el método de Copula de
%   Kirkpatrik ("The copula: a tool for simulating speckle dynamics",
%   Opt. Soc. Am. A 25, 231-237, 2008)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SimCopulaReg(Mm,N,L,TamGra,CarpetaDestino)

k = 1:N;
r = 2*(cos(pi/2*(k-1)/(N-1))).^2-1;

D = L/TamGra;   % Diametro del círculo     

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

% Se crea una matriz de unos y ceros con el circulo central de tamaño D
Circulo = DistanciaAlCentro < D/2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Método FFT_H_IFFT, se llena la matriz completa con números complejos de
% norma 1 y fase aleatoria

minimo = 0;         % Intensidad mínima en todo el speckle
maximo = 0;         % Intensidad máxima en todo el speckle
X1 = rand(L);  % Primer vector aleatorio
X2 = rand(L);  % Segundo vector aleatorio
Z = zeros(L);  % Z tendrá los vectores resultantes de aplicar la eq 13
% Z es una variable aleatoria normal de media 0 y varianza 1.
Speckle = zeros(L); % Imágenes resultantes
barra = waitbar(0,'Creando los patrones de speckle...');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Se arma la secuencia de N imágenes
for k_k = 1:N
    waitbar(k_k/N)
    
    % Encuentro las variables aleatorias según la Cópula eq. 13 (pK)
    phi = atan(sqrt((1-r(k_k))/(1+r(k_k))));
    Z = sqrt(-2*log(X1)).*cos(2*pi*X2 + phi);
   
    % Percentil transformation
    mu=0;%mean2(Z);
    sigma=1;%std2(Z);    
    T = normcdf(Z,mu,sigma);
    
        Uf = exp(1i*T.*Mm*2*pi);
        Uf = fftshift(fft2(Uf));
        Uf = Uf.*Circulo;
        Speckle = abs(ifft2(fftshift(Uf))).^2;
        
    % Registro el minimo y el máximo para conservarlos por que el 0 y el 1 
    % de la salida de mat2gray debería ser el mismo para todas las imágenes
    % del cubo.
    minimo = min([minimo min(min(Speckle))]);
    maximo = max([maximo max(max(Speckle))]);

    % No sirven como captados por una cámara. Tienen demasiada resolución.
    % Pero necesito tener el mínimo y el máximo para poder guardarlos como
    % uint8.
    FileName = sprintf('%s%c%04d.dat',CarpetaDestino,97,k_k-1);
    fid = fopen(FileName,'w');
    fwrite(fid,Speckle,'float32');
    fclose(fid); 
end
close(barra)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A continuación lo guardo en escala de grises como sería captado por una
% cámara CCD.
% close all
dir_in = strcat(CarpetaDestino,'*.dat');
direc = dir(dir_in);
rho_Real = zeros(N,1);
rho_k_kmas1 = zeros(N-1,1);
resol = [L L];
for k_k=1:N
    % Leo el archivo temporal en float32
    archivo = strcat(CarpetaDestino,direc(k_k,1).name);
    fid = fopen(archivo,'rb');
    [im,count] = fread(fid,resol,'float32');
    fclose(fid);
    % Elimino el archivo temporal
    delete(archivo)
    
    % Escritura en disco
    FileName = sprintf('%s%04d.tif',CarpetaDestino,k_k-1);
    % El máximo lo multiplico por 0.5 porque más del 99% de las muestras no
    % superan a 0.5*máximo.
    imagen = uint8(mat2gray(im, [minimo maximo/2])*255);
	imwrite(imagen,FileName,'tif','Compression','none');
    
    % Calculo la correlación de la imagen con la primera del cubo
    if k_k == 1
        im1 = imagen;
        im_prev = imagen;
    else
        % Calculo la correlacion con la imagen anterior
        rho_k_kmas1(k_k-1) = corr2(im_prev,imagen);
        im_prev = imagen;
    end
    rho_Real(k_k) = corr2(im1,imagen);
    
end

% if N > 15
%     MeanRho = mean(rho_k_kmas1(15:end));
% end