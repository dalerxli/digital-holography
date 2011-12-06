% Función que deja guardado el archivo RCH.mat que contiene el holograma de
% referencia

function setRCH(Imref,filtro)

Href = imread(Imref);
Href = double(Href);
[M N] = size(Href);
FHref = fftshift(fft2(Href));

centro = filtro(1:2);
diametro = filtro(3);

% Se arma el círculo alrededor del centro de una imagen reducida al cuarto
% del tamaño original
[X Y] = meshgrid((1:M)-centro(1),(1:N)-centro(2));
maskFFT = sqrt(X.^2 + Y.^2);
maskFFT = maskFFT < diametro;

FHfilt = FHref .* maskFFT;
Hreffilt = ifft2(fftshift(FHfilt));

% RCH
RCH = Hreffilt ./ abs(Hreffilt);
RCH = conj(RCH);

save RCH RCH