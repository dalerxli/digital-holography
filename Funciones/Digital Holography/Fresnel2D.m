%Field propagation using Fresnel formulae for a distance z
% http://www.mathworks.cn/matlabcentral/newsreader/view_thread/29783
%uin - 2D field distribution at the entrance pupil
%lambda - illumination light wavelength
%N - number of samples per direction - assumed, that both fields (input & resulting ones) are
%described with NxN matrices
%dx, dy - spatial sampling distance of the field at the entrance aperture
%dxp, dyp - spatial sampling distance of the field in the plane at the distance z
function [uout]=Fresnel2D(uin, lambda, dx, dy, z)
    %finding the dimensions of input field array
    [Nx, Ny] = size(uin);
    %creates two arrays of position coordinates
    [X,Y] = meshgrid(-(Nx-1)/2:1:(Nx-1)/2, -(Ny-1)/2:1:(Ny-1)/2);
    %creates an array of Fresnel kernel
    kernel = exp(j*pi*((X*dx).^2+(Y*dy).^2)/(lambda*z));
    size(kernel)
    %computation of Fourier integral
    uout = fftshift(fft2(kernel.*uin));
    %multiplicand calculation but before changing the X and Y into
    %counterparts in z=z0
    X = X/(dx*Nx);
    Y = Y/(dy*Ny);
    kernel = exp(j*pi*(uin.^2)/(lambda*z));
    %resultant output field, without constant factor
    uout = uout.*kernel;