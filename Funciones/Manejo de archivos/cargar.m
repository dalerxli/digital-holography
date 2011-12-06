function matriz = cargar(fid)
s = fread(fid,2,'uint16');
matriz = zeros(s');
for k_col = 1:s(2)
    matriz(:,k_col) = fread(fid,s(1),'double');
end