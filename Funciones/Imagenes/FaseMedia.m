% Intentando sacar una fase media...
% Se va a ver por bloques si se puede disminuir la varianza de la fase

function [ImPhi ImsSumadas] = FaseMedia(CarpetaIn,V)

% Se toma una lista de los archivos de entrada
if CarpetaIn(end) ~= '\'
   CarpetaIn(end+1) = '\';
end
archivos = dir([CarpetaIn '*.txt']);

% Se abre el primero de los archivos para tomarlo de referencia
ImRef = abrirFase([CarpetaIn archivos(1).name],'fase');
expImRef = exp(1i*ImRef*pi/180);

% Se inicializa la matriz que indica los corrimientos que deber�n
% realizarse para promediar los valores de las fases
movs = zeros(length(archivos),2);

% Esta funci�n se utiliza para obtener los desplazamientos por bloques
fun = @PhaseCorrelationMethod;

dX = zeros(ceil(size(ImRef)/V));
dY = dX;

ImPhi = mod(ImRef,360);
ImsSumadas = 1;
for IndIm = 2:length(archivos)
    A = abrirFase([CarpetaIn archivos(IndIm).name],'fase');
    expA = exp(1i*A*pi/180);
    B = blkproc2Ims(expA,expImRef,[V V],fun,1);
    dX(:) = B(1:2:end);
    dY(:) = B(2:2:end);
    movs(IndIm,1) = mean(dX(:));
    movs(IndIm,2) = mean(dY(:));
    desvio = std(dX(:)) + std(dY(:));
    if desvio < 0.2
        diferencias = npi2pi(A-ImRef);
        difMedia = mean(diferencias(:));
        A = mod(A - difMedia,360);
%         ImPhi = ImPhi + A;        
        ImsSumadas = ImsSumadas + 1;
        ImPhi(:,:,ImsSumadas) = A;
    end
end

% ImPhi = npi2pi(ImPhi / ImsSumadas);