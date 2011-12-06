function [EQ Q] = ValQualityFilt(ImOrig,tamQuad,ImTest)

win = window(@chebwin,tamQuad);
Filtro2D = repmat(win,1,tamQuad).*repmat(win',tamQuad,1);
Filtro2D = Filtro2D / norm(Filtro2D);
Im = Filter2Mirror(Filtro2D,ImTest);

[EQ Q] = ValQuality(ImOrig,Im);