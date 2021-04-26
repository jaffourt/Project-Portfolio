function Run_Algorithm_3(data, handles)
%RUN_ALGORITHM_3 Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Normalization of Spectral Signatures in Target Dictionary %%%%%%
%%%%%%%%%%%% This if for the Orthogonal Matching Pursuit%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
x = data.x;
x_new = x(1:1376, 1:256, 6:256);
dd = size(x_new);
block = 32;
PC_number = 10;
num_blocky = floor( dd(1)/block);
num_blockx = floor( dd(2)/block);

axes(handles.main)
colormap('hot');
imagesc(x_new(:,:,106));      %% 106 is most vivid for this data
hold on
drawnow;

ffounter = 0; 
ccount = 0;

   for QQ = 1 : num_blockx
    
         ffounter = ffounter + 1;
    
         tatt1 = (((ffounter-1) * block) + 1);  
    
         tatt2 = ffounter * block;
    
         scounter = 0;

    
        for Q = 1 : num_blocky

          ccount = ccount + 1;

           scounter = scounter + 1;

           tat1 = (((scounter-1) * block) + 1);   
           tat2 = scounter * block;

          % Plot data snippet in real coordinates & save plot
       
           plot(handles.main,[tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1],'color', 'green', 'LineWidth', 1.75)
           drawnow
                     
           image_ROI = x_new(tat1 : tat2, tatt1: tatt2, :);
           imagesc(handles.secondary, image_ROI(:,:,1));
           drawnow
 
        %  eval(['print -djpeg image_data_' num2str(count)])

           [xr, yr, bnd] = size(image_ROI);

            pxl_no = xr * yr;

            %% Reshape data into matrix that is bnd X pxl_no 
            %% Band dimension = rows and pxl_no = columns

            r = reshape(image_ROI, pxl_no, bnd)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Principal Component Analysis%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

             x = r;
             L = size(r,1);   % band dimension
             P = size(r,2);   % pixel dimension

                      %% Subtracting the mean

                         mean_vec = mean(x')';

                         X_zero = r - mean_vec*ones(1,P);

                      %% Computing the covariance matrix and its eigenvalues/eigenvectors
                        
                         R=cov(X_zero');
                         [V,D]=eig(R);

                         eigenval=diag(D);

                         [eigenval,ind]=sort(eigenval,1,'descend');

                         eigenvec=V(:,ind);

                         explain=eigenval/sum(eigenval);

                      %% Keeping the first m eigenvalues/eigenvectors

                         eigenval=eigenval(1:bnd);

                         eigenvec=eigenvec(:,1:bnd);


                      % Computing the transformation matrix

                         A =eigenvec(:,1:bnd)';

                      %% Computing the transformed data set

                         Y=A*x;

                         e1 = eigenval;
                         e2 = eigenvec;
                         e4= Y;
                         e5 = mean_vec;

                         clear eigenval; clear eigenvec; clear Y; clear mean_vec;
                         clear A; clear X_zero

                        for I = 1 : bnd

                          image_PCs(:,:,I) = reshape( e4(I,:), xr, yr );

                        end

image_PCs_cube = image_PCs(:, :, 1:PC_number);

% Performs Laplacian eigenmap based on the NxN dimensional
% graph Laplacian L, produced by an lxN dimensional matrix X, each column
% of which corresponds to a data vector. The algorithm determines the m
% N-dimensional eigenvectors that correspond to the m smallest nonzero
% eigenvalues.

% The threshold for the distance matrix and standard deviation envelope
% have to be tuned. 
               
%% Reshape data into matrix that is pxl_no X bnd

                
Y = reshape(image_PCs_cube, pxl_no, PC_number)';

m = 6;

[l,N]=size(Y);  % N here is the number of pixels

%  Computation of the distances between vectors
 
distt=zeros(N,N);

for i=1:N
    distt(i,:)=sum((Y(:,i)*ones(1,N)-Y).^2);
end
 
e2 = max(max(distt));
sigma2 = max(max(distt));

clear Y;

% e2 = e2 * 1;   %  between e2 and  e2* 0.00001 to capture local structures
% sigma2 = sigma2 *0.01; % for e2 between 0.001 and 0.001
 
e2 = e2 * 0.001;   %  between e2 and  e2* 0.00001 to capture local structures
sigma2 = sigma2 *0.001; % for e2 between 0.001 and 0.001
 
% e2 = e2 * 0.01;   %  between e2 and  e2* 0.00001 to capture local structures
% sigma2 = sigma2 *0.001; % for e2*.001 between 0.001 and 0.001


% Computation of the weight matrix W

W=exp(-distt/(2*sigma2)).*(distt<e2^2);
D=diag(sum(W));

%Computation of the matrices L, L tilda (L1)

L=D-W;

%Eigendecomposition of L (solving L*V=D*V*E)

[V,E]=eig(L,D);
de=diag(E);
[Y,I]=sort(de);

%Number of zero or almost zero eigenvalues

t=sum(Y<10^(-9));

%The m eigenvectors that correspond to m smallest nonzero
%eigenvalues

KAS_data = V(:,I(t+1:t+m))';

%   KAS_data: mxN matrix whose rows are the eigevectors that
%   correspond to the m smallest nonzero eigenvalues of L. In
%   addition, the i-th column of y defines the projection of the i-th
%   data vector to the m-dimensional space.

for I = 1 : m
    
    eval(['slice' num2str(I) '=reshape(KAS_data(' num2str(I) ',:), block, block);'])
    
end


for II = 1 : m
    eval(['imagesc(handles.axes' num2str(II) ', slice' num2str(II) ')' ])
    colormap('hot')
end   
plot(handles.scatter, KAS_data(1,:), KAS_data(2,:), 'g*','MarkerSize',10);

        
        end
   end
end

