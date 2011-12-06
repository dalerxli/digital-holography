function mov = PhaseCorrelationMethod(I1,I2,sub)
% Si el desplazamiento es mayor a la mitad del tama�o de la matriz menos 1,
% va a aparecer un resultado negativo.

if nargin == 2
    sub = 0;
end

% Take FFT of each image
F1 = fftshift(fft2(I1));
F2 = fftshift(fft2(I2));

% Create phase difference matrix
Z = exp(-1i*(angle(F1)-angle(F2)));

% Solve for phase correlation function
Z = ifft2(Z);
Z = real(Z);
Z = fftshift(Z);
Zabs = abs(Z);

% Ahora es cuesti�n de encontrar la ubicaci�n de la delta
[x y] = size(Z);
if rem(x,2)
    vx = -(x-1)/2 : (x-1)/2;
else
    vx = -x/2:(x/2)-1;
end
if rem(y,2)
    vy = -(y-1)/2 : (y-1)/2;
else
    vy = -y/2:(y/2)-1;
end

[C I] = max(Zabs(:));
I = I(1);
f = rem(I,x);
if f == 0
    f = x;
end
c = ceil(I/x);

mov = [0;0];
mov(1) = vy(f);
mov(2) = vx(c);

if sub == 1
    if f ~= x
        mov(1) = mov(1) + Z(f+1,c) / (Z(f+1,c) - Z(f,c));% - Z(f-1,c) / (Z(f-1,c) - Z(f,c));
    end
    if c ~= y
        mov(2) = mov(2) + Z(f,c+1) / (Z(f,c+1) - Z(f,c));% - Z(f,c-1) / (Z(f,c-1) + Z(f,c));
    end
end


% % Intento frustrado con la aplicaci�n de Least Squares. Si el corrimiento
% % es mayor a un pixel entonces va a notarse que la fase no es u*x0+v*y0
% % sino que es mod(u*x0+v*y0,2pi). Si en alg�n momento veo c�mo tener en
% % cuenta esta alinealidad para hacer el ajuste, podr�a ver de sacarle alg�n
% % provecho.
% Z = angle(F1)-angle(F2);
% [x y] = size(Z);
% if rem(x,2)
%     vx = -(x-1)/2 : (x-1)/2;
% else
%     vx = -x/2:(x/2)-1;
% end
% if rem(y,2)
%     vy = -(y-1)/2 : (y-1)/2;
% else
%     vy = -y/2:(y/2)-1;
% end
% vx = vx/max(vx)*pi;
% vy = vy/max(vy)*pi;
% [Xs Ys] = meshgrid(vx,vy);
% A = [Ys(:) Xs(:)];
% mov = inv(A'*A)*A'*Z(:) * 2;