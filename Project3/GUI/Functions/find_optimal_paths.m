function path = find_optimal_paths(JJ, end_state, reward)
%   find_optimal_paths
%       - JJ is a matrix containing the maximal rewarding action for each
%       state.
%       - end_state is an integer value for the desired chip.

%   This function simply follows the path predetermined from JJ. Starting
%   with the first image chip, the function finds the most rewarding action
%   given from JJ, and changes the "current_state" to that value. It
%   repeats this method until the "current_state" is equal to "end_state".

    found = false;
    m = 1; % starting image chip
    % outer while loop allows for every state to be the starting node
    while ~found
        
        n = m; 
        counter = 1;
       
        % from n follow maximal action until condition met
        while (n ~= end_state)
            
            % important check
            if (counter > 5) 
                % is the path repeating? if yes then break and start from a
                % new node, (m = m+1, line 49).
                if (path(m,counter-1) == path(m,counter-3) && path(m,counter-1) == path(m,counter-5))
                    break;

                end
            end
            
            % keep track of the path so far
            path(m,counter) = n;
            
            % where to go next?
            location = JJ(n);
            n = location;
            
            % this counter allows for the "path" matrix to be
            % multidimensional. It records the history of past paths
            counter = counter+1;
        end
        
        % condition for outer while loop
        % if not finished, try a new starting node
        if (n == end_state)
            found = true;
        else
           m = m+1;
        end
        
    end
    
    % finish up
    path(m, counter) = n;
    [~, s] = size(path);
    
    % plot the path
    load('hsi_image.mat');
    % imagesc(hsi_image(1:14*32,1:7*32,1)); % zeros(13*32,7*32)
    meshCanopy(rgb2gray(hsi_image),imgaussfilt(reward,.75),'jet',20);
    hold on;
    
    found = 0;
    counter = 0;
    sounter = 0;
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
                if counter == path(m,chip)
                    found = found + 1;
%                     if counter == 1
%                         plot3([tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1], [2 2 2 2 2], 'color', 'green', 'LineWidth', 1.75);
%                         text(((tatt1+tatt2)/2)-12, (tat1+tat2)/2, 5, num2str(counter),'Color','green','FontSize',12.0,'FontWeight', 'bold');
%                         plot3([((tatt1+tatt2)/2)-4 ((tatt1+tatt2)/2)-4], [(tat1+tat2)/2 (tat1+tat2)/2], [2 4], ':g', 'LineWidth', 1.75);
%                     elseif counter == end_state
%                         plot3([tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1], [2 2 2 2 2], 'color', 'red', 'LineWidth', 1.75);
%                         text(((tatt1+tatt2)/2)-12, (tat1+tat2)/2, 5, num2str(counter),'Color','red','FontSize',12.0,'FontWeight', 'bold');
%                         plot3([((tatt1+tatt2)/2)-4 ((tatt1+tatt2)/2)-4], [(tat1+tat2)/2 (tat1+tat2)/2], [2 4], ':r', 'LineWidth', 1.75);
%                     else
%                         plot3([tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1], [2 2 2 2 2], 'color', 'yellow', 'LineWidth', 1.75);
%                         if rem(found,4) == 0
%                             text(((tatt1+tatt2)/2)-12, (tat1+tat2)/2, 5, num2str(counter),'Color','yellow','FontSize',12.0,'FontWeight', 'bold');
%                             plot3([((tatt1+tatt2)/2)-4 ((tatt1+tatt2)/2)-4], [(tat1+tat2)/2 (tat1+tat2)/2], [2 4], ':y', 'LineWidth', 1.75);
%                         end
%                     end
                        plot3([tatt1 tatt2 tatt2 tatt1 tatt1], [tat1 tat1 tat2 tat2 tat1], [2 2 2 2 2], 'color', 'red', 'LineWidth', 1.75);
                        if rem(found,7) == 0
                            text(((tatt1+tatt2)/2)-12, (tat1+tat2)/2, 5, num2str(counter),'Color','blue','FontSize',12.0,'FontWeight', 'bold');
                            plot3([((tatt1+tatt2)/2)-4 ((tatt1+tatt2)/2)-4], [(tat1+tat2)/2 (tat1+tat2)/2], [2 4], ':b', 'LineWidth', 1.75);
                        end
                end
           end
        end
    end
    
    % for GUI
    % setappdata(0,'root',path);
end

