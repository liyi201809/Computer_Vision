function imOut = gaussianConv(imagepath, sigmax, sigmay)   
    image=imagepath;
    
    gx = gaussian(sigmax);
    gy = gaussian(sigmay);
 
    tempx = conv2(image,gx,'same');
    tempy = conv2(tempx,gy','same');
    
    imOut = tempx;
end