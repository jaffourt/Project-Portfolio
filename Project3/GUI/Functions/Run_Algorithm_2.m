function Run_Algorithm_2(data,handles)
%RUN_ALGORITHM_2 Summary of this function goes here
%   Detailed explanation goes here
drawnow
Spec_cube1 = data.spec1;
Spec_cube2 = data.spec2;
image_PCs = zeros(32,32,251);
x=data.x;
pause('on');

%%%%%%%%%%%%%% CLUSTER REFINEMENT %%%%%%%%%%%%%%%
pall = 60;
data = Spec_cube1;

q = 13;  % Controls the amount spectral signatures in dictionary for domain
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



 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Basic Sequential Algorithms  - BSAS %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Target Dictionary Formulation  %%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Redundancy Reduction of the Target Spectral Dictionary  %%%%%%
%%%%%%%%%%%%%%%%%%%%% K Means Clustering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pall = 60;
data = Spec_cube2;

q = 13; % Controls the amount spectral signatures in dictionary for domain
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

setappdata(handles.axes2, 'signal1',Spec_sig1)
setappdata(handles.axes2, 'signal2',Spec_sig2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% CLUSTERS PASSED FROM PART1 ARE NOW REFINED %%%%%%%%%%%%%
%%%%%%%%%%%%%%% BEGIN SECOND LOOP THROUGH IMAGE %%%%%%%%%%%%%%%%%%%%%
%%%% FIND ALL ABUNDANCES BY SOLVING MATRIX EQUATION AND DISPLAY %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_new = x(1:1376,1:256,6:256);
dd = size(x_new);
block = 32;

num_blocky = floor( dd(1)/block);
num_blockx = floor( dd(2)/block);

PC_number = 15;

ffounter = 0; 
ccount = 0;
scounter  = 0;
axes(handles.axes1);
imagesc(x_new(:,:,106));      % 106 is most vivid for this data
colormap('hot');
drawnow

hold on

Reward_abundance1 = zeros(43,8);
Reward_abundance2 = zeros(43,8);

   for QQ = 1 : num_blockx
    
         ffounter = ffounter + 1;
    
         tatt1 = (((ffounter-1) * block) + 1);  
    
         tatt2 = ffounter * block;
    
         scounter = 0;

    
        for Q = 1 : num_blocky
            
           drawnow
           stop_val = getappdata(handles.pushbutton1, 'paused');
           if stop_val == 1
               uiwait();
           end
           ccount = ccount + 1;

           scounter = scounter + 1;

           tat1 = (((scounter-1) * block) + 1);   
           tat2 = scounter * block; 
           
           
           
           plot(handles.axes1,[tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1],'k-')
           drawnow
           
           
           image_ROI = x_new(tat1 : tat2, tatt1: tatt2, :);
         


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

                       %% Plot Principal components

[mm, nn, bands] = size(image_PCs);

image_PCs_cube = image_PCs(:, :, 1:PC_number);
                

    %% Clear variables
                 

     clear e1; clear e2; clear e4; clear e5;

     clear energy_vec; 


     %% Reshape data into matrix that is bnd X pxl_no 
     %% Band dimension = rows and pxl_no = columns

      pc_data = reshape(image_PCs_cube, mm*nn, PC_number)';
     
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
     % Perform Maximum Abundance Estimation for Image Chip%% 
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
     % Constrain Abundance using NCSLS                     %
     Spec_sig1 = (sortrows(Spec_sig1'))';
  
      [f1, f2] = size( pc_data);
      
      MatrixZ =Spec_sig1;
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

      ABUND1(:,:,IV) = reshape( ABUNDANCE(IV,:), mm, nn );


    end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%% ATGP DONE %%%%%%%%%%%%%%%%%%%%%%
      
      %%%%%%%%%%% K MEANS BEGIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
       %%%%%%%%%%% K MEANS DONE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
       
       
       
       num_sigs = 13;
    
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
         
          maxc1 = median(mean_abund1);

          maxc3 = floor(median((find(abs(mean_abund1-maxc1) < 10^-14))));
          
          maxc2 = median(mean_abund2);

          maxc4 = floor(median((find(abs(mean_abund2-maxc2) < 10^-14))));
          
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          Reward_abundance1(scounter, ffounter) = maxc3 ;   % = [ 1 2 3 4 5 6 7 8 9 ... ];
          Reward_abundance2(scounter, ffounter) = maxc4 ;   % = [ 1 2 3 4 5 6 7 8 9 ... ];
  %1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        imagesc(handles.axes2, image_ROI(:,:,1));
        drawnow
  
        %%% plot dictionaries %%%%
        imagesc(handles.axes12,ABUND1(:,:,maxc3));
        axis(handles.axes12, 'off')
        
        imagesc(handles.axes13,ABUND1(:,:,2));
        axis(handles.axes13, 'off')
        
        imagesc(handles.axes14,ABUND1(:,:,3));
        axis(handles.axes14, 'off')
      
        imagesc(handles.axes15,ABUND1(:,:,4));
        axis(handles.axes15, 'off')
       
        imagesc(handles.axes16,ABUND1(:,:,5));
        axis(handles.axes16, 'off')
        
        imagesc(handles.axes24,ABUND1(:,:,6));
        axis(handles.axes24, 'off')
       
        drawnow
        
        imagesc(handles.axes17,ABUND2(:,:,maxc4));
        axis(handles.axes17, 'off')
        
        imagesc(handles.axes18,ABUND2(:,:,2));
        axis(handles.axes18, 'off')
 
        imagesc(handles.axes19,ABUND2(:,:,3));
        axis(handles.axes19, 'off')
        
        imagesc(handles.axes20,ABUND2(:,:,4));
        axis(handles.axes20, 'off')
         
        imagesc(handles.axes21,ABUND2(:,:,5));
        axis(handles.axes21, 'off')
         
        imagesc(handles.axes25,ABUND2(:,:,6));
        axis(handles.axes25, 'off')
         
        drawnow
        setappdata(handles.axes2, 'abun1', ABUND1);
        setappdata(handles.axes2, 'abun2', ABUND2);
    
        % what material?
        text(handles.axes1,((tatt1+tatt2)/2)-12, (tat1+tat2)/2,num2str(Reward_abundance1(Q,QQ)),'Color','green','FontSize',12.0,'FontWeight', 'bold');
        end
   end
setappdata(handles.axes2, 'reward1', Reward_abundance1);
setappdata(handles.axes2, 'reward2', Reward_abundance2);  
end








