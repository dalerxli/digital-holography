% [z x N] = abrirPerfil(archivo)
%
% Función que toma un txt de perfil obtenido por el DHM y lo guarda en
% variables. 'z' es la altura relativa de la muestra en nanómetros y 'x' es
% la distancia en micrómetros. N es la cantidad de muestras en el perfil.

function [z x N] = abrirPerfil(archivo)

% Se abre el archivo en modo lectura
fid = fopen(archivo,'r');

% Se lee el tamaño del perfil
linea = fgetl(fid);
s = textscan(linea, '%n %s %s');
N = s{1};

% Se obtienen los datos
s = textscan(fid,'%n %n');
z = s{2};
x = s{1};

% Se cierra el archivo
fclose(fid);