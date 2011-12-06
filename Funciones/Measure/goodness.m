% G = goodness(A,metodo,B)
%
%   Se obtiene un factor de bondad de la imagen segmentada. No se tienen
%   datos de la segmentación ideal.
%   metodo:
%   - Borsotti: M�todo de Borsotti (ver An entropy based objective...), se
%   ingresa la matriz de features en B y la segmentada en A.
%   - Busyness: Momento de inercia de la matriz de co-ocurrencia de la
%   imagen en 4 sentidos.

function G = goodness(A,metodo,B)

    
if strcmp(metodo,'Borsotti')
    
    [varRegion Sj] = VarianzaRegiones(B,A);
    NSj = zeros(length(Sj),1);
    for k = 1:length(Sj)
        NSj(k) = sum(Sj==Sj(k));
    end
    G = 1/1000/sum(Sj)*sqrt(length(Sj))*sum(varRegion./(1+log10(Sj))+(NSj./Sj).^2);
    
elseif strcmp(metodo,'Busyness')
    
    % Se obtiene la matriz de Co-Ocurrencia como la suma de las matrices de
    % co-ocurrencia en cada uno de los 4 sentidos (horizontal, vertical,
    % diagonales)
    CoOc = sum(graycomatrix(mat2gray(A),'NumLevels',256,'Offset',[0 1; -1 1; -1 0; -1 -1]),3);
    CoOc = CoOc / sum(CoOc(:));
    % Momento de Inercia
    G = IM(CoOc);
    
end