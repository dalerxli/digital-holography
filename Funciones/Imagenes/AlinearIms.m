function AlinearIms(CarpetaIn,CarpetaOut,ext,nombreRef,V)

if CarpetaOut(end) ~= '\'
   CarpetaOut(end+1) = '\';
end

% Se toma una lista de los archivos de entrada
if CarpetaIn(end) ~= '\'
   CarpetaIn(end+1) = '\';
end
if ~strcmp(nombreRef(end-3:end),['.' ext])
    nombreRef = [nombreRef '.' ext];
end
archivos = dir([CarpetaIn '*.' ext]);
IndRef = 1;
while (IndRef <= length(archivos)) && ~strcmp(nombreRef,archivos(IndRef).name)
    IndRef = IndRef + 1;
end

ImRef = imread([CarpetaIn archivos(IndRef).name]);

movs = zeros(length(archivos),2);

fun = @PhaseCorrelationMethod;

dX = zeros(ceil(size(ImRef)/V));
dY = dX;

k = 1;
for IndIm = 1:length(archivos)
    if IndIm ~= IndRef
        A = imread([CarpetaIn archivos(IndIm).name]);
        B = blkproc2Ims(A,ImRef,[V V],fun,1);
        dX(:) = B(1:2:end);
        dY(:) = B(2:2:end);
        imwrite(dX,[CarpetaOut 'X' archivos(IndIm).name]);
        imwrite(dY,[CarpetaOut 'Y' archivos(IndIm).name]);
    end
end