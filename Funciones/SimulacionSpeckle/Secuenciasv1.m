function rhos = Secuenciasv1(emes,Nsec,Nsim,L)
% Obtiene $L$ im�genes de THSP de $L\times Nsec$ correspondientes a la
% secuencia de im�genes de speckle din�mico generadas con los valores de
% factor multiplicativo contenidos en el vector $m$. Devuelve los valores
% de coeficiente de correlaci�n secuencial $\rho_{k,k+1}$ estimados en
% secuencias de $Nsim$ im�genes. Esta funci�n obtiene la m�scara para la
% asignaci�n del factor multiplicativo $m$ de cada pixel a partir de la
% imagen que indica con colores el tipo de actividad de speckle esperado.
% Realiza dos llamados a funciones para generar archivos GIF con las
% im�genes de la secuencia y luego pasar las im�genes a THSP para facilitar
% el manejo de datos. 


TamGra = 2;
rhos = emes;

% Procesamiento de la m�scara
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
