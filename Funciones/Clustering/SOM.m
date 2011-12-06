%%% Esta funci�n toma una imagen multidimensional, la filtra con el
% criterio de obtener objetos del tama�o que uno espera tener y luego usa
% una red auto-organizada para encontrar Clusteres. Se usa una topolog�a
% lineal para poder despu�s asignar m�s f�cilmente un valor al resultado.
% Las salidas son las asignaciones de cl�ster de los vectores que conforman
% la imagen (idx), los centros de cl�ster o pesos de entrada (C) y la
% matriz X que contiene en sus filas los vectores filtrados.

% Es conveniente que las energ�as pasen por un log10 si no se usan todas
% las escalas de la wavelet energy

function [imagenclus C X betaCl ContrasteCl] = SOM(Entrada,tamQuad,Clusters,plotear,epocas)

s_E = size(Entrada);
Neuronas = Clusters;

% Filtro 2D
% [Lo_D Hi_D Lo_R Hi_R] = wfilters(['db' num2str(ceil(tamQuad/2-1))]);
X = AVectorFiltFull(permute(Entrada,[1 2 4 3]),tamQuad,'@chebwin');

dimF = s_E(3);
cantMuestras = s_E(1)*s_E(2);

%%% Creaci�n de la red neuronal

net = newsom(X',[1 Neuronas]);
net.trainParam.epochs = epocas;
% net.inputWeights{1,1}.learnParam.steps = 5;
% net.trainFcn = 'trainr';
% net.inputWeights{1,1}.learnFcn = 'learnsom';
% net.layerWeights{1,1}.learnFcn = 'learnsom';
net = train(net,X');
idx = sim(net,X');
[idx J] = find(idx==1);
C = net.IW;
C = C{1};

imagenclus = zeros(s_E(1),s_E(2));
imagenclus(:) = idx(:);

%%% Ploteo

if (nargin > 3) && (plotear)
%     % Se encuentra el m�nimo de cada fila en C, la escala de menor potencia
%     % en cada centroide y se resta para que quede C_ord todo positivo.
%     C_ord = C-repmat(min(C,[],2),1,dimF);
%     C_ord = C_ord./repmat(sum(C_ord,2),1,dimF);
%     for k_cluster = 1:Neuronas
%         mayoresQcero = C_ord(k_cluster,find(C_ord(k_cluster,:)>0));
%         fC(k_cluster) = -sum(mayoresQcero.*log2(mayoresQcero),2);
%     end

% % Esto funciona si se entra con algo a lo que se le sac� el log10
%     C_ord = 10.^C;
%     C_ord = C_ord ./ repmat(sum(C_ord,2),1,dimF);
%     fC = -sum(C_ord.*log2(C_ord),2);

% Se multiplica por -1 a los n�meros negativos de energ�a relativa en dBs y
% luego se escala para que sumen 1 para poder calcular la entrop�a
    C_ord = -C;
    C_ord = C_ord./repmat(sum(C_ord,2),1,dimF);
    for k_cluster = 1:Neuronas
        mayoresQcero = C_ord(k_cluster,find(C_ord(k_cluster,:)>0));
        fC(k_cluster) = -sum(mayoresQcero.*log2(mayoresQcero),2);
    end

%     [B Ind] = sort(fC);
%     idx = Ind(idx);

    imagenclus=fC(imagenclus);
    figure;
    imagesc(imagenclus);
    title('Resultado del clustering.')
    figure;
    plot(C')
    
    %%
    % Para el caso de cuartos esto calcula un factor de acierto
    cuad = imagenclus(1:200,1:200);
    V(1)=mean(mean(cuad));
    Cont(1) = mean(mean(stdfilt(cuad,NHOOD_STD)))/V(1);
    cuad = imagenclus(end-200:end,1:200);
    V(2)=mean(mean(cuad));
    Cont(2) = mean(mean(stdfilt(cuad,NHOOD_STD)))/V(2);
    cuad = imagenclus(1:200,end-200:end);
    V(3)=mean(mean(cuad));
    Cont(3) = mean(mean(stdfilt(cuad,NHOOD_STD)))/V(3);
    cuad = imagenclus(end-200:end,end-200:end);
    V(4)=mean(mean(cuad));
    Cont(4) = mean(mean(stdfilt(cuad,NHOOD_STD)))/V(4);
    ContrasteCl = mean(Cont);


    p=diff(V); % Para analizar las diferencias, pasa que esto no considera el
    % % contraste en el vector, s�lo las diferencias.

    % p=p/sum(p);
    % betaLASCA = -sum(p.*log2(p))/log2(3) % Enfoque de entrop�a m�xima, no
    % considera al vector de correlaci�n real.

%     p = V / sum(V);

%     rkkmas1 = [0.7520 0.7417 0.7327 0.7239];
    rkkmas1 = [0.7495 0.7151 0.6779 0.6375];
%     rkkmas1 = [0.9964 0.9949 0.9931 0.9911];

    % Enfoque por factor de correlaci�n entre vectores
    drkkmas1 = diff(rkkmas1) / norm(diff(rkkmas1));
    betaCl = abs(drkkmas1*p' / norm(p));

    % Enfoque de divergencia de Kullback Leibler
%     pkkmas1 = rkkmas1 / sum(rkkmas1);
%     betaCl = sum(pkkmas1 .* log2(pkkmas1./p));
    figure, plot(p' / norm(p)), hold on, plot(drkkmas1,'r')
end