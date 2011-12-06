function X = AVectorFilt(Ejs,tamQuad,ventana)

s_Ejs = size(Ejs);

% Filtrado
% Filtro2D = zeros(tamQuad);
% Centro = (tamQuad+1)/2;
% for k_fil = 1:tamQuad
%     for k_col = 1:tamQuad
%         D = sqrt((k_fil-Centro)^2+(k_col-Centro)^2);
%         if D <= Centro-0.5
%             % Hanning
%             Filtro2D(k_fil,k_col) = 0.5*(1+cos(2*pi*D/tamQuad));
%         end
%     end
% end

% win = rectwin(tamQuad);
if isnumeric(ventana)
    win = zeros(tamQuad,1);
    win(1:length(ventana)) = ventana;
else
    eval(['win = window(' ventana ',tamQuad);']);
end
Filtro2D = repmat(win,1,tamQuad).*repmat(win',tamQuad,1);
Filtro2D = Filtro2D / norm(Filtro2D);

Out = zeros(s_Ejs(1)-tamQuad+1,s_Ejs(2)-tamQuad+1,s_Ejs(3),s_Ejs(4));
for k_bloque = 1:s_Ejs(3)
    for k_esc = 1:s_Ejs(4)
        Out(:,:,k_bloque,k_esc) = filter2(Filtro2D,Ejs(:,:,k_bloque,k_esc),'valid');
    end
end
Out = permute(Out,[3 4 1 2]);
X = Out(:,:,:);
X = permute(X,[3,2,1]);