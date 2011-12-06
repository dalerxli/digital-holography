% Reconstrucción por convolución y usando un RCH (reference conjugated
% hologram)
% Ref: Total aberrations compensation in digital holographic microscopy
% with a reference conjugated hologram. 2006

function [Fase Amplitud] = reconstruccionConv(archivo,z,filtro,Imref)

% Se leen los hologramas
H = imread(archivo);
H = double(H);
H = apodizer(H);
Href = imread(Imref);
Href = double(Href);
[M N] = size(H);

%%% DATOS DEL DHM
% Longitud de onda del laser
lambda = 682.5e-9;

% Distancia a la imagen
if nargin < 2
    z = 3.5e-2;
else
    z = z*1e-2; % Esto es para que lo que entre vaya en centímetros
end

%%% ALGORITMO

if rem(M,2)
    vecM = -(M+1)/2:(M-1)/2;
else
    vecM = -M/2:M/2-1;
end
if rem(N,2)
    vecN = -(N+1)/2:(N-1)/2;
else
    vecN = -N/2:N/2-1;
end

% FFT del holograma con la modulante
FH = fftshift(fft2(H));
FHref = fftshift(fft2(Href));

if nargin < 3
    % Se dibuja el espectro del holograma
    imagesc(log10(abs(FH)))
    
    % Se busca conservar la imagen real
    centro(1) = input('Pixel central de la porción conservada: x: ');
    centro(2) = input('y: ');
    diametro = input('Diámetro de la porción conservada: ');
else
    centro = filtro(1:2);
    diametro = filtro(3);
end

% Se arma el círculo alrededor del centro
[X Y] = meshgrid((1:N)-centro(1),(1:M)-centro(2));
maskFFT = sqrt(X.^2 + Y.^2);
maskFFT = maskFFT < diametro;

% Se aplica el filtro a los dos hologramas
FHfilt = FH .* maskFFT;
Hfilt = ifft2(fftshift(FHfilt));
FHfilt = FHref .* maskFFT;
Hreffilt = ifft2(fftshift(FHfilt));

% RCH
RCH = Hreffilt ./ abs(Hreffilt);
RCH = conj(RCH);

[X Y] = meshgrid(vecN,vecM);
L = M*6.45e-6; % largo de la CCD
U2 = (X/L).^2;
V2 = (Y/L).^2;

%%% Propagación por convolución

% Primer paso
FIRd = fftshift(fft2(Hfilt.*RCH));

% Kernel
kernel = exp(-1i*pi*lambda*z*(U2+V2));

% Constante (No es necesaria porque pone lo mismo a todos los pixeles)
A = exp(1i*2*pi*z/lambda) / (1i*lambda*z);

% Segundo paso
Psi = A .* ifft2(fftshift(FIRd.*kernel));

Fase = angle(Psi);

Amplitud = abs(Psi);