function rhos = Secuenciasv1(emes,Nsec,Nsim,L)
% Obtiene $L$ imágenes de THSP de $L\times Nsec$ correspondientes a la
% secuencia de imágenes de speckle dinámico generadas con los valores de
% factor multiplicativo contenidos en el vector $m$. Devuelve los valores
% de coeficiente de correlación secuencial $\rho_{k,k+1}$ estimados en
% secuencias de $Nsim$ imágenes. Esta función obtiene la máscara para la
% asignación del factor multiplicativo $m$ de cada pixel a partir de la
% imagen que indica con colores el tipo de actividad de speckle esperado.
% Realiza dos llamados a funciones para generar archivos GIF con las
% imágenes de la secuencia y luego pasar las imágenes a THSP para facilitar
% el manejo de datos. 


TamGra = 2;
rhos = emes;

% Procesamiento de la máscara
Mask = imread('Mask1/mask.bmp');
[list cant] = listar(Mask(:));
list = sort(list,'ascend');

Mm = zeros(L);

if length(list)~= length(emes)
    disp('La cantidad de actividades requeridas es distinta a la que presenta la mascara.')
    return
end

for m = 1:length(list)
    Mm(Mask==list(m)) = emes(m);
end
CarpetaM = 'SimsOSA\Mask\';
SimCopulaReg(Mm,Nsec,L,TamGra,CarpetaM);

%% Armado de THSPs

CarpetaMCol = 'SimsOSA\MaskCol\';
delete([CarpetaMCol '*.*'])
ACol(CarpetaM,CarpetaMCol,L,Nsim)
