function [Spec_cube1, Spec_cube2, image_PCs_cube] = Run_Algorithm(x,handles)
%RUN_ALGORITHM Summary of this function goes here
%   Detailed explanation goes here

% Clip data cube and get size specifications

image_PCs = zeros(32,32,251);
x_new = x(1:1472,1:256,6:256);
axes(handles.axes1)
colormap('hot');
imagesc(x_new(:,:,106));  %% 106 is most vivid for this data
hold on
drawnow

dd = size(x_new);             % size of the hyperspectral data

% Recursive Processing of HSI image chips that are 32 X 32
% Target Dictionary Learning

% Spec_cube = zeros
block = 32;

num_blocky = floor( dd(1)/block);
num_blockx = floor( dd(2)/block);

founter = 0; 
count = 0;

rounter = 0;
%% PCA  
        
for QQ = 1 : num_blockx

         founter = founter + 1;
    
         tatt1 = (((founter-1) * block) + 1);  
    
         tatt2 = founter * block;
    
         sounter = 0;

    
        for Q = 1 : num_blocky

            
            
           count = count + 1;

           sounter = sounter + 1;

           tat1 = (((sounter-1) * block) + 1);   
           tat2 = sounter * block; 
           
           %%plot chip being cut on original HSI image
           hold on
           plot(handles.axes1,[tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1], 'color', 'green', 'LineWidth', 1.75 )
           
        %%new 32x32 chip
        %%plot 32x32 chip on new figure
        image = x_new( tat1 : tat2, tatt1: tatt2, :);
        imagesc(handles.axes2,image(:,:,1));
        pixel_average = reshape(image(16,16,:),[251 1]);
        plot(handles.axes12,pixel_average);
        axis(handles.axes12,[0 300 0 7000]);
        xlabel(handles.axes12, 'Wavelength Band (\lambda)');
        ylabel(handles.axes12, 'Energy');
        drawnow
      
        [xr, yr, bnd] = size(image);

            pxl_no = xr * yr;

            %% Reshape data into matrix that is bnd X pxl_no 
            %% Band dimension = rows and pxl_no = columns

            r = reshape(image, pxl_no, bnd)';
            x = r;
             P = size(r,2);   % pixel dimension

                      %% Subtracting the mean

                         mean_vec = mean(x')';

                         X_zero = r - mean_vec*ones(1,P);

                      %% Computing the covariance matrix and its eigenvalues/eigenvectors
                        
                         R=cov(X_zero');
                         [V,D]=eig(R);

                         eigenval=diag(D);

                         [~,ind]=sort(eigenval,1,'descend');

                         eigenvec=V(:,ind);

                      %% Keeping the first m eigenvalues/eigenvector

                         eigenvec=eigenvec(:,1:bnd);


                      % Computing the transformation matrix

                         A =eigenvec(:,1:bnd)';


                      %% Computing the transformed data set

                         Y=A*x;

                      
                         e4= Y;
                        

                         clear eigenval; clear eigenvec; clear Y; clear mean_vec;
                         clear A; clear X_zero

                        
                        for I = 1 : bnd

                          image_PCs(:,:,I) = reshape( e4(I,:), xr, yr );

                        end
                        
                        %%Plot PCA bands on new axes
                        imagesc(handles.axes3,image_PCs(:,:,1))
                        axis(handles.axes3, 'off');
                       
                        imagesc(handles.axes4,image_PCs(:,:,2)) 
                        axis(handles.axes4, 'off');
                     
                        imagesc(handles.axes5,image_PCs(:,:,3))
                        axis(handles.axes5, 'off');
                       
                        imagesc(handles.axes6,image_PCs(:,:,4))
                        axis(handles.axes6, 'off');
                       
                        imagesc(handles.axes7,image_PCs(:,:,5))
                        axis(handles.axes7, 'off');
                        
                        imagesc(handles.axes8,image_PCs(:,:,6)) 
                        axis(handles.axes8, 'off');
                        
                        imagesc(handles.axes9,image_PCs(:,:,7))
                        axis(handles.axes9, 'off');
                        
                        imagesc(handles.axes10,image_PCs(:,:,8))
                        axis(handles.axes10, 'off');
                        
                        imagesc(handles.axes22,image_PCs(:,:,9))
                        axis(handles.axes22, 'off');
                       
                        imagesc(handles.axes23,image_PCs(:,:,10)) 
                        axis(handles.axes23, 'off');
                     
                        imagesc(handles.axes24,image_PCs(:,:,11))
                        axis(handles.axes24, 'off');
                       
                        imagesc(handles.axes25,image_PCs(:,:,12))
                        axis(handles.axes25, 'off');
                  

image_PCs_cube = image_PCs(:, :, 1:15);

%contour
cont = imrotate(image_PCs_cube(:,:,1),180);
cont_final = flip(cont,2);
[px,py] = gradient(image_PCs_cube(:,:,1),1,1);
contour(handles.axes11, cont_final)
axis(handles.axes11, [ 1 32 1 32 ]);
hold(handles.axes11, 'on');
quiver(handles.axes11,px,py)
hold(handles.axes11, 'off');
 


     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
     % Perform Automatic Target Generation Process (ATGP)%
     % Target Dictionary Learning  - 1                   %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     bnd = size(image_PCs_cube, 3);
     xx = size(image_PCs_cube, 1);
     yy = size(image_PCs_cube, 2);

     r = reshape(image_PCs_cube,xx*yy, bnd);
     r = r';
     % ===== Find the first point
     
     temp = sum(r.*r);
     [ ~, b] = max(temp);
     
     if(rem(b,xx) == 0)
         Loc(1,1) = b/xx;
         Loc(1,2) = xx;
     elseif (floor(b/xx)== 0)
         Loc(1,1) = 1;
         Loc(1,2)=b;
     else
         Loc(1,1) = floor(b/xx) + 1;
         Loc(1,2)= b -xx* floor(b/xx); 
     end
     
     Sig(:,1) = r(:,b);
     
      %=======
      num_targets = 6;
      
      for m = 2: num_targets
          
           U = Sig;
           P_U_perl =eye(bnd) -U*inv(U'*U)* U';
           y = P_U_perl*r;
           temp = sum(y.*y);
           [~,b] = max(temp);
           if(rem(b,xx) ==0)
               Loc(m,1)= b/xx;
               Loc(m,2)=xx;
           elseif (floor(b/xx) ==0)
               Loc(m,1) = 1;
               Loc(m,2) = b;
           else
               Loc(m,1) = floor(b/xx) + 1; 
               Loc(m,2) = b- xx* floor(b/xx);
           end
           Sig(:,m ) = r(:,b);
      end

      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%                K-means Clustering                 %%
      %%%%%%%%%%%%%%%%%Target Dictionary Learning 2 %%%%%%%%%%
      %%%%%%%%%%%%%%% Sparse Decomposition%%%%%%%%%%%%%%%%%%%%
      
      K = num_targets;
      [~, C] = kmeans( r', K);  
      
      % Save Spectral Signatures found by the ATGP and K-means Clustering 
      % in long matrix
      
      rounter = rounter + 1;
      blockss = K;
      
      tat1a = (((rounter-1) * blockss) + 1);   
      tat2a = rounter * blockss; 
       
      Spec_cube1(:, tat1a:tat2a)= Sig;

      Spec_cube2(:, tat1a:tat2a)= C';
      
        end       
end


end