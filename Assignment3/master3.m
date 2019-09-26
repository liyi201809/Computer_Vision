clear all
img1 = imread('boat/img1.pgm');
img2 = imread('boat/img2.pgm');
im1 = single(img1);
im2 = single(img2);
[frames1, desc1]=vl_sift(im1);
[frames2, desc2]=vl_sift(im2);
[matches] = vl_ubcmatch(desc1, desc2);
%% show the 50 matches 
% only select 50 point matches for clearness%%%
pts1 = frames1(:,matches(1,1:50));    % what is the 3rd and 4th elements of frames,
pts2 = frames2(:,matches(2,1:50));    % 'help':[X;Y;S;TH], where X,Y is the (fractional)center of the frame 
                                      %, S is the scale and TH isthe orientation (in radians).
% first show the matches without RANSAC
figure; imshow([img1, img2]);
line([pts1(1,:);size(im1,2)+pts2(1,:)],[pts1(2,:);pts2(2,:)]);
title('the mathes of Image 1 and 2 without RANSAC uses');

%% use the RANSAC to get a new matches set 
%get the RANSAC transformation
h = ransac_affine(pts1, pts2, img1, img2);

% use the transformation get new matched point



AA = [];    
[m,n]=size(pts1);
for i = 1:n   % form the AA of the whole dataset in the first figure
    temp = pts1(1:2,i)';
    temp1 = [temp 0 0 1 0;0 0 temp 0 1];
    AA = [AA; temp1];
end
bprim = AA * h;
%% store all 'bprim' into 'match1t', from 1-column to 2-column dataset
match1t = [];
[mm,nn] = size(bprim);
mm= mm/2
for i = 1:mm
   match1t =[ match1t ;  bprim(2*i-1) bprim(2*i)];
end
%% plot the new matches after appling RANSAC
figure;
imshow([img1 img2]);
hold on;
match1t = match1t';
line([pts1(1,:);size(im1,2)+match1t(1,:)],[pts1(2,:);match1t(2,:)]);
title('the original points and their transformed counterparts with RANSAC selection');

%% transform the whole images
% h contains 6 unknowns of the affine matrix
affine_transform = [h(1) h(2) h(5); h(3) h(4) h(6); 0 0 1 ]; 

tform = maketform('affine', affine_transform');
image1_transformed = imtransform(img1, tform, 'bicubic');
tform = maketform('affine', inv(affine_transform)');
image2_transformed = imtransform(img2, tform, 'bicubic');

figure;
subplot(2,2,1);
imshow(img1);
title('Image 1');
subplot(2,2,2);
imshow(image1_transformed);
title('Image 1 transformed');
subplot(2,2,3);
imshow(img2);
title('Image 2');
subplot(2,2,4);
imshow(image2_transformed);
title('Image 2 transformed');

%% use the imageAlign function, to plot alternatvely the whole program agian
% Load Images %
clear all    
im11 = imread('boat/img1.pgm');
im22 = imread('boat/img2.pgm');
imageAlign(im11,im22);
