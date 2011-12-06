function ImAp = apodizer(I,d)

if nargin == 1
    d = 1/5;
end
sI = size(I);
vF = ones(sI(1),1);
vC = ones(sI(2),1);

% Armando vF
lF = floor(sI(1)*d);
vF(1:lF) = sin(((1:lF)-1)/(lF-1)*pi-pi/2)/2+1/2;
vF(end-lF+1:end) = vF(lF:-1:1);

% Armando vC
lC = floor(sI(2)*d);
vC(1:lC) = sin(((1:lC)-1)/(lC-1)*pi-pi/2)/2+1/2;
vC(end-lC+1:end) = vC(lC:-1:1);

% Armando la máscara 2D
mask = vF*vC';

% Se aplica la máscara
ImAp = I.*mask;