function guardar(matriz,archivo)

fid=fopen(archivo,'a');
s_matriz = size(matriz);
s = ones(2,1);
s(1:length(s_matriz)) = s_matriz;
fwrite(fid,s,'uint16');
fwrite(fid,matriz,'double');
fclose(fid);