function thsp = PeliIms(Carpeta,extension,resol,intervalo)
if Carpeta(end) ~= '\'
   Carpeta(end+1) = '\';
end
dir_in = strcat(Carpeta,'*.',extension);   
direc = dir(dir_in);
N = length(direc);

archivo = strcat(Carpeta,direc(1,1).name);
if ~strcmp(extension,'dat')
    imagen = imread(archivo,extension);
    resol = size(imagen);
    L = resol(1);
end
    
thsp = uint8(zeros(L,N));
kp = 1;

for k_k=1:intervalo:N
    NumArch = k_k;
    archivo = strcat(Carpeta,direc(NumArch,1).name);
    if strcmp(extension,'dat')
        fid = fopen(archivo,'r');
        imagen = fread(fid,resol,'float32'); % Si están normalizados se va a tener que usar float32
        fclose(fid);
    else
        imagen = imread(archivo,extension);
    end    
    im(:,:,kp) = imagen;    % Calculo la correlación de la imagen con la primera del cubo
    thsp(:,kp) = imagen(:,ceil(resol(2)/2));
    kp = kp + 1;
end
% map = colormap('gray');
im = uint8(im);
im = permute(im, [1 2 4 3]);
imwrite(im,[Carpeta 'peli.gif'],'DelayTime',0.05,'LoopCount',inf);

imwrite(thsp,'THSP.gif');
