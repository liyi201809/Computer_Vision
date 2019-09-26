function G = gaussian(sigma)

    G=[];
    for i= -3*sigma:3*sigma
        factor = -(i^2)/(2*(sigma^2));
        temp =(1/(sigma*sqrt(2*pi)))*(exp(factor));
        G = [G temp];
    end
    G = G./ sum(G); % normalize the array, make sum to be 1
end