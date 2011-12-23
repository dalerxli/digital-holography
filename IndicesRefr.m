% Esta función obtiene un vector con el índice de refracción necesario en
% el material de núcleo para ciertos determinados valores de espesor del
% núcleo.

function nNu = IndicesRefr(PhiNu,PhiBulk,h,nBulk,dBulk)

longOnda = 682.5e-9;
k0 = 2*pi/longOnda;

[rBulk tBulk] = MultiplesReflexiones(nBulk,dBulk);

theta = rBulk*PhiNu/PhiBulk*exp(-1i*k0*h);
nNu = (1-theta)./(1+theta);