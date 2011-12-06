% Iout = LSCI(Iin,V)
%
% Obtención de una imagen de contraste espacial de una imagen de intensidad
% integrada en tiempo.

function Iout = LSCI(Iin,V)

Iin = double(Iin);
[F C] = size(Iin);
Iout = zeros(F-V+1,C-V+1);

for kf = 1:F-V+1
    for kc = 1:C-V+1
        v = Iin(kf:kf+V-1,kc:kc+V-1);
        Iout(kf,kc) = std(v(:))/mean(v(:));
    end
end