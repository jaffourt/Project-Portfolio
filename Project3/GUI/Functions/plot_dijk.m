function plot_dijk(route, reward)
%PLOT_DIJK Summary of this function goes here
%   Detailed explanation goes here
 path = route;
 [~, s] = size(path);
    
    % plot the path
    load('hsi_image.mat');
    %imagesc(hsi_image(:,:,1)); % zeros(13*32,7*32)
    meshCanopy(rgb2gray(hsi_image),imgaussfilt(reward,.75),'jet',20);
    hold on;

    counter = 0;
    sounter = 0;
    found = 0;
    for j = 1 : 46
        sounter = sounter + 1;
        tat1 = (((sounter-1) * 32) + 1);   
        tat2 = sounter * 32; 
        founter = 0;
        for i = 1 : 7  
            counter = counter + 1;
            founter = founter + 1;
            tatt1 = (((founter-1) * 32) + 1);  
            tatt2 = founter * 32;
           
           % check each value in the path, is it the same as the chip which
           % is the current iteration? If yes, then draw it on image.
           for chip = 1 : s
                if counter == path(1,chip) 
                    plot3([tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1], [2 2 2 2 2], 'color', 'red', 'LineWidth', 1.75)
                    found = found + 1;
                    if rem(found,7) == 0
                        text(((tatt1+tatt2)/2)-12, (tat1+tat2)/2, 8, num2str(counter),'Color','blue','FontSize',12.0,'FontWeight', 'bold');
                        plot3([((tatt1+tatt2)/2)-4 ((tatt1+tatt2)/2)-4], [(tat1+tat2)/2 (tat1+tat2)/2], [2 7], ':b', 'LineWidth', 1.75);
                        drawnow;
                        
                    end
                end
           end
        end
    end

end

