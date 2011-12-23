% Esta funci�n obtiene un vector con el �ndice de refracci�n necesario en
% el material de n�cleo para ciertos determinados valores de espesor del
% n�cleo.

function nNu = IndicesRefr(PhiNu,PhiBulk,h,nBulk,dBulk)

longOnda = 682.5e-9;
k0 = 2*pi/longOnda;

[rBulk tBulk] = MultiplesReflexiones(nBulk,dBulk);

theta = rBulk*PhiNu/PhiBulk*exp(-1i*k0*h);
nNu = (1-theta)./(1+theta);