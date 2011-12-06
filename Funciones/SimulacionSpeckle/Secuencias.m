function rhos = Secuencias(emes,Nsec,Nsim,L)

TamGra = 2;
k = 1:Nsec;
rhos = zeros(4,1);
r = 2*(cos(pi/2*(k-1)/(Nsec-1))).^2-1;

%% Secuencias individuales

% Background
Carpeta1 = 'SimsOSA\m1\';
rhos(1) = SimCopula(r,emes(1),Nsec,L,TamGra,Carpeta1);

% 1st spot
Carpeta2 = 'SimsOSA\m2\';
rhos(2) = SimCopula(r,emes(2),Nsec,L,TamGra,Carpeta2);

% 2nd spot
Carpeta3 = 'SimsOSA\m3\';
rhos(3) = SimCopula(r,emes(3),Nsec,L,TamGra,Carpeta3);

% 3rd spot
Carpeta4 = 'SimsOSA\m4\';
rhos(4) = SimCopula(r,emes(4),Nsec,L,TamGra,Carpeta4);

%% Uso de la máscara

CarpetaM = 'SimsOSA\Mask\';
mask = 'Mask1/mask.bmp';
UseMask(Carpeta1,Carpeta2,Carpeta3,Carpeta4,CarpetaM,Nsim,L,mask);

%% Armado de THSPs

CarpetaMCol = 'SimsOSA\MaskCol\';
delete([CarpetaMCol '*.*'])
ACol(CarpetaM,CarpetaMCol,L,Nsim)
