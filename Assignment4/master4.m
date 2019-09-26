%% 
clear all
X = importdata('model_house/measurement_matrix.txt');
load('Xpoints')
load('Ypoints')
X2 = zeros(size(X));
X2(1:2:end,:)= pointsx;
X2(2:2:end,:)= pointsy;
%%
[rows, noPoints] = size(X);
X = X - (mean(X,2));
X2 = X2 - (mean(X2,2));
%
[U,W,V] = svd(X);
U = U(:,1:3);
W = W(1:3,1:3);
V = V(:,1:3);
%
M = U*(W^(1/2));
S = (W^(1/2))*V';
A1 = M(1:2, :);
L0 = pinv(A1' * A1);
%%
L = lsqnonlin(@residuals, L0);
C = chol(L,'lower');
% Update M and S with the corresponding C form: M = MC and S = C^{-1}S. 
M = M*C;
S = C\S;
% Plot the obtained 3D coordinates:
plot3(S(1,:),S(2,:),S(3,:),'.y');

%% the main function to implement
%% Compare the measurement_matrix.txt and the Optical Flow tracker(Xpoints and Ypoints matrices).
clear all
X = importdata('model_house/measurement_matrix.txt');
sfm_template(X);

%% for checking pinv
AA = magic(8); 
AA = AA(:,1:6)
b = 260*ones(8,1);
x1 = AA\b;
x2 = pinv(AA)*b
