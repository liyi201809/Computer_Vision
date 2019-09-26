clear all
%%
aa0 = imread('zebra.png');
aa1 = imread('pn1.jpg');

aa2 =  rgb2gray(aa0);
%%
outimag = gaussianConv(aa2,3,3);

G1=fspecial('gaussian',7,3);
imOut1=conv2(aa2,G1,'same');


subplot(1,3,1);
imshow(aa2)    % original one
subplot(1,3,2); 
imshow(outimag,[0,255]) % after Gaussian filtering
subplot(1,3,3); 
imshow(imOut1,[0,255]) % after Matlab built-in filtering

%%
[imOut2,bbb] = gradmag(aa2 , 3);
imshow(imOut2)%,[0,255])



