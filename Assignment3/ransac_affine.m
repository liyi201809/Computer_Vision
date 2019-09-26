% Ransac implementation to find the affine transformation between two images.
% Input:
%       match1 - set of point from image 1
%       match2 - set of corresponding points from image 2
%       im1    - the first image
%       im2    - the second image
% Output:
%       best_h - the affine affine transformation matrix

function best_h = ransac_affine(match1, match2, im1, im2)
% Iterations is automatically changed during runtime
% based on inlier-count. Set min-iterations (e.g. 5 iterations) to circumvent corner-cases
    iterations = 50;
    miniterations = 5;% Minimum iterations after which to stop, can be made larger

% Threshold: the 10 pixels radius
    threshold = 10;

% The model needs at least ? point pairs (? equations) to form an affine transformation
    P = 3;

% Start the RANSAC loop
    bestinliers = 0;
    best_h = zeros(6,1);
    i=1;
    [mm,nn] = size(match1);
    while ((i<iterations) || (i<miniterations))
        
% (1) Pick randomly P matches
        perm = randperm(nn);
        seed = perm(1:P);

% (2) Construct matrices A, h, b    
        newpts1 = [match1(1,seed); match1(2,seed)];  %(x1,y1)
        newpts2 = [match2(1,seed); match2(2,seed)];  %(x2,y2)
        b = newpts2(:);    % save these points into one column
        A = [];      
        for i1 = 1:3  % for-loop fills 6 equations into A
            temp = newpts1(:,i1)';
            temp1 = [temp 0 0 1 0;0 0 temp 0 1];
            A = [A; temp1];
        end
        h = pinv(A)* b;  % get the transformation matrix
        
% (3) Fit model h over the matches
        AA = [];
        for i1 = 1:nn  % for-loop fills all matches into A
            temp = match1(1:2,i1)';
            temp1 = [temp 0 0 1 0;0 0 temp 0 1];
            AA = [AA; temp1];
        end
        bprim = AA*h;   % get the new matches list in the second image.

% (4) Transform all points from image1 to their counterpart in image2. Plot these correspondences.  
        % storing the 1-column dataset into 2-column dataset
        match1t = []; 
        [mmm,nnn] = size(bprim);
        mmm= mmm/2;
        for i1 = 1:mmm
           match1t =[ match1t ;  bprim(2*i1-1) bprim(2*i1)];
        end
        
% (5) Determine inliers using the threshold and save the best model
        match1t = match1t';
        aa = match1t(1,:) - match2(1,:);  % examine the difference between new and original match points
        bb = match1t(2,:) - match2(2,:);
        inliers = find(sqrt((aa.^2) + (bb.^2)) <threshold); % return the index of satisfied match points(inliers)
        
% (6) Save the best model and redefine the stopping iterations
        if size(bestinliers,2) < size(inliers,2)
            bestinliers = inliers;
            best_h = h;
        end    
    
        % Solve for i in the assignment description. 
        q = size(bestinliers,2)/size(match1t,2);
        p = 10;
        for it = 1:50
            if((1-(q^p)^it) <= 0.01)
            break;
            end
        end
        iterations = it; 
        i = i+1;
    end
    %% append for checking
    iterations = iterations
    p=p
end
