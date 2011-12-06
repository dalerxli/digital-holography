% d = errorDist(Abeizado,B)
%
% Funci�n que encuentra los errores entre A y B y calcula las distancias de
% los errores a las posiciones en B que s� toman los valores de A.

function d = errorDist(A,B)

mini = 15;

% Se detectan las posiciones de los errores
[Ferr Cerr] = find(A~=B);

% Se inicializa la salida de distancias
d = zeros(length(Ferr),1);

% C�lculo de m�scara auxiliar
s_B = size(B);
Mask = zeros(s_B*2-1);
[X,Y] = meshgrid(1:size(Mask,1));
X = X - X(s_B(1),s_B(2));
Y = Y - Y(s_B(1),s_B(2));
Mask = X.^2+Y.^2;
miniMask = Mask(s_B(1)-mini:s_B(1)+mini,s_B(2)-mini:s_B(2)+mini);

% Se inicializa la matriz de distancias
distancias = zeros(s_B);
miniDis = zeros(2*mini+1);

h = waitbar(0,'Procesando distancias...');

% Para cada error...
for k = 1:length(Ferr)
    miniB = B(max(1,Ferr(k)-mini):min(s_B(1),Ferr(k)+mini),max(1,Cerr(k)-mini):min(s_B(2),Cerr(k)+mini));
    if Ferr(k) > mini && Cerr(k) > mini && Ferr(k) < s_B(1)-mini && Cerr(k) < s_B(2) - mini
        miniDis = miniMask .* (miniB == A(Ferr(k),Cerr(k)));
        mayoresa0 = miniDis(miniDis>0);
        if ~isempty(mayoresa0)
            d(k) = min(mayoresa0(:));
        end
    end
    
    if d(k) == 0
        % Se aplica la m�scara debidamente shifteada en la matriz de
        % coincidencia de B con el valor del error
        distancias = Mask((s_B(1)-Ferr(k)+1):(2*s_B(1)-Ferr(k)),...
            (s_B(2)-Cerr(k)+1):(2*s_B(2)-Cerr(k))) .* (B == A(Ferr(k),Cerr(k)));
        % Se rescata la m�nima distancia
        d(k) = min(min(distancias(distancias>0)));
    end
    waitbar(k/length(Ferr))
end
    
close(h)