% FormatIm(numfigura)
%
% Esta funci�n formatea una imagen y abre un cuadro de di�logo para
% guardarla. Hay que indicarle el n�mero de la figura.
function FormatIm(numfigura,nombre,carpeta)


if nargin == 1
    DefaultName = 'FILENAME.fig';%windows
else
    if length(nombre) > 4
        if ~strcmpi(nombre(end-3:end),'.fig')
            DefaultName = [nombre '.fig'];
        end
    end
end
if nargin < 3
    [FileName,PathName,FilterIndex] = uiputfile({'*.fig';'*.jpeg'},'Guardar Imagen...',DefaultName);
else
    FileName = nombre;
    if carpeta(end) ~= '\'
        carpeta = [carpeta '\'];
    end
    PathName = carpeta;
end
% DefaultName = '/media/Datos/Speckle/Columnas/Imagenes/Mask1/FCMdb1FPB 6 a
% 6c75.fig';%linux
h = figure(numfigura);

ax = get(h,'CurrentAxes');
set(h,'Position',[1 27 1024 638])
axis image
set(ax,'XTick',[])
set(ax,'XTickLabel',{[]})
set(ax,'YTick',[])
set(ax,'YTickLabel',{[]})
title([])

if FileName ~=0
    saveas(ax,[PathName FileName])
end