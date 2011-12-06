% [I a b] = abrirScanning(archivo)
%
% Función que abre un archivo bin de información de altura que tira el DHM, 
% obtiene la imagen de alturas.

function [I a b] = abrirScanning(archivo)

% Se abre el archivo en modo lectura
fid = fopen(archivo,'r');

a = fread(fid,1,'uint16');
b = fread(fid,1,'uint32');

% Se lee el tamaño de la imagen
M = fread(fid,1,'uint32');
N = fread(fid,1,'uint32');

c = fread(fid,1,'uint8');

% Se obtienen los datos
I = zeros(M,N);
I(:) = fread(fid,M*N,'float32');
I = I';

% Se cierra el archivo
fclose(fid);