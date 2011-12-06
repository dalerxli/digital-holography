function CGH = CGH_micro(M,NA,L,TamPixel)

% Methods of Fourier optics in digital holographic microscopy. F. Palacios
% M: magnificaci�n del MO
% NA: n�mero de apertura
% L: cantidad de pixeles en una de las dimensiones de la imagen
% TamPixel: Tama�o f�sico del pixel

% Onda en el plano objeto
% A: Amplitud de iluminaci�n del objeto
A = 1;
% lambda: longitud de onda
lambda = 682.5e-9;

x = linspace(-(L-1)/2*TamPixel,(L-1)/2*TamPixel,L);
[X Y] = meshgrid(x,x);

hcono = 1e-6;                    % Altura de un cono
acono = 4e-4;                    % Ancho del cono
m = hcono / acono;               % Pendiente de un cono
Forma = m*sqrt(X.^2+Y.^2)-hcono; % Forma de un cono
Forma(sqrt(X.^2+Y.^2)>acono) = 0;
Fase = A*exp(-1i*2*pi/lambda*Forma);
U0 = Fase;  % Si el MO es planacrom�tico entonces no presenta una transmisi�n esf�rica en la fase.
% De ac� tendr�a que pasar al plano de la imagen para poder sacar el
% resultado
O = U0; % provisorio

% Onda de referencia
% Ar: amplitud del haz de referencia
Ar = 1;
% thetamax: m�ximo �ngulo entre los haces de objeto y referencia
thetamax = lambda / 2 / TamPixel;
kx = cos((pi+thetamax)/2);
ky = kx;
R = Ar*exp(1i*2*pi/lambda*(kx*X+ky*Y));

CGH = R.*conj(R) + O.*conj(O) + conj(R).*O + R.*conj(O);