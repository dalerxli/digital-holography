% X = AVectorFiltFull(Ejs,tamQuad,ventana)
%
%   Esta función arma un filtro 2D a partir de una ventana de longitud
%   TamQuad y aplica un filtrado de Ejs espejado. De esta manera no se
%   pierden valores de la imagen. Posteriormente se pasa la matriz a vector
%   resultando una matriz donde cada columna es la salida del filtro para
%   distintas matrices de entrada en Ejs (escalas).

function X = AVectorFiltFull(Ejs,tamQuad,ventana)

if size(Ejs,4) > 1
    Ejs = permute(Ejs,[1 2 4 3]);
end
s_Ejs = size(Ejs);
if length(s_Ejs)==3
    s_Ejs(4) = 1;
end

% Se arma el filtro
if isnumeric(ventana)
    win = zeros(tamQuad,1);
    win(1:length(ventana)) = ventana;
else
    eval(['win = window(' ventana ',tamQuad);']);
end
Filtro2D = repmat(win,1,tamQuad).*repmat(win',tamQuad,1);
Filtro2D = Filtro2D / norm(Filtro2D);

% Se filtra
Out = zeros(s_Ejs);
for k_bloque = 1:s_Ejs(4)    
    Out(:,:,:,k_bloque) = Filter2Mirror(Filtro2D,Ejs(:,:,:,k_bloque));
end

% Se pasa a vector
Out = permute(Out,[4 3 1 2]);
X = Out(:,:,:);
X = permute(X,[3,2,1]);