function UseMask(Carpeta1,Carpeta2,Carpeta3,Carpeta4,CarpetaDestino,N,L,Archmask)

extension = 'tif';
tipo = 'float32';
extension_out = 'tif';
tipo_out = [];

% Procesamiento de la máscara
Mask = imread(Archmask);
[list cant] = listar(Mask(:));
list = sort(list,'ascend');

Speckle = zeros(L);
barra = waitbar(0,'Creando los patrones de speckle...');
for k_k = 1:N
    waitbar(k_k/N)
    numero = num2str(k_k-1);
    
    nombre_arch = [Carpeta1 '0000'];
    nombre_arch(( end - length(numero)+1 ):end) = numero;
    nombre_arch = [nombre_arch '.' extension];
    if strcmp(extension,'dat')
        fid = fopen(nombre_arch,'rb');
        [im,count] = fread(fid,[L L],tipo);
        fclose(fid);
    else
        im = imread(nombre_arch,extension);
    end
    Speckle(Mask == list(1)) = im(Mask == list(1));

    
    nombre_arch = [Carpeta2 '0000'];
    nombre_arch(( end - length(numero)+1 ):end) = numero;
    nombre_arch = [nombre_arch '.' extension];
    if strcmp(extension,'dat')
        fid = fopen(nombre_arch,'rb');
        [im,count] = fread(fid,[L L],tipo);
        fclose(fid);
    else
        im = imread(nombre_arch,extension);
    end
    Speckle(Mask == list(2)) = im(Mask == list(2));

    nombre_arch = [Carpeta3 '0000'];
    nombre_arch(( end - length(numero)+1 ):end) = numero;
    nombre_arch = [nombre_arch '.' extension];
    if strcmp(extension,'dat')
        fid = fopen(nombre_arch,'rb');
        [im,count] = fread(fid,[L L],tipo);
        fclose(fid);
    else
        im = imread(nombre_arch,extension);
    end
    Speckle(Mask == list(3)) = im(Mask == list(3));
    
    nombre_arch = [Carpeta4 '0000'];
    nombre_arch(( end - length(numero)+1 ):end) = numero;
    nombre_arch = [nombre_arch '.' extension];
    if strcmp(extension,'dat')
        fid = fopen(nombre_arch,'rb');
        [im,count] = fread(fid,[L L],tipo);
        fclose(fid);
    else
        im = imread(nombre_arch,extension);
    end
    Speckle(Mask == list(4)) = im(Mask == list(4));
    
    nombre_arch = [CarpetaDestino '0000'];
    nombre_arch(( end - length(numero)+1 ):end) = numero;
    nombre_arch = [nombre_arch '.' extension_out];
    if strcmp(extension_out,'dat')
        fid = fopen(nombre_arch,'w');
        fwrite(fid,Speckle,tipo_out);
        fclose(fid);
    else
        imwrite(Speckle/255,nombre_arch,extension_out);
    end    
end
close(barra)