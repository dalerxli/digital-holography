% Esta función toma una imgen que pueda ser abierta por imread y la
% convierte al formato tif que utiliza el DHM para realizar la
% reconstrucción.

function Im2tifDHM(nombrearch)

I = imread(nombrearch);

nombresalida = [nombrearch(1:end-4) 'DHM.tif'];

fid_in = fopen('Hologram.tif');
fid_out = fopen(nombresalida,'w');

% Se leen los primeros 8 bytes y se copian.
buffer = fread(fid_in,8,'uint8');
fwrite(fid_out,buffer);

% Se ubican los datos
fwrite(fid_out,I');

% Se rellena con una copia del archivo de holograma tirado por el DHM
fseek(fid_in,1024*1024*4,'cof');
% while ~feof(fid_in)
%     buffer = fread(fid_in,1,'uint8');
%     fwrite(fid_out,buffer);
% end
bytesfinales = 1056925-1048584+1;
buffer = fread(fid_in,bytesfinales,'uint8');
fwrite(fid_out,buffer);

fclose(fid_in);
fclose(fid_out);