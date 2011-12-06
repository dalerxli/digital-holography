function mov = corrimiento(X,Y)

% % Opción mediante correlación sin sesgo
% Z = xcorr2(X-mean(X(:)),Y-mean(Y(:)));
% Mnorm = xcorr2(ones(size(X)),ones(size(Y)));
% Z = Z./Mnorm;

% Opción mediante transformada de Fourier
FX = fft2(X-mean(X(:)));
FY = conj(fft2(Y-mean(Y(:))));
Z = ifft2(FX.*FY);

% % Mutual Correlation Function
% FX = fft2(X);
% FY = conj(fft2(Y));
% Mut = FX.*FY;
% Mut = Mut ./ (sqrt(Mut)+0.001);
% Z = ifft2(Mut);
% Z = abs(Z);

Z = Z/sum(Z(:));
[x y] = size(Z);
vx = (0:x-1)-(x-1)/2;
vy = (0:y-1)-(y-1)/2;
[A B] = meshgrid(vx,vy);
mov(1) = sum(sum(A.*Z));
mov(2) = sum(sum(B.*Z));