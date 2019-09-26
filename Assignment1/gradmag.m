function [magnitude , orientation] = gradmag(img , sigma)
    
    G = gaussian(sigma);
    Gd = gaussianDer(G , sigma);

    tempx = conv2(img,Gd,'same');
    tempy = conv2(tempx,Gd','same');
    magnitude = sqrt(tempy^2 + tempx^2);
    orientation = 0;

end
