% D = discrepancy(A,listA,B,metodo,Bval,cantidad)
%
% Funci�n que obtiene una medida objetiva del error en la segmentaci�n de
% resultado A e imagen de referencia B.
% El m�todo puede ser:
%   - pixel1: Valor medio de cantidad de pixels mal clasificados por valor
%   posible de B;
%   - pixel2: Valor medio de pixels clasificados como k y no son de clase k
%   en B;
%   - pos: Se tiene en cuenta tanto la cantidad de pixels mal clasificados
%   como la distancia de estos a su clase correspondiente
%   - divSim: Divergencia sim�trica con las posibilidades de pertencer a
%   los distintos clusters entre la imagen segmentada y la de referencia.
%   - entropy: se calcula una entrop�a de los valores de segmentaci�n y se
%   suma otra de las �reas de las secciones.
%   - CoefCorr: btiene el valor absoluto del coeficiente de correlación
%   entre la imagen A y la B.
%   - PSNR: Se obtiene la peak signal to noise ratio de la imagen A tomando
%   a B como referencia.
%   - MAE: error medio.
%   - EdgeQ: Se mide la calidad de preservación de bordes. Coeficiente de
%   correlación del Laplaciano de las imágenes.

function [D, VarOut] = discrepancy(A,listA,B,metodo,Bval,cantidad)

VarOut = [];

if not(isempty(listA))
    % Se adapta la matriz A a B
    Abeizado = AsociarSegm(A,listA,B,Bval,cantidad);
end

if strcmp(metodo,'pixel1')
    
    % Se arma la matriz C a partir de A y B
    C = pixelclass(Abeizado,B,Bval);
    % Cantidad de pixels en B por valor
    TotalXColumna = sum(C);
    % Porci�n de pixels mal clasificados por valor de B
    C = C - diag(diag(C));
    D = sum(C) ./ TotalXColumna;
    % Valor promedio de pixels errados por valor de B
    D = mean(D);
    
elseif strcmp(metodo,'pixel2')

    % Se arma la matriz C a partir de A y B
    C = pixelclass(Abeizado,B,Bval);
    % Cantidad de pixels en B por valor de B
    TotalXColumna = sum(C);
    % Cantidad de pixels en B que no son de un valor de B
    NoSon = length(A(:)) - TotalXColumna;
    % Porci�n de pixels mal clasificados por valor de A
    C = C - diag(diag(C));
    D = sum(C,2) ./ NoSon';
    % Valor promedio de pixels errados por valor de B
    D = mean(D);

elseif strcmp(metodo,'pos')    
    
    % Se calculan las distancias a la regi�n de los errores
    d2 = errorDist(Abeizado,B);
    % Factor de escala
    p = 1;
    % Se calcula la figura de m�rito
    D = 1-sum(1./(1+p*d2))/length(A(:));
    
elseif strcmp(metodo,'divSim')
    
    histo1 = hist(Abeizado(:),Bval) / length(A(:));
    histo2 = hist(B(:),Bval) / length(A(:));
    D = sum((histo1-histo2).*log(histo1./histo2));
    
elseif strcmp(metodo,'entropy')
    
    % C�lculo de entrop�a por segmento
    [HRj Sj] = EntropiaRegion(Abeizado,Bval,B);
    % C�lculo de entrop�a promedio de regiones
    SI = sum(Sj);
    Hr = sum(Sj.*HRj)/SI;
    % Entrop�a de areas de segmentos
    Hl = -sum(Sj/SI.*log10(Sj/SI));
    % Medida
    D = Hr + Hl;
    
elseif strcmp(metodo,'CoefCorr')
    
    D = abs(corr2(A,B));
    
elseif strcmp(metodo,'PSNR')
    
    A = mat2gray(A);
    % Primero se lleva a B a valores que tengan sentido ser comparados con
    % los valores de A. Se aplica una función lineal a los valores de B
    % para lograr el mejor ajuste.
    [C error] = FitImageLS(A,B,1);
    % Cálculo del PSNR
    D = 20*log10(1 / sqrt(error));
    
elseif strcmp(metodo,'MAE')
    
    A = mat2gray(A);
    C = FitImageLS(A,B,1);
    D = sum(abs(A(:)-C(:))) / length(A(:));

elseif strcmp(metodo,'Wang1')

    A = mat2gray(A);
    C = FitImageLS(A,B,1);
    VarOut = zeros(3,1);
%     [D,VarOut(1),VarOut(2),VarOut(3), quality_map] = img_qi(C, A, 8);
    D = zeros(3,1);
    [D(1), quality_map] = img_qi(C, A, 6);
    [D(2), quality_map] = img_qi(C, A, 10);
    [D(3), quality_map] = img_qi(C, A, 14);

elseif strcmp(metodo,'Wang2')

    A = mat2gray(A);
    C = FitImageLS(A,B,1);
    [D, ssim_map] = ssim_index(C, A);    
    
elseif strcmp(metodo,'Wang3')

    A = mat2gray(A);
    C = FitImageLS(A,B,1);
    [D, ssim_map] = ssim(C, A,[0.01 0.05]);       
    
elseif strcmp(metodo,'EdgeQ')

    A = mat2gray(A);
    B = FitImageLS(A,B,1);
    % Aplico el Laplaciano a las imágenes para realzar los bordes
    Laplacian = [0 -1 0 ; -1 4 -1; 0 -1 0];
    DeltaA = Filter2Mirror(Laplacian,A);
    DeltaB = Filter2Mirror(Laplacian,B);
    % Se mide la relación entre los bordes de las imágenes
    D = corr2(DeltaA,DeltaB);
    
elseif strcmp(metodo,'EdgeQGrueso')
    
    A = mat2gray(A);
%     B = FitImageLS(A,B,1);
    % El m�todo de Canny detecta bordes bruscos y rellena con bordes
    % suaves.
    DeltaA = edge(A,'canny');
    % Cualquier m�todo da lo mismo en la imagen patr�n.
    DeltaB = edge(B,'roberts');
    % Se agrandan los l�mites para usar de m�scara con el objetivo de
    % buscar l�mites en la imagen resultado que coincidan con los reales.
    DeltaB = Filter2Mirror(ones(15),abs(DeltaB));
    DeltaB = DeltaB > 0;
    % "Pixels borde" que est�n dentro de la m�scara. Conviene que sean
    % muchos. Esto en realidad ya mide algo.
    Pab = sum(sum(DeltaA & DeltaB)) / sum(DeltaB(:));
    % "Pixels borde" que no est�n dentro de la m�scara. Conviene que sean
    % pocos.
    Panob = sum(sum(DeltaA & ~DeltaB)) / sum(~DeltaB(:));
    D = Pab / Panob;
        
elseif strcmp(metodo,'EdgeQpond')
    
    tolerancia = 11;
    incidencia = 3;
    A = mat2gray(A);
    % El m�todo de Canny detecta bordes bruscos y rellena con bordes
    % suaves.
    DeltaA = edge(A,'canny');
    % Cualquier m�todo da lo mismo en la imagen patr�n.
    DeltaB = edge(B,'roberts');    
    % Se agrega una tolerancia a la imagen de bordes de A. Se considera
    % como borde correcto todo lo que entre dentro de dicha tolerancia, con
    % cierto grado.
    FiltroGauss = gausswin(2*tolerancia+1)*gausswin(2*tolerancia+1)';
    deltaB = Filter2Mirror(FiltroGauss,abs(DeltaB));
    % Se lo normaliza de manera tal que la suma de 1
    deltaBn = deltaB/sum(deltaB(:));
    % Se aplica una regi�n de incidencia del borde detectado en la imagen
    % de evaluaci�n, de esta manera se valora el hecho de encontrar un
    % borde.
    FiltroGauss = gausswin(2*incidencia+1)*gausswin(2*incidencia+1)';
    deltaA = Filter2Mirror(FiltroGauss,abs(DeltaA));
    % Donde se pasa de uno se lo corrige, no hay mayor seguridad que uno de
    % tener borde.
    deltaA(deltaA>1) = 1;
    % El error ponderado de bordes faltantes se obtiene sumando los bordes
    % de la imagen de referencia donde no se encontraron bordes en la
    % imagen evaluada.
    wMissing = sum(sum(deltaBn.*(1-deltaA)));
    
    % Para el c�lculo de error ponderado de falsas alarmas se va a integrar
    % en los bordes encontrados de la imagen evaluada sacando lo que
    % corresponda a lugares donde no se espere encontrar bordes seg�n deltaB
    deltaAn = deltaA/sum(deltaA(:));
    deltaB(deltaB>1) = 1;
    wFalse = sum(sum(deltaAn .* (1-deltaB)));
    
    % Multiplicando los errores se llega a una cantidad que var�a entre 0 y
    % 1 y cuanto menor sea, m�s coincidencia de bordes existe.
    D = wMissing * wFalse;
    
end