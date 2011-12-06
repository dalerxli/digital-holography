function Ic = ImagenDeContraste(A,n)

fun = @(I)std(I(:))/mean(I(:));
Ic = blkproc(A,[n n],fun);