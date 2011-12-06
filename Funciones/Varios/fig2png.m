% Cambiadas = fig2png(directorio) muestra la cantidad de imágenes cambiadas

function Cambiadas = fig2png(directorio)
close all
if (directorio(end) ~='\') || (directorio(end) ~='/')
    directorio(end+1) = '\';
end
direc = dir([directorio '*.fig']);
for k = 1:length(direc)
    open([directorio direc(k,1).name]);
    colormap('hot')
    h = figure(1);
    ax = get(h,'CurrentAxes');
    newname = direc(k,1).name;
    newname(end-2:end) = 'png';
    saveas(ax,[directorio newname]);
    close all
end
Cambiadas = length(direc);