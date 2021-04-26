%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Riverside Research HSI Optimal Location Estimation Algorithm %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Blood Stained Clothing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Suite of codes for PCA, BSAS, ATGP, K-means, Laplacian Eigenmaps,


% Disclaimer: These codes are a prototype of algorithms
% They in no way constitute official tools backed by Riverside Research

tic

clear
% Load data
% addpath c:/jaffourtit/Affourtit_files
% addpath c:/users/jaffourtit/desktop
% addpath c:/jaffourtit/Affourtit_files/SCC_data/three/Scan_00100

% addpath c:/backup_Affourtit/Affourtit_files

% cd  c:/backup_Affourtit/Affourtit_files/blind_test/HyMap
cd  g:/HSI_bloodstain/HyMap

x = multibandread('blind_test_refl.img', [280, 800, 126], 'int16', 0, 'bil', 'ieee-le');

% Clip data cube and get size specifications

figure(1)
imagesc(x(:,:, 6))
title('HSI')
colorbar
% stoppp

x_new = x(1:280,1:800,1:126);

dd = size(x_new);             % size of the hyperspectral data

% Plot data 

gsd = 1;
ratios = 1;


% Recursive Processing of HSI image chips that are 32 X 32
% Target Dictionary Learning

block = 32;

num_blocky = floor( dd(1)/block);
num_blockx = floor( dd(2)/block);

founter = 0; 
count = 0;

rounter = 0;

pix_row = 1;
pix_col = 1;

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

           image_ROI = x_new( tat1 : tat2, tatt1: tatt2, :);

          % Plot data snippet in real coordinates & save plot

            figure(1)
            imagesc( 0.5*(1: block), 0.5*(1: block), image_ROI(:,:, 2) );
            title('Hyperspectral Image - 2nd Band')
            xlabel('x - meters') 
            ylabel('y - meters') 
            colorbar
            colormap('hot')

           %  eval(['print -djpeg image_data_' num2str(count)])

           [xr, yr, bnd] = size(image_ROI);

            pxl_no = xr * yr;

            %% Reshape data into matrix that is bnd X pxl_no 
            %% Band dimension = rows and pxl_no = columns

            r = reshape(image_ROI, pxl_no, bnd)';

%%%%%%%%%%%%%%%%%%%%%%%%% Calculate Virtual Dimension %%%%%%%%%%%%%%%%%%%%%


% Band dimension transposes to rows and pxl_no transposes to columns
% Correlation Matrix

R = (r*r')/pxl_no;

% Creates vector whose length is number of bands

u = mean(r,2);

% Covariance Matrix

K = R - u*u';

% Compute Eigenvalues of the Correlation and Covariance Matrix

D1 = sort(eig(R));
D2 = sort(eig(K));

clear R; clear K;  clear u;


% Threshold which depends on aprior set False Alarm Probability (FAP)

% First component of D1 and D2 is Eigenvalue

sita = sqrt((D1.^2 + D2.^2) * 2/pxl_no);


% Neyman-Pearson detector to determine the number of spectral bands.
% Trade offs b/w detection pwr and FAP exist.

P_fa = 0.05;            % 95% sure that you do not have any false alarms 

% As the false alarm detection probability gets larger, you get more spectral bands or PCs.
% More PCs mean you can detect more but also  means that probability of false
% alarms goes up. 
% As false alarm detection probability gets smaller, you get less PCs.
% Less PCs mean you can detect less but also means the probability of false
% alarms goes down

% Noise Variance Threshold based on FAP and Eigenvalues from correlation and
% Covariance Matrices

Threshold = sqrt(2)* sita * erfinv(1-2*P_fa);

clear sita;
clear P_fa;

% Test each band to see if exceeds the noise variance threshold for a certain FAP

Result = 0;

for m = 1 : bnd
    if (( D1(m,1) - D2(m,1)) > Threshold(m,1))
        Result(m,1) = 1;
    else
        Result(m,1) = 0;
    end
    
end


%%fprintf('The VD number estimated is');
%%disp(sum(Result))

% cd c:/nick/HSI_processing/DSTK2
% save('results3.mat', 'Result', '-mat')


% Sum Result to get a constant

PC_number = sum(Result);
PC_number = 20;

clear D1; clear D2;

clear Threshold; %clear Result;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%Finished Calculating Virtual Dimension %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

                         clear eigenval; clear eigenvec; clear Y;
                         clear A; clear X_zero

                        image_PCs = zeros(32,32,251);
                        for I = 1 : bnd

                          image_PCs(:,:,I) = reshape( e4(I,:), xr, yr );
                        end
                       %% Plot Principal components
    %{                
figure(2)
subplot(3,3,1)
imagesc(image_PCs(:,:,1))
title('1st Principal Component')
colorbar

subplot(3,3,2)
imagesc(image_PCs(:,:,2))
title('2nd Principal Component')
colorbar

subplot(3,3,3)
imagesc(image_PCs(:,:,3))
title('3rd Principal Component')
colorbar

subplot(3,3,4)
imagesc(image_PCs(:,:,4))
title('4th Principal Component')
colorbar

subplot(3,3,5)
imagesc(image_PCs(:,:,5))
title('5th Principal Component')
colorbar

subplot(3,3,6)
imagesc(image_PCs(:,:,6))
title('6th Principal Component')
colorbar

subplot(3,3,7)
imagesc(image_PCs(:,:,7))
title('7th Principal Component')
colorbar

subplot(3,3,8)
imagesc(image_PCs(:,:,8))
title('8th Principal Component')
colorbar
%}
%% Save imagery

% cd c:/nick/HSI_processing/results_nasic

% eval(['print -djpeg PC_components_' num2str(count)])
    
% Reshape imagery from matrix into slices

[mm, nn, bands] = size(image_PCs);

image_PCs_cube = image_PCs(:, :, 1:PC_number);
                

    %% Clear variables
                     
     %clear image_PCs;
     clear mm; clear nn; clear bands;

     clear e1; clear e2; clear e4; clear e5;

     clear energy_vec; 

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
     [ a, b] = max(temp);
     
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
      num_targets = 6;  % CHANGE THIS TO 3
      
      for m = 2: num_targets
          
           U = Sig;
           P_U_perl =eye(bnd) -U*inv(U'*U)* U';
           y = P_U_perl*r;
           temp = sum(y.*y);
           [a,b] = max(temp);
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
      
           % disp
           % figure;
           % imagesc(image_PCs_cube(:, :, 30);
           % colormap(gray)
           % hold on
           % axis off
           % axis equal
           % for m= 1 : size(Loc,1)
           % plot(Loc(m,1),Loc(m,2), 'o','color','g');
           % text(Loc(m,1) + 2, Loc(m,2), num2str(m), 'color', 'y', 'Fontsize', 12); 
           % end
          
           %  loc(:,1) = Loc(:,2);
           %  loc(:,2) = Loc(:,1);
           
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%                K-means Clustering                 %%%%
      %%%%%%%%%%%%%%%%%Target Dictionary Learning 2 %%%%%%%%%%%
      %%%%%%%%%%%%%%% Sparse Decomposition%%%%%%%%%%%%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      K = num_targets;
      [IDX, C] = kmeans( r', K);  
      
      % Save Spectral Signatures found by the ATGP and K-means Clustering 
      % in long matrix
      
      rounter = rounter + 1;
      blockss = K;
      
      tat1a = (((rounter-1) * blockss) + 1);   
      tat2a = rounter * blockss; 
       
      % Spectral Dictionary for ATGP
      Spec_cube1(:, tat1a:tat2a )= Sig;

      % Spectral Dictionary for K-means
      Spec_cube2(:, tat1a:tat2a )= C';
        end 
   end
   
      
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Basic Sequential Algorithms  - BSAS %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% %%%%%    Target Spectral Dictionary Formulation    %%%%%%%%%%%%%
%%%%%%%%%% Redundancy Reduction of the Target Spectral Dictionary  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    ATGP     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pall = 60;
data = Spec_cube1;

q = 7;  % Controls the amount spectral signatures in dictionary for domain
theta = 2.5;

[l,N]=size(data);

order=1:1:N;

% Cluster determination phase

n_clust=1;  % no. of clusters

[l,N]=size(data);
bel1=zeros(1,N);
bel1(order(1))=n_clust;
repre1=data(:,order(1));

for i=2:N
   [m1,m2]=size(repre1);
   
% Determining the closest cluster representative}}

   [s1,s2]=min(sqrt(sum((repre1-data(:,order(i))*ones(1,m2)).^2)));
   
   if(s1>theta) && (n_clust<q)
       n_clust=n_clust+1;
       bel1(order(i))=n_clust;
       repre1=[repre1 data(:,order(i))];
   else

% Pattern classification phase(*4)}}
       bel1(order(i))=s2;
       repre1(:,s2)=((sum(bel1==s2)-1)*repre1(:,s2) + data(:,order(i)))/sum(bel1==s2);
   end
end

bel_later1 = bel1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Clustering Refinement %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[l,N]=size(data);
[l,n_clust]=size(repre1);

for i=1:N
    [q1,q2]=min(sum((data(:,i)*ones(1,n_clust)-repre1).^2));
    bel1(i)=q2;
end

Spec_sig1=zeros(l,n_clust);

for j=1:n_clust
    Spec_sig1(:,j)=sum(data(:,bel1==j)')'/sum(bel1==j);
end


%Plot distribution for clusters

%figure(pall+4)
%hist(bel1, q);
%title('Histogram of Clusters')

% eval(['cd c:/nick/HSI_processing/Cicely/results' num2str(sounter) '_' num2str(founter)])

% print -djpeg clus_refine_hist

%raster1 = hist(bel1, q);
% rasters = sort(raster, 'ascend');

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Basic Sequential Algorithms  - BSAS %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Target Dictionary Formulation  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Redundancy Reduction of the Target Spectral Dictionary  %%%%%%
%%%%%%%%%%%%%%%%%%%%% K Means Clustering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pall = 60;
data = Spec_cube2;

q = 7; % Controls the amount spectral signatures in dictionary for domain
theta = 2.5;

[l,N]=size(data);

order=1:1:N;

% Cluster determination phase

n_clust=1;  % no. of clusters

[l,N]=size(data);
bel2=zeros(1,N);
bel2(order(1))=n_clust;
repre2=data(:,order(1));

for i=2:N
   [m1,m2]=size(repre2);
   
% Determining the closest cluster representative}}

   [s1,s2]=min(sqrt(sum((repre2-data(:,order(i))*ones(1,m2)).^2)));
   
   if(s1>theta) && (n_clust<q)
       n_clust=n_clust+1;
       bel2(order(i))=n_clust;
       repre2=[repre2 data(:,order(i))];
   else

% Pattern classification phase(*4)}}
       bel2(order(i))=s2;
       repre2(:,s2)=((sum(bel2==s2)-1)*repre2(:,s2) + data(:,order(i)))/sum(bel2==s2);
   end
end

bel_later = bel2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Clustering Refinement %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[l,N]=size(data);
[l,n_clust]=size(repre2);

for i=1:N
    [q1,q2]=min(sum((data(:,i)*ones(1,n_clust)-repre2).^2));
    bel2(i)=q2;
end

Spec_sig2=zeros(l,n_clust);
for j=1:n_clust
    Spec_sig2(:,j)=sum(data(:,bel2==j)')'/sum(bel2==j);
end


%Plot distribution for clusters
%{
figure(pall+4)
hist(bel2, q);
title('Histogram of Clusters')
%}
% eval(['cd c:/nick/HSI_processing/Cicely/results' num2str(sounter) '_' num2str(founter)])

% print -djpeg clus_refine_hist

%raster2 = hist(bel2, q);
% rasters = sort(raster, 'ascend');
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Normalization of Spectral Signatures in Target Dictionary %%%%%%
%%%%%%%%%%%% This if for the Orthogonal Matching Pursuit%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

     for GG = 1 : size(Spec_cube1,2)
         
           vecx = Spec_cube1(:,GG);
           z1 = (vecx - mean(vecx(1:length(vecx),1)))/var(vecx(1:length(vecx),1));  %% maximum orthogonal dictionary
           ATGP_new(:,GG) = z1;
     end
     
     for GG = 1 : size(Spec_cube2,2)
         
           vecx = Spec_cube2(:,GG);
           z2 = (vecx - mean(vecx(1:length(vecx),1)))/var(vecx(1:length(vecx),1)); %% non orthogonal dictionary
           Kmeans_new(:,GG) = z2;
     end
          
  
     
     
     
     
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Cost Field Estimation for the Image Chips %%%%%%%%%%%%%%%%%%   
%%%%%%% Recursive Processing of HSI image chips that are 32 X 32 %%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Matched filter Abundance Estimation for Image Chips  %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block = 32;

num_blocky = floor( dd(1)/block);
num_blockx = floor( dd(2)/block);

ffounter = 0; 
scounter  = 0;
ccount = 0;

pix_row = 1;
pix_col = 1;

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

           image_ROI = x_new(tat1 : tat2, tatt1: tatt2, :);

                     
          % Plot data snippet in real coordinates & save plot
%{
            figure(2)
            imagesc( 0.5*(1: block), 0.5*(1: block), image_ROI(:,:, 2) );
            title('Hyperspectral Image - 2nd Band')
            xlabel('x - meters') 
            ylabel('y - meters') 
            colorbar
            colormap('hot')
 %}
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

                         clear eigenval; clear eigenvec; clear Y;
                         clear A; clear X_zero
                         
                     
                        %Calculate Covariance and Mean of Image_PCss

                        for I = 1 : PC_number

                          image_PCss(:,:,I) = reshape( e4(I,:), xr, yr );
                          
                        end
                        
                       rr = reshape(image_PCss, pxl_no, PC_number)';

                       xa = rr;
       
                      %% Subtracting the mean

                         mean_vect = mean(xa')';

                         XX_zero = rr - mean_vect*ones(1,P);

                      %% Computing the covariance matrix and its eigenvalues/eigenvectors
                        
                         RR = cov(XX_zero');

                         cov_mat(:,:,ccount) = RR;
                         mean_mat(:,ccount) = mean_vect;

                         clear RR;
                       %% Plot Principal components
 %{                   
figure(3)
subplot(3,3,1)
imagesc(image_PCss(:,:,1))
title('1st Principal Component')
colorbar

subplot(3,3,2)
imagesc(image_PCss(:,:,2))
title('2nd Principal Component')
colorbar

subplot(3,3,3)
imagesc(image_PCss(:,:,3))
title('3rd Principal Component')
colorbar

subplot(3,3,4)
imagesc(image_PCss(:,:,4))
title('4th Principal Component')
colorbar

subplot(3,3,5)
imagesc(image_PCss(:,:,5))
title('5th Principal Component')
colorbar

subplot(3,3,6)
imagesc(image_PCss(:,:,6))
title('6th Principal Component')
colorbar

subplot(3,3,7)
imagesc(image_PCss(:,:,7))
title('7th Principal Component')
colorbar

subplot(3,3,8)
imagesc(image_PCss(:,:,8))
title('8th Principal Component')
colorbar
%}
%% Save imagery

% cd c:/nick/HSI_processing/results_nasic

% eval(['print -djpeg PC_components_' num2str(count)])
    
% Reshape imagery from matrix into slices

[mm, nn, bands] = size(image_PCss);

image_PCss_cube = image_PCss(:, :, 1:PC_number);
                

    %% Clear variables
                 

     clear e1; clear e2; clear e4; clear e5;

     clear energy_vec; 


     %% Reshape data into matrix that is bnd X pxl_no 
     %% Band dimension = rows and pxl_no = columns

     pc_data = reshape(image_PCss_cube, mm*nn, PC_number)';
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
     % Perform Maximum Abundance Estimation for Image Chip%% 
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
     % Constrain Abundance using NCSLS                     %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

     Spec_sig1 = (sortrows(Spec_sig1'))';
  
      [f1, f2] = size( pc_data);
      
      MatrixZ = Spec_sig1;
      tol = 10^(-5);
      
     for RR = 1 : f2
         
     M = size(MatrixZ, 2);
     
     R = zeros(M,1);
     P = ones(M,1);
     invMtM = (MatrixZ'*MatrixZ)^(-1);
     Alpha_ls= invMtM* MatrixZ'*pc_data(:,RR);
     Alpha_ncls= Alpha_ls;
     min_Alpha_ncls= min(Alpha_ncls);
     
     j=0;
     
     while(min_Alpha_ncls< -tol && j<500)
         
         j =  j + 1;
         for II = 1 :M
             if((Alpha_ncls(II) <0) && (P(II)==1))
                 
                 R(II) = 1;
                 P(II) = 0;
                 
             end 
         end 
         S = R;
         
                 
         counter = 0;

         goto_step6 =1;
         
         while(goto_step6 ==1)
             
             index_for_Lamda = find(R==1);
             Alpha_R = Alpha_ls(index_for_Lamda);
             Sai= invMtM(index_for_Lamda, index_for_Lamda) ;
             
             inv_Sai= Sai^(-1);
             
             Lamda = inv_Sai*Alpha_R;
             
             [max_Lamda, index_Max_Lamda] = max(Lamda);
             counter = counter + 1;
             if  (max_Lamda<=0 || counter ==200)
                 break
             end
             temp_i= inv_Sai;
             temp_i(1, :) = inv_Sai(index_Max_Lamda,:);
           
              if index_Max_Lamda>1
                  temp_i(2:index_Max_Lamda, :)= inv_Sai(1:index_Max_Lamda-1,:);
                  
              end
             
              inv_Sai_ex = temp_i;
              inv_Sai_ex(:,1) = temp_i(:,index_Max_Lamda);
              if index_Max_Lamda> 1
                  
                  inv_Sai_ex(:, 2:index_Max_Lamda) = temp_i(:,1:index_Max_Lamda-1);
              end
              inv_Sai_next = inv_Sai_ex(2:end, 2:end) - inv_Sai_ex(2:end, 1) * inv_Sai_ex(1,2:end)/inv_Sai_ex(1,1);
            
           P(index_for_Lamda(index_Max_Lamda))=1;
           R(index_for_Lamda(index_Max_Lamda))=0;

           index_for_Lamda(index_Max_Lamda)=[];

          Alpha_R = Alpha_ls(index_for_Lamda);
          Lamda = inv_Sai_next*Alpha_R;
          Phai_column= invMtM(:,index_for_Lamda);
          
              if(size(Phai_column,2) ~=0)
                  Alpha_s = Alpha_ls-Phai_column*Lamda;
              else
                  Alpha_s = Alpha_ls;
              end
              
              goto_step_6= 0;
              
              for II = 1 : M
                  
                  if ((S(II)==1) && (Alpha_s(II)<0))
                      P(II) =0;
                      R(II) = 1;
                      goto_step6=1;
                  end
              end 
         end
         
         
         index_for_Phai= find(R==1);
         Phai_column = invMtM(:,index_for_Phai);
         
         if(size(Phai_column, 2)~=0)
             Alpha_ncls = Alpha_ls-Phai_column*Lamda;
         else
             Alpha_ncls = Alpha_ls;
         end
         min_Alpha_ncls = min(Alpha_ncls);
     end  
     
     
     abundance =  zeros(M, 1);
     
     for II= 1: M
         if(Alpha_ncls(II)>0)
             abundance(II) = Alpha_ncls(II);
         end 
     end
     
     ABUNDANCE(:,RR) = abundance';
     
     end
     % return
     
     % Reshape abundance matrix into a cube
     

                        for IV = 1 : M

                          ABUND1(:,:,IV) = reshape( ABUNDANCE(IV,:), mm, nn );
                          
                        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


      [f1, f2] = size( pc_data);
      
      MatrixZ =Spec_sig2;
      tol = 10^(-5);
      
     for RR = 1 : f2
         
     M= size(MatrixZ, 2);
     
     R = zeros(M,1);
     P = ones(M,1);
     invMtM = (MatrixZ'*MatrixZ)^(-1);
     Alpha_ls= invMtM* MatrixZ'*pc_data(:,RR);
     Alpha_ncls= Alpha_ls;
     min_Alpha_ncls= min(Alpha_ncls);
     
     j=0;
     
     while(min_Alpha_ncls< -tol && j<500)
         
         j =  j + 1;
         for II = 1 :M
             if((Alpha_ncls(II) <0) && (P(II)==1))
                 
                 R(II) = 1;
                 P(II) = 0;
                 
             end 
         end 
         S = R;
         
                 
         counter = 0;

         goto_step6 =1;
         
         while(goto_step6 ==1)
             
             index_for_Lamda = find(R==1);
             Alpha_R = Alpha_ls(index_for_Lamda);
             Sai= invMtM(index_for_Lamda, index_for_Lamda) ;
             
             inv_Sai= Sai^(-1);
             
             Lamda = inv_Sai*Alpha_R;
             
             [max_Lamda, index_Max_Lamda] = max(Lamda);
             counter = counter + 1;
             if  (max_Lamda<=0 || counter ==200)
                 break
             end
             temp_i= inv_Sai;
             temp_i(1, :) = inv_Sai(index_Max_Lamda,:);
           
              if index_Max_Lamda>1
                  temp_i(2:index_Max_Lamda, :)= inv_Sai(1:index_Max_Lamda-1,:);
                  
              end
             
              inv_Sai_ex = temp_i;
              inv_Sai_ex(:,1) = temp_i(:,index_Max_Lamda);
              if index_Max_Lamda> 1
                  
                  inv_Sai_ex(:, 2:index_Max_Lamda) = temp_i(:,1:index_Max_Lamda-1);
              end
              inv_Sai_next = inv_Sai_ex(2:end, 2:end) - inv_Sai_ex(2:end, 1) * inv_Sai_ex(1,2:end)/inv_Sai_ex(1,1);
            
           P(index_for_Lamda(index_Max_Lamda))=1;
           R(index_for_Lamda(index_Max_Lamda))=0;

           index_for_Lamda(index_Max_Lamda)=[];

          Alpha_R = Alpha_ls(index_for_Lamda);
          Lamda = inv_Sai_next*Alpha_R;
          Phai_column= invMtM(:,index_for_Lamda);
          
              if(size(Phai_column,2) ~=0)
                  Alpha_s = Alpha_ls-Phai_column*Lamda;
              else
                  Alpha_s = Alpha_ls;
              end
              
              goto_step_6= 0;
              
              for II = 1 : M
                  
                  if ((S(II)==1) && (Alpha_s(II)<0))
                      P(II) =0;
                      R(II) = 1;
                      goto_step6=1;
                  end
              end 
         end
         
         
         index_for_Phai= find(R==1);
         Phai_column = invMtM(:,index_for_Phai);
         
         if(size(Phai_column, 2)~=0)
             Alpha_ncls = Alpha_ls-Phai_column*Lamda;
         else
             Alpha_ncls = Alpha_ls;
         end
         min_Alpha_ncls = min(Alpha_ncls);
     end  
     
     
     abundance =  zeros(M, 1);
     for II= 1: M
         if(Alpha_ncls(II)>0)
             abundance(II) = Alpha_ncls(II);
         end 
     end
     
     ABUNDANCE(:,RR) = abundance';
     
     end
     % return
     
     % Reshape abundance matrix into a cube
     

                        for IV = 1 : M

                          ABUND2(:,:,IV) = reshape( ABUNDANCE(IV,:), mm, nn );
                          
                        end                         
       

%   figure(30)
%   subplot(2,2,1)
%   imagesc(ABUND1(:,:,1))
%   colorbar
%    
%   subplot(2,2,2)
%   imagesc(ABUND2(:,:,1))
%   colorbar
%    
%   subplot(2,2,3)
%   imagesc(ABUND1(:,:,3))
%   colorbar
%    
%   subplot(2,2,4)
%   imagesc(ABUND2(:,:,3))
%   colorbar
%   
%   
%   figure(31)
%   subplot(2,2,1)
%   imagesc(ABUND1(:,:,5))
%   colorbar
%    
%   subplot(2,2,2)
%   imagesc(ABUND2(:,:,5))
%   colorbar
%   
%   subplot(2,2,3)
%   imagesc(ABUND1(:,:,7))
%   colorbar
%    
%   subplot(2,2,4)
%   imagesc(ABUND2(:,:,7))
%   colorbar
%   
%   
%   figure(32)
%   subplot(2,2,1)
%   imagesc(ABUND1(:,:,9))
%   colorbar
%    
%   subplot(2,2,2)
%   imagesc(ABUND2(:,:,9))
%   colorbar
%   
%   subplot(2,2,3)
%   imagesc(ABUND1(:,:,11))
%   colorbar
%    
%   subplot(2,2,4)
%   imagesc(ABUND2(:,:,11))
%   colorbar
%   

                        
  num_sigs = 7; % CHANGE THIS TO 3
    
    for Id = 1 : num_sigs

%            max_abund1(Id)=  max(max(ABUND1(:,:, Id)));
%            max_abund2(Id)=  max(max(ABUND2(:,:, Id)));
      
             mean_val = median(ABUND1(:,:,Id));
             mean_abund1(Id) = median(mean_val);

             mean_val = median(ABUND2(:,:,Id));
             mean_abund2(Id) = median(mean_val);

    end


     % Extract the spectral signature coordinate associated with the 
     % maximum abundance value for each image chip

         % [Aval1, maxc1] = max((max_abund1));
         
          maxc1 = median(mean_abund1);

          maxc2 = median(mean_abund2);

          maxc3 = floor(median((find(abs(mean_abund1-maxc1) < 10^-14))));
          
          maxc4 = floor(median((find(abs(mean_abund2-maxc2) < 10^-14))));
    
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          Reward_abundance1(scounter, ffounter) = maxc3 ;   % = [ 1 2 3 4 5 6 7 8 9 ... ];
          
          Reward_abundance2(scounter, ffounter) = maxc4 ;   % = [ 1 2 3 4 5 6 7 8 9 ... ];

       
       
     % Remember to Assign value to each of the spectral signatures later on
 
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Sparse Decomposition of Image Chip Data Using Redundant Dictionary %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
      % Median spectral signature of the complete target dictionary
      % Median  value across for each spectral band.
      % Reference spectral signature
      
         mod_val_c1_vec = mode(ATGP_new');

         mod_val_c2_vec = mode(Kmeans_new');
         
         % Perform OMP on image chip
         
      [A1] = OMP(ATGP_new,pc_data, 6);     % ATGP_new, Kmeans_new (M x K)-> 20 by (6* 45*7(315)) = 1890 spectra signals, 1024 (32*32) X 275 signals
      [A2] = OMP(Kmeans_new,pc_data, 6 );  % pc_data-> 20 by 1024 (M x P)  
                                           % 20 spectral bands and 6 spec signatures
   
      % Scan through all the spectral profiles in image chip
      % Select characteristic spectral coordinate associated with maximum abundance
      % for each pixel
      
      for PP = 1 : size(A1, 2)   % A1 = 1890 X 1024
          
          vect1 = A1(:,PP);
          [b1, b2] = max(vect1);
          char_spec_coor1(PP) = b2;
          
          vect2 = A2(:,PP);
          [fd1, fd2] = max(vect2);
          char_spec_coor2(PP) = fd2;
        
      end
         
      % Mode spectral signature coordinate = characteristic spectral
      % signature
      
         char_spec_c1(scounter, ffounter) = mode(char_spec_coor1);

         char_spec_c2(scounter, ffounter) = mode(char_spec_coor2);
         
         char_sig_c1(:,ccount) = ATGP_new(:,char_spec_c1(scounter, ffounter));

         char_sig_c2(:,ccount) = Kmeans_new(:,char_spec_c2(scounter, ffounter));
         
         YAS1 = [ mod_val_c1_vec'  char_sig_c1(:,ccount)];
         YAS2 = [ mod_val_c2_vec'  char_sig_c2(:,ccount)];
         
         bep1 = 0;
         bep2 = 0;
         
         for hh1 = 1: size(YAS1,1)
             
             bep1 = (YAS1(hh1,1) - YAS1(hh1,2)).^2 + bep1;
             bep2 = (YAS2(hh1,1) - YAS2(hh1,2)).^2 + bep2;
         end
         
           mvcal1 = sqrt(bep1);
           mvcal2 = sqrt(bep2);
         
         
         % The larger the Euclidean distance between the characteristic 
         % spectral signature and the mode value of the complete target
         % dictionary, the smaller the reward. The mode value is dirt.
         
         % The larger the Euclidean distance between the characteristic 
         % spectral signature and the mode value of the complete target
         % dictionary, the GREATER the reward. The mode value is camouflage.
         
         %1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
         Reward_OMP1(scounter, ffounter) = mvcal1;
         Reward_OMP2(scounter, ffounter) = mvcal2;
     
         %    adjust proportional and inversely proportional       
         %    Reward_OMP1(scounter, ffounter) = mvcal1;
         %    Reward_OMP2(scounter, ffounter) = mvcal2; 
   
   
           % Mode Gradient Estimation
   
           [x1,y1] = meshgrid(-16:1:16, -16:1:16);
            
           [px,py] = gradient(image_PCss_cube(:,:,1),1,1);
           grads = sqrt(px.^2 + py.^2);
%{         
           contour(image_PCs_cube(:,:,1) ), hold on, quiver(px,py), hold off
           figure(3)
           imagesc(grads)
           title('Topographic Gradient')
           colorbar
           
          % Calculate Median Gradient for Image Chip
%}
           char_grad(scounter, ffounter) = mode(median(grads));
            
           % The larger the gradient, the smaller the reward
           
           % The larger the gradient, the GREATER the reward (Value)

           %2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
           Reward_grad(scounter, ffounter) = char_grad(scounter, ffounter);
           
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Laplacian EigenMap %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Performs Laplacian eigenmap based on the NxN dimensional
% graph Laplacian L, produced by an lxN dimensional matrix X, each column
% of which corresponds to a data vector. The algorithm determines the m
% N-dimensional eigenvectors that correspond to the m smallest nonzero
% eigenvalues.

% The threshold for the distance matrix and standard deviation envelope
% have to be tuned. 
               
%% Reshape data into matrix that is pxl_no X bnd

                
Y = reshape(image_PCss_cube, pxl_no, PC_number)';

m = 6;

[l,N]=size(Y);  % N here is the number of pixels
 
data = Y;

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
 
% e2 = e2 * 0.001;   %  between e2 and  e2* 0.00001 to capture local structures
% sigma2 = sigma2 *0.001; % for e2 between 0.001 and 0.001
%   
% e2 = e2 * 0.01;   %  between e2 and  e2* 0.00001 to capture local structures
% sigma2 = sigma2 *0.001; % for e2*.001 between 0.001 and 0.001

e2 = e2 * 0.01;   %  between e2 and  e2* 0.00001 to capture local structures
sigma2 = sigma2 *0.01; % for e2*.001 between 0.001 and 0.001

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

nall  = 6;

%figure(nall)

h1 = 3;
h2 = 2;
%{
for II = 1 : m
     
    eval(['subplot(' num2str(h1) ',' num2str(h2) ',' num2str(II) ')'])
    figure(II+nall)
    eval(['imagesc(slice' num2str(II) ')' ])
    title('Laplacian Eigenface')
    colormap(autumn)
    colorbar
end
% 
% cd c:/nick/HSI_processing/results_nasic
% 
% eval(['print -djpeg LE_components_' num2str(count)])
    
figure(5)

plot(KAS_data(1,:), KAS_data(2,:), 'r*','MarkerSize',10);

pause(2)
%}
Lap_eig_mat1( tat1 : tat2, tatt1: tatt2)= slice1;

Lap_eig_mat2( tat1 : tat2, tatt1: tatt2)= slice2;
% 
% % 
%             figure(40)
%             imagesc( 2.2*(1: 32), 2.2*(1: 32), Lap_eig_mat1(1:32, 1:32) );
%             title('Laplacian Eigenmap Image')
%             xlabel('x - meters') 
%             ylabel('y - meters') 
%             colorbar
%             colormap('hot')
%             
%             print -djpeg LE_last1
%             
%             figure(41)
%             imagesc( 2.2*(1: 240), 2.2*(1: 1400), Lap_eig_mat2(1:1400, 1:240) );
%             title('Laplacian Eigenmap Image')
%             xlabel('x - meters') 
%             ylabel('y - meters') 
%             colorbar
%             colormap('hot')
%          
%             print -djpeg LE_last2
%             
%             toc
%             
%             save x_new1 x_new 
% 
%             save LE1 Lap_eig_mat1
% 
%             save LE2 Lap_eig_mat2
  
 
      % Calculate Kurtosis associated with Laplacian eigenmap projection
      % If the kurtosis is high, this suggests a structure of certain scale
      % is present. This in turn means that the enemy who may be aware of
      % it will steer clear of the the area. Thus Reward is low.
      
      % The greater the kurtosis, the greater the reward
      
      %3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
      Reward_char_kurt1(scounter, ffounter) = kurtosis(kurtosis(slice1));
      Reward_char_kurt2(scounter, ffounter) = kurtosis(kurtosis(slice2));
 
      
        end
   end
      
 

% Calculate mode of image chip spectral signature distribution

    reference = mode(mode(Reward_abundance1));
    mode_signal = Spec_sig1(:,reference);

%  II = 3;
%  JJ=  1;
%          imag_chip_sig_coor = Reward_abundance1(JJ, II);   % = [ 1 2 3 4 5 6 7 8 9 ... 12];
%          imag_chip_sig_ref1 = Spec_sig1(:,imag_chip_sig_coor);

%  II = 3;
%  JJ=  45;
%          imag_chip_sig_coor = Reward_abundance1(JJ, II);   % = [ 1 2 3 4 5 6 7 8 9 ... 12];
%          imag_chip_sig_ref2 = Spec_sig1(:,imag_chip_sig_coor);
         
for II = 1 : ffounter
    
    for JJ = 1 : scounter
  
         imag_chip_sig_coor_chip1 = Reward_abundance1(JJ, II);   % = [ 1 2 3 4 5 6 7 8 9 ... 6];
         char_chip_sig1 = Spec_sig1(:,imag_chip_sig_coor_chip1);
         
        
         imag_chip_sig_coor_chip2 = Reward_abundance2(JJ, II);   % = [ 1 2 3 4 5 6 7 8 9 ... 6];
         char_chip_sig2 = Spec_sig2(:,imag_chip_sig_coor_chip2);
                    

         % Mahalanobis Distance  - Choose a reference image chip from 1 -
         % 315. Change the cov_mat index and mean_mat index.
         
                  
         %4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %The greater the MD the greater the reward (value)

         FAS =  squeeze(cov_mat(:,:,1));
         d1 = sqrt( (char_chip_sig1-mean_mat(:,1))'*inv(FAS)*(char_chip_sig1-mean_mat(:,1) ) );
         new_reward1(JJ,II) = d1;
         
                 
         %4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % The greater the MD the greater the reward (value)

         d2 = sqrt( (char_chip_sig2-mean_mat(:,1))'*inv(FAS)*(char_chip_sig2-mean_mat(:,1) ) );
         new_reward2(JJ,II) = d2;

             
         % Euclidean Distance
         
         YAS1 = [ mode_signal  char_chip_sig1 ];
         YAS2 = [ mode_signal  char_chip_sig2 ];

         bep1 = 0;
         bep2 = 0;
         
         for hh1 = 1: size(YAS1,1)
             
             bep1 = (YAS1(hh1,1) - YAS1(hh1,2)).^2 + bep1;
             bep2 = (YAS2(hh1,1) - YAS2(hh1,2)).^2 + bep2;

         end
         
         if bep1 <= .0000002
             new_reward11(JJ,II) = 1.75/10000;
             new_reward22(JJ,II) = 1.75/10000;

         else
                 
         mvcal1 = sqrt(bep1);
         mvcal2 = sqrt(bep2);
        
                 
         %4%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         % The greater the ED the greater the reward (value)

         new_reward11(JJ, II) = mvcal1;
         new_reward22(JJ, II) = mvcal2;

         end
       
         
    end
end 
   %}

   toc
   

     %}
         
      