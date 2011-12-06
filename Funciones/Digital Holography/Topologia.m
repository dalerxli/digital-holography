% Se restan dos imágenes de fases reconstruidas con valores entre -180 y
% 180.

function resta = Topologia(I1,I2)

resta = npi2pi(I1-I2);
media = angle(mean(exp(1i*resta(:)*pi/180)))*180/pi;
resta = npi2pi(resta-media);