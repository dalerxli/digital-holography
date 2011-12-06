% C = Filter2Mirror(filtro2D,A)
%
%   Esta función toma una imagen multidimensional A, le hace un mirror y
%   luego filtra.

function C = Filter2Mirror(filtro2D,A)

C =[];

sA = size(A);
if length(sA) < 3
    sA(3) = 1;
end
sF = size(filtro2D);
if rem(sF(1),2) == 0 || rem(sF(2),2) == 0
    disp('El filtro debe tener una cantidad de filas y columnas impares.')
    return
end
    
newA = zeros(sA(1)+sF(1)-1,sA(2)+sF(2)-1,sA(3));
rankFilEjs = (sF(1)-1)/2+(1:sA(1));
rankColEjs = (sF(2)-1)/2+(1:sA(2));
newA(rankFilEjs,rankColEjs,:) = A;
newA(1:(sF(1)-1)/2,:,:) = newA(sF(1):-1:(sF(1)+3)/2,:,:);
newA(:,1:(sF(2)-1)/2,:) = newA(:,sF(2):-1:(sF(2)+3)/2,:);
newA(end-(sF(1)-3)/2:end,:,:) = newA(end-(sF(1)+1)/2:-1:end-sF(1)+1,:,:);
newA(:,end-(sF(2)-3)/2:end,:) = newA(:,end-(sF(2)+1)/2:-1:end-sF(2)+1,:);

C = zeros(sA);

for k_imagen = 1:sA(3)
    C(:,:,k_imagen) = filter2(filtro2D,newA(:,:,k_imagen),'valid');
end