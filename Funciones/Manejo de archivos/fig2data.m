% A = fig2data(filename)
%
%--------------------------------------------------------------------------
% Esta función toma un archivo .fig formado a partir de un image y obtiene
% la matriz con la que fue hecha la imagen.

function A = fig2data(filename)

structure = load(filename,'-mat');
A = structure.hgS_070000.children.children(1,1).properties.CData;