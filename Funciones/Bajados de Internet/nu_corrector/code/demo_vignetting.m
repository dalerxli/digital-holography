function demo_vignetting()
% demo for vignetting correction

% path and name of input image file
fn='..\data\vignetting\flickr_3.jpg';

% setting
addpath(genpath('.'));

% read and process the image
im=imread(fn);
tic
[im_vign_corrected,im_vignetting]=vignCorrection_nonPara(im);%you may need to input the second parameter and adapt it to the vignetting in the input image
toc

% show results
figure; 
subplot(1,3,1); imshow(im); title('Given Image');
subplot(1,3,2); imshow(im_vign_corrected); title('Vignetting-Corrected Image')
subplot(1,3,3); imshow(im_vignetting); title('Estimated Vignetting')
