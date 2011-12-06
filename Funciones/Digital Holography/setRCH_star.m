% Función que deja guardado el archivo RCH.mat que contiene el holograma de
% referencia

function setRCH_star(Imref,filtro)

Href = imread(Imref);
Href = double(Href);
[M N] = size(Href);
FHref = fftshift(fft2(Href));

centro = filtro(1:2);
banda = filtro(3);

% Se arma el círculo alrededor del centro de una imagen reducida al cuarto
% del tamaño original
[X Y] = meshgrid((1:N/2),(1:M/2));
minimaskFFT = sqrt((X-(N/4+1)).^2 + (Y-(M/4+1)).^2);
minimaskFFT = minimaskFFT >= (M/4-ceil(banda/2));
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

FHfilt = FHref .* maskFFT;
Hreffilt = ifft2(fftshift(FHfilt));

% RCH
RCH = Hreffilt ./ abs(Hreffilt);
RCH = conj(RCH);

save RCH RCH