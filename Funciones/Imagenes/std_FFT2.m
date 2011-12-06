% Esta función obtiene el desvío que tiene la transformada de Fourier de
% una imagen.

function std = std_FFT2(I)

[M N] = size(I);
FI = fftshift(fft2(I));
aFI = abs(FI);
aFI = aFI/sum(aFI(:));

if rem(M,2)
    vecM = -(M+1)/2:(M-1)/2;
else
    vecM = -M/2:M/2-1;
end
if rem(N,2)
    vecN = -(N+1)/2:(N-1)/2;
else
    vecN = -N/2:N/2-1;
end
[X Y] = meshgrid(vecN,vecM);

XY = [X(:) Y(:)];

med = sum(XY .* [aFI(:) aFI(:)]);

std(1) = sqrt(sum((X(1,:)-med(1)).^2 .*sum(aFI)));
std(2) = sqrt(sum((Y(:,1)-med(2)).^2 .*sum(aFI,2)));

% XYmed2 = [X(:)-med(1) Y(:)-med(2)];
% XYmed2 = XYmed2.^2;
% 
% std = sum(XYmed2 .* [aFI aFI]);