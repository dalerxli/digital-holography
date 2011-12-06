function h = EspesorNucleo(PhiNu,PhiBulk,nNu,nBulk,dBulk)

longOnda = 680e-9;
k0 = 2*pi/longOnda;

[rBulk tBulk] = MultiplesReflexiones(nBulk,dBulk);

rNu = (1-nNu)/(1+nNu);

h = 1/(1i*2*k0)*log(PhiBulk./PhiNu*rNu/rBulk);