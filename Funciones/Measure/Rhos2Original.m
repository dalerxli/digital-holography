function ImOrig = Rhos2Original(mask,rhos)

Mask = imread(mask);
% Procesamiento de la máscara
[list cant] = listar(Mask(:));
list = sort(list,'ascend');

ImOrig = zeros(size(Mask));
for k = 1:length(rhos)
    ImOrig(Mask == list(k)) = rhos(k);
end