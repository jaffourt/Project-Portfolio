function image_PCs_cube = PCA(image, handles)
%PCA Summary of this function goes here
%   Detailed explanation goes here
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
                        axis off
                       
                        imagesc(handles.axes4,image_PCs(:,:,2)) 
                        axis off
                     
                        imagesc(handles.axes5,image_PCs(:,:,3))
                        axis off
                       
                        imagesc(handles.axes6,image_PCs(:,:,4))
                        axis off
                       
                        imagesc(handles.axes7,image_PCs(:,:,5))
                        axis off
                        
                        imagesc(handles.axes8,image_PCs(:,:,6)) 
                        axis off
                        
                        imagesc(handles.axes9,image_PCs(:,:,7))
                        axis off
                        
                        imagesc(handles.axes10,image_PCs(:,:,8))
                        axis off

                        image_PCs_cube = image_PCs(:, :, 1:15);

%contour

cont = imrotate(image_PCs_cube(:,:,1),180);
cont_final = flip(cont,2);
contour(handles.axes11, cont_final )

end

