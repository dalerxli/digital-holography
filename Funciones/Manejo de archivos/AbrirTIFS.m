function Is = AbrirTIFS()
direc = dir('*.tif');
Arc = length(direc);
for k = 1:Arc
    I = imread(direc(k).name);
    I = double(I);
    Is(:,:,k) = I;  
end
