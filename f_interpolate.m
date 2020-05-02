function newPixel = f_interpolate(x,y,A)
    
    x=x;
    y=y;

    xMatrix = [x^3 x^2 x 1];
    yMatrix = [y^3 y^2 y 1]'; % Transpose, because it needs to be a vertical vector
    
    newPixel = xMatrix*A*yMatrix;
    
end