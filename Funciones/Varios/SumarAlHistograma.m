% Esta funci�n me sirve para calcular el histograma de las realizaciones de
% una variable aleatoria multidimensional.
% En speckle me sirvi� para calcular (en WE.m) el histograma de las
% energ�as de un thsp para distintas escalas.

function H = SumarAlHistograma(valores, H, limites)
for k=1:size(valores,2)
    H(:,k) = H(:,k) + histc(valores(:,k),limites);
end
    

