%%% Esta funci�n toma una imagen multidimensional, la filtra con el
% criterio de obtener objetos del tama�o que uno espera tener y luego usa
% una red neuronal competitiva para encontrar Clusteres. 
% Las salidas son las asignaciones de cl�ster de los vectores que conforman
% la imagen (idx), los centros de cl�ster o pesos de entrada (C) y la
% matriz X que contiene en sus filas los vectores filtrados.

% Es conveniente que las energ�as pasen por un log10

function [imagenclus C Neuronas X] = CompetNNFull(Entrada,tamQuad,Clusters,plotear,epocas)

s_E = size(Entrada);
Neuronas = Clusters;
MuestrasTrain = 2000;

% Filtro 2D
% [Lo_D Hi_D Lo_R Hi_R] = wfilters(['db' num2str(ceil(tamQuad/2-1))]);
X = AVectorFiltFull(permute(Entrada,[1 2 4 3]),tamQuad,'@chebwin');

dimF = s_E(3);
cantMuestras = s_E(1)*s_E(2);

%%% Creaci�n de la red neuronal
IndTrain = randperm(cantMuestras);
Xtrain = X(IndTrain(1:MuestrasTrain),:);
minimos = min(X);
maximos = max(X);
net = newc([minimos' maximos'],Neuronas);
net.trainParam.epochs = epocas;
net.trainParam.showWindow = false;
% net.inputWeights{1,1}.learnParam.steps = 5;
% net.trainFcn = 'trainr';
% net.inputWeights{1,1}.learnFcn = 'learnsom';
% net.layerWeights{1,1}.learnFcn = 'learnsom';
net = train(net,Xtrain');
idx = sim(net,X');
[idx J] = find(idx==1);
C = net.IW;
C = C{1};

imagenclus = zeros(s_E(1),s_E(2));
imagenclus(:) = idx(:);

%%% Ploteo

if (nargin > 3) && (plotear)
% % Se encuentra el m�nimo de cada fila en C, la escala de menor potencia
% % en cada centroide y se resta para que quede C_ord todo positivo.
%     C_ord1 = C-repmat(min(C,[],2),1,dimF);
%     C_ord1 = C_ord1./repmat(sum(C_ord1,2),1,dimF);
%     for k_cluster = 1:Neuronas
%         mayoresQcero = C_ord1(k_cluster,find(C_ord1(k_cluster,:)>0));
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
    
end