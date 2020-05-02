% Image Interpolating Program %

RGB = im2double(imread("puppy.jpg")); % Retrieve RGB values from image

% NOTE: Indexing -> (row, column, level) 

% Thus: R: ( ; ; 1), G: ( ; ; 2), B: ( ; ; 3)

% Getting dimensions for new, resized, interpolated matrix %

dimensions = size(RGB); 
newDimensions = 2.*dimensions;

height = dimensions(1);
width = dimensions(2);

resized_RGB = zeros(newDimensions(1), newDimensions(2),3); % Matrix must be 2x the size of the original

% Resizing algorithm: %

rowCounter = 0;
columnCounter = 0;
levelCounter = 0;

% Will iterate through the ORIGINAL matrix, grab original values and put
% them in the NEW matrix %

for levelCounter = [1:3] % must iterate through all levels
    
    for rowCounter = [1:height]
        
        for columnCounter = [1:width]
            
           % Will account for the MATLAB offset (ie. matrices starting at
           % index 1 instead of 0) %
           
           resized_RGB(rowCounter*2-1,columnCounter*2-1,levelCounter) = RGB(rowCounter, columnCounter, levelCounter); 
               
        end
        
    end
    
end

levelCounter = 0;

% We now have a resized matrix - time to interpolate

% START by selecting the 16 pixels of REAL data to interpolate. 

blockHeightSelector = 0;
blockWidthSelector = 0;

for levelCounter = [1:3] 
    
    for blockHeightSelector = [0:round(height/4)-1] % will need to go to ceil(height/4) 

        for blockWidthSelector = [0:ceil(width/4)-1]  % will need to go to ceil(width/4) %

            % Begin interpolation code % 
            % Working off the in lecture notation %

            F = RGB(1+4*blockHeightSelector:4+4*blockHeightSelector , 1+4*blockWidthSelector:4+4*blockWidthSelector, levelCounter);

            B = [(0+4*blockWidthSelector)^3 (0+4*blockWidthSelector)^2 (0+4*blockWidthSelector)^1 1; (1+4*blockWidthSelector)^3 (1+4*blockWidthSelector)^2 (1+4*blockWidthSelector)^1 1; (2+4*blockWidthSelector)^3 (2+4*blockWidthSelector)^2 (2+4*blockWidthSelector)^1 1; (3+4*blockWidthSelector)^3 (3+4*blockWidthSelector)^2 (3+4*blockWidthSelector)^1 1]; % Organizing matrices
            B_y = [(0+4*blockHeightSelector)^3 (0+4*blockHeightSelector)^2 (0+4*blockHeightSelector)^1 1; (1+4*blockHeightSelector)^3 (1+4*blockHeightSelector)^2 (1+4*blockHeightSelector)^1 1; (2+4*blockHeightSelector)^3 (2+4*blockHeightSelector)^2 (2+4*blockHeightSelector)^1 1; (3+4*blockHeightSelector)^3 (3+4*blockHeightSelector)^2 (3+4*blockHeightSelector)^1 1]'; % Organizing matrices

            B_inv = inv(B);
            B_y_inv = inv(B_y); 

            A = B_inv*F*B_y_inv; % Computes the coefficient matrix for all pixels to be interpolated in this block of 16 pixels.

            % Calculate pixels using the matrix we just solved for % 

            x = 0;
            y = 0;

            counter = 1;

            for y = [0 0.5 1 1.5 2 2.5 3 3.5]+4*blockHeightSelector 

                xMatrix = [0 0.5 1 1.5 2 2.5 3 3.5]+4*blockWidthSelector; 

                if mod(y,1) == 0 

                    xMatrix = [0.5 1.5 2.5 3.5]+4*blockWidthSelector; 
                end

                for x = xMatrix

                    currentAns = f_interpolate(x,y,A);

                    resized_RGB(2*y+1, 2*x+1, levelCounter) = currentAns; % Mapping our new pixels to the matrix! This converts to MATLAB syntax + our re-sized matrix (2x the size)

                end

                counter = counter + 1;

            end

        end
    
    
    end
end

image(resized_RGB);