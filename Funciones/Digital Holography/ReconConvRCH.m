% Reconstrucción por convolución y usando un RCH (reference conjugated
% hologram)
% Ref: Total aberrations compensation in digital holographic microscopy
% with a reference conjugated hologram. 2006
% archivo: nombre del archivo de holograma
% RCH: nombre del archivo .mat con el RCH calculado con setRCH()
% [z]: distancia de reconstrución
% [filtro]: vector que contiene las coordenadas del centro y el diámetro
% del filtro utilizado para conservar la imagen virtual
% [apo]: poner en 1 para realizar la apodización

function [Fase Amplitud] = ReconConvRCH(archivo,RCH,z,filtro,apo,typeFilter)

% Se leen los hologramas
H = imread(archivo);
H = double(H);
[M N] = size(H);

% Quitar orden cero
% Href = imread('D:\Hologramas\20110214\HologramRef.tif');
% Href = double(Href);
load Href
H = ZeroOrderSuppression(H,Href,filtro);

%%% DATOS DEL DHM
% Longitud de onda del laser
lambda = 682.5e-9;

% Distancia a la imagen
if nargin < 3
    z = 3.5e-2;
else
    z = -z*1e-2; % Esto es para que lo que entre vaya en centímetros
end

%%% ALGORITMO

% Conviene apodizar
if nargin > 4
    if apo == 1
        H = apodizer(H,1/12);
    end
end

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

if nargin < 4
    % Se dibuja el espectro del holograma
    imagesc(log10(abs(FH)))
    % Se busca conservar la imagen virtual
    centro(1) = input('Pixel central de la porción conservada: x: ');
    centro(2) = input('y: ');
    if input('[S] Star - [C] Circulo: ','s') == 'S'
        banda = input('Ancho de la banda dejada para las frecuencias altas.');
    else
        diametro = input('Diámetro de la porción conservada: ');
    end
else
    centro = filtro(1:2);
    diametro = filtro(3);
end

if ~exist('typeFilter','var')
    typeFilter = 0;
end
if strcmp(typeFilter,'Star')
    % Se arma el círculo alrededor del centro de una imagen reducida al cuarto
    % del tamaño original
    [X Y] = meshgrid((1:N/2),(1:M/2));
    minimaskFFT = sqrt((X-(N/4+0.5)).^2 + (Y-(M/4+0.5)).^2);
    minimaskFFT = minimaskFFT >= (M/4-ceil(diametro/2));
    % Se fftshiftea
    minimaskFFT = fftshift(minimaskFFT);
    % Se ubica al centro de la imagen total
    maskFFT = zeros(M,N);
    maskFFT(M/4+1:3*M/4,N/4+1:3*N/4) = minimaskFFT;
    % Se extienden las bandas
    v = find(maskFFT(M/4+1,:)==1);
    maskFFT(:,v) = 1;
    v = find(maskFFT(:,N/4+1)==1);
    maskFFT(v,:) = 1;
    % Se corre al centro indicado por la entrada
    maskFFT = circshift(maskFFT,[centro(2)-M/2-1 centro(1)-N/2-1]);
else
    % Se arma el círculo alrededor del centro
    [X Y] = meshgrid(-N/2:N/2-1,-M/2:M/2-1);
    maskFFT = sqrt(X.^2 + Y.^2);
    maskFFT = maskFFT < diametro;
    maskFFT = circshift(maskFFT,[centro(2)-M/2-1 centro(1)-N/2-1]);
end

% Se aplica el filtro a los dos hologramas
FHfilt = FH .* maskFFT;
Hfilt = ifft2(fftshift(FHfilt));

load(RCH);

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