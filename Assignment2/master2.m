%%
clear all
img1 = imread('landscape-a.jpg');
img2 = imread('landscape-b.jpg');

aaa = DoG(img1, 0.8);
[x,y,sigmas1] = harris(img1, aaa);                  % unit 8 as input
%[x1,y1,sigmas1] = harris(im2double(img1), aaa);     % double as input
%%
figure
subplot(1,2,1)
imshow(img1),title('DOG on image'),
hold on
plot(aaa(:,1),aaa(:,2), 'yo'),
hold off

subplot(1,2,2)
imshow(img1),title('Harris on image'),
hold on
scatter(y,x,sigmas1*20,'y'),
hold off
%%
[ma1,ma2] = findMatches(img1, img2, 0.8);
%% play around for study
orient1 = zeros(size(sigmas1));
[coord1, descriptor1] = vl_sift(single(rgb2gray(img1)), 'frames', [y'; x'; sigmas1'; orient1']);

