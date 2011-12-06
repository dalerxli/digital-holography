function thsp = THSP_col(carpeta,extension,resol,columna,arch1,archend)
% Calculo del THSP (time history of speckle pattern) 
% Se conocerá la progresion en el tiempo de una imagen de speckle. 
% Si la cantidad de archivos es mayor a 'sep' entonces se ubicarán los
% valores en columnas contiguas para los bloques de tiempo.

dir_in1 = strcat(carpeta,'\');
dir_in = strcat(dir_in1,'*.',extension);
direc = dir(dir_in);
thsp = zeros(resol(1),length(columna),min(length(direc),archend)-arch1+1);
if all(extension == 'dat') && nargin == 4
    resol(1) = input('Indique la resolución de la imagen:\n Filas: ');
    resol(2) = input(' Columnas: ');
end
for i=arch1:(min(length(direc),archend))
    archivo = strcat(dir_in1,direc(i,1).name);
    if strcmp(extension,'dat')
        fid = fopen(archivo,'rb');
        [im,count] = fread(fid,resol,'uchar');
        fclose(fid);
    else
        im = imread(archivo);
    end
    thsp(:,:,i-arch1+1) = double(im(:,columna));
end
