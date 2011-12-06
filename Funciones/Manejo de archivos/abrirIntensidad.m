% [I dx] = abrirIntensidad(archivo)
%
% Función que abre un archivo txt de información de fases que tira el DHM y
% obtiene la imagen de fases, el tamaño del pixel y el height conversion
% factor. El dx está en micrómetros. Si no se informa en la
% entrada que se quiere en fase o altura, viene en fase entre (-pi y pi).
% Si se pide en fase, va entre -180 y 180. Si se pide en altura, sale en
% micrómetros.

function [I dx] = abrirIntensidad(archivo)

% Se abre el archivo en modo lectura
fid = fopen(archivo,'r');

% Se lee el tamaño de la imagen
linea = fgetl(fid);
s = textscan(linea, '%c %n %s %n', 'delimiter', '=');
M = s{2};
N = s{4};

% Se lee el tamaño del pixel en micrómetros
linea = fgetl(fid);
s = textscan(linea, '%s %n %s', 'delimiter', '=');
dx = s{2} * 1e-6;

% Se obtienen los datos
I = zeros(M,N);
s = textscan(fid,'%n');
I(:) = s{1};

% Se cierra el archivo
fclose(fid);