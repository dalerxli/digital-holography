function ImWE = WaveletEntropy(Ejs,tamQuad)

s_Ejs = size(Ejs);
if length(s_Ejs) == 2
    s_Ejs(3) = 1;
end
dimF = s_Ejs(3);

% Simple correcci�n de errores en Ejs, copio el pixel de arriba de donde
% hay un NaN
while sum(isnan(Ejs(:))) > 0
    Ejs(isnan(Ejs)) = Ejs(circshift(isnan(Ejs),1));
end

% Wavelet Entropy
X = AVectorFiltFull(Ejs,tamQuad,'@chebwin');
Y = X./repmat(sum(X,2),1,dimF);
ImWE = zeros(s_Ejs(1),s_Ejs(2));
logY = log2(Y);
logY(Y==0) = 0;
ImWE(:) = -sum(Y.*logY,2);