clear all

% Abro la imagen
I1 = imread('D:\Hologramas\20111121\Hologram100SinFilt.tif');
% Saco contraste
cont = @(x)std(x(:))/mean(x(:));
C1 = blkproc(double(I1),[8 8],[4 4],cont);
C1 = C1(2:end-1,2:end-1);
[M N] = size(C1);
[X Y] = meshgrid(1:M,1:N);

% % Planteo el modelo de una gaussiana para darme una idea de los valores que
% % tiene que tomar el resultado
% x0 = 0;
% y0 = 0;
% c1 = .0001;
% c2 = .000001;
% c3 = .0001;
% P = exp(-(c1*(X-x0).^2+2*c2*(Y-y0).*(X-x0)+c3*(Y-y0).^2));

% Hago un primer fitting para ver cuáles tengo que tomar como outliers
X = X(:); Y = Y(:);
C1 = double(C1(:));
ft = fittype( 'a + b*exp(-((x-x0)^2*c+2*d*(x-x0)*(y-y0)+e*(y-y0)^2))', 'indep', {'x', 'y'}, 'depend', 'z' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [0 0 0 -1 0 -200 -200];
opts.StartPoint = [0.04 .6 0.002 -0.002 .002 -20 -20];
opts.Upper = [10 10 1 1 1 200 200];
opts.Weights = zeros(1,0);
[fitresult, gof] = fit( [X, Y], C1, ft, opts );

% Encuentro a los outliers como los que tienen más error que un valor dado
ToleranciaOutlier = 0.07;
H = zeros(M,N);
H(:) = fitresult(X,Y);
C = zeros(M,N);
C(:) = C1;
errores = abs(H-C);
Indices = find(errores > ToleranciaOutlier);

% Vuelvo a hacer el fitting
ex = excludedata( X, Y, 'Indices', Indices );
opts.Exclude = ex;
[fitresult, gof] = fit( [X, Y], C1, ft, opts );

% h = plot( fitresult, [X, Y], C1, 'Exclude', ex );

ICov = [fitresult.c fitresult.d; fitresult.d fitresult.e];
Cov = inv(ICov);
[V D] = eig(Cov);
[CC In] = min(diag(D));
V = V(:,In);
D = D(In,In);

deltax = 6.45e-6;
sigmaC = sqrt(D(1))*deltax;
% Longitud de coherencia
Lc = 2*sigmaC*sqrt(2*log(2));

% Tengo que encontrar la distancia en z que representa el sigma de
% correlación temporal. Para esto, saco el módulo del vector de frecuencias
% de la densidad espectral de la imagen en el holograma. Ese módulo indica
% el ángulo de inclinación del haz de referencia. Conocienco ese ángulo se
% encuentra la distancia de correlación.
I1 = double(I1);
[M N] = size(I1);
fI = fft2(I1);
fI = fftshift(fI);
ini = fix(2/3*M);
fils = M-ini+1;
[C Ind] = max(abs(reshape(fI(:,ini:M),fils*N,1)));
pmax(1) = ini + floor(Ind/N);
pmax(2) = rem(Ind,N);
pmedio = floor([M N]/2)+1;
kxy = 2*pi*(pmax-pmedio)/N/deltax;

% k = k0*(cos(theta)*cos(phi)*xv+cos(theta)*sin(phi)*yv+sin(theta)*zv)
k0 = 2*pi/682.5e-9;
phi = atan(kxy(2)/kxy(1));
theta = acos(kxy(1)/k0/cos(phi));

% La distancia que debe recorrer el frente de onda para llegar desde el
% centro de interferencia al punto (x,y)

d = kxy*sigmaC*V/norm(kxy)
tc = d/3e8
DeltaLambda = (682.5e-9)^2/d