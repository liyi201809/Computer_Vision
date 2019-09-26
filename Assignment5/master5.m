clear all

disp('Reading images');
img1 = im2double(rgb2gray(imread('TeddyBearPNG/obj02_001.png')));
img2 = im2double(rgb2gray(imread('TeddyBearPNG/obj02_002.png')));

[feat1,desc1,~,~] = loadFeatures('TeddyBearPNG/obj02_001.png.haraff.sift');
[feat2,desc2,~,~] = loadFeatures('TeddyBearPNG/obj02_002.png.haraff.sift');

 disp('Matching Descriptors');
[matches, ~] = vl_ubcmatch(desc1,desc2);
disp(strcat( int2str(size(matches,2)), ' matches found'));

% Get X,Y coordinates of matched features
X1 = feat1(1:2,matches(1,:));
X2 = feat2(1:2,matches(2,:));
%% estimate function
match1 = [X1;ones(1,size(X1,2))];
match2 = [X2;ones(1,size(X2,2))];
bestcount = 0;
bestinliers = [];
iterations = 50;
miniter = 10;
p= 8;
%%
perm = randperm(size(match1,2));
seed = perm(1:p);

[x1,T1] = normalize(match1(1:2,seed));
[x2,T2] = normalize(match2(1:2,seed));

A = composeA(x1,x2);
F = computeF(A,T1,T2);

%%
x = match1;
xp = match2;
    
numer = diag((xp'*F*x)).^2;
%%    
%     x = match1(1,:);
%     xp = match2(1,:);
    de1 = (F*match1);
    de2 = (F'*match2); 
    
    denom = (de1(1,:).^2)+(de1(2,:).^2)+(de2(1,:).^2)+(de2(1,:).^2);

%%
  sd  = numer'./denom;

 %%
 [U,S,V] = svd(Aaa);
 Vlast=V(:,end)
 Vlast=reshape(Vlast,[3,3])
 [U1,S1,V1] = svd(Vlast);
 %%
    numer = diag((xp'*F*x)).^2;
    x = match1(1,:);
    xp = match2(1,:);
    de1 = (F*match1);
    de2 = (F'*match2); 

 