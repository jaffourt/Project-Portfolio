function R = create_reward_matrix_1(reward_field, reward_state)
% Input Arguments:
%    - reward Field is an m x n matrix. 
%    - reward_state is target image chip.
% Creates a reward matrix for a row x col passed matrix

% test case
if nargin<1
    reward_field = zeros(2);
end

% get dimensions
[row, col] = size(reward_field);
size_R = row*col;
R = ones(size_R).*(-inf);

%add rewards test case -- completed after for loop
if nargin < 2
    reward_state = size(reward_field,1)*size(reward_field,2);
end

% avoid errors
if reward_state>size_R
    error("Reward State value is larger than number of locations.");
elseif reward_state <= 0
    error("Reward State must be 1 or greater.");
end

%% R Matrix Size and Connections
for n = 1 : size_R
    
    % The following if-else checks are made for two reasons:
    %   1. The graph is a rectangle, with image chips being
    %   connected to those adjacent to it.
    %   2. In this function, there is a transition function 
    %   which restricts the agent's movements.
    
    % check for corners and connect them to other nodes
    if n == 1 % top left
        %R(n,n+1) = 0; restricted movement: row traversal
        R(n,n+col) = 0;
        R(n,n+col+1) = 0;
    elseif n == col % top right
        %R(n,n-1) = 0; restricted movement: row traversal
        R(n,n+col) = 0;
        R(n,n+col-1) = 0;
    elseif n == size_R - col + 1 % bottom left
        %R(n,n+1) = 0; restricted movement: row traversal
        R(n,n-col) = 0;
        R(n,n-col+1) = 0;
    elseif n == size_R % bottom right
       % R(n,n-1) = 0; restricted movement: row traversal
        R(n,n-col) = 0;
        R(n,n-col-1) = 0;
    
    % check bottom and top row
    elseif (n>1 && n<col)
        %R(n,n-1) = 0; restricted movement: row traversal
        %R(n,n+1) = 0; restricted movement: row traversal
        R(n,n+col) = 0;
        R(n,n+col+1) = 0;
        R(n,n+col-1) = 0;
    elseif (n >(size_R-col+1) && n < size_R)
       % R(n,n-1) = 0; restricted movement: row traversal
        %R(n,n+1) = 0; restricted movement: row traversal
        R(n,n-col) = 0;
        R(n,n-col-1) = 0;
        R(n,n-col+1) = 0;
   
    % check right and left columns
    elseif mod(n,col) == 1 % left column
        %R(n,n-col) = 0; restricted movement: moving up a row
       % R(n,n+1) = 0; restricted movement: row traversal
        %R(n,n-col+1) = 0; restricted movement: moving up a row
        R(n,n+col) = 0;
        R(n,n+col+1) = 0;
        
    elseif mod(n,col) == 0 % right column
       % R(n,n-1) = 0; restricted movement: row traversal
        R(n,n+col-1) = 0;
        R(n,n+col) = 0;
        %R(n,n-col) = 0; restricted movement: moving up a row
        %R(n,n-col-1) = 0; restricted movement: moving up a row
        
    % middle piece 
    else
       % R(n,n-1) = 0; restricted movement: row traversal
       % R(n,n+1) = 0; restricted movement: row traversal
        %R(n,n-col-1) = 0; restricted movement: moving up a row
        %R(n,n-col) = 0; restricted movement: moving up a row
        %R(n,n-col+1) = 0; restricted movement: moving up a row
        R(n,n+col-1) = 0;
        R(n,n+col) = 0;
        R(n,n+col+1) = 0;
    end

end
%barebones R matrix complete

%% Add Reward Values to R based on Reward Field

% The following if-else checks are made for two reasons:
    %   1. The graph is a rectangle, with image chips being
    %   connected to those adjacent to it.
    %   2. In this function, there is a transition function 
    %   which restricts the agent's movements.

    %   The transition function is imposed in this section by limiting the 
    %   states values from a prohibited action. For example, the agent
    %   cannot move up a row, so the states in a row above are not given
    %   values from the value field, they are kept at -Inf. 
    
for n = 1 : row % iterate rows
    for m = 1 : col % iterate columns
        chip = m*n;
        value = reward_field(n,m); % reward field value
        if value ~= 0 %if zero then change R accordingly
            % change connected nodes action values based on location
            % and reward_field value at n, m
            if chip == 1 % top left
                %R(chip+1,chip) = value; restricted movement: row traversal
                %R(chip+col,chip) = value; restricted movement: moving up a row
                %R(chip+col+1,chip) = value; restricted movement: moving up a row
            elseif chip == col % top right
               % R(chip-1, chip) = value; restricted movement: row traversal
                %R(chip+col-1, chip) = value; restricted movement: moving up a row
                %R(chip+col, chip) = value; restricted movement: moving up a row    
            elseif chip == size_R - col + 1 % bottom left
                R(chip-col, chip) = value;
                R(chip-col+1, chip) = value;
                %R(chip+1, chip) = value; restricted movement: row traversal   
            elseif chip == size_R % bottom right
               % R(chip-1, chip) = value; restricted movement: row traversal
                R(chip-col, chip) = value;
                R(chip-col-1, chip) = value;

            % check bottom and top row
            elseif (chip>1 && chip<col) %top row
                %R(chip-1, chip) = value; restricted movement: row traversal
                %R(chip+1, chip) = value; restricted movement: row traversal
                %R(chip + col -1, chip) = value; restricted movement: moving up a row
                %R(chip + col, chip) = value; restricted movement: moving up a row
                %R(chip + col + 1, chip) = value; restricted movement: moving up a row
            elseif (chip >(size_R-col+1) && chip < size_R) %bottom row
               % R(chip-1, chip) = value; restricted movement: row traversal
               % R(chip+1, chip) = value; restricted movement: row traversal
                R(chip-col-1, chip) = value;
                R(chip-col, chip) = value;
                R(chip-col+1, chip) = value;

            % check right and left columns
            elseif mod(chip,col) == 1 % left column
              %  R(chip + 1, chip) = value; restricted movement: row traversal
                %R(chip + col, chip) = value; restricted movement: moving up a row
                %R(chip + col + 1, chip) = value; restricted movement: moving up a row
                R(chip - col + 1, chip) = value;
                R(chip - col, chip) = value;
            elseif mod(chip,col) == 0 % right column
              %  R(chip - 1, chip) = value; restricted movement: row traversal
                %R(chip + col, chip) = value; restricted movement: moving up a row
                %R(chip + col - 1, chip) = value; restricted movement: moving up a row
                R(chip - col - 1, chip) = value;
                R(chip - col, chip) = value;
            % middle piece 
            else
                R(chip-col-1, chip) = value;
                R(chip-col, chip) = value;
                R(chip-col+1, chip) = value;
              %  R(chip-1, chip) = value; restricted movement: row traversal
              %  R(chip+1, chip) = value; restricted movement: row traversal
                %R(chip+col-1, chip) = value; restricted movement: moving up a row
                %R(chip+col, chip) = value; restricted movement: moving up a row
                %R(chip+col+1, chip) = value; restricted movement: moving up a row
            end
        end
        
    end
end

%% Add End State Reward Values
%complete nargin<2 if statement
if nargin<2
    R(reward_state-1, reward_state) = 100;
    R(reward_state-col, reward_state) = 100;
    R(reward_state-col-1, reward_state) = 100;
end

% add reward values determined by final state
%   Transition function is applied exactly the same as previously, this is
%   just to add end_state rewards.

if reward_state == col % top right
   % R(reward_state-1, reward_state) = 100;
    R(reward_state+col-1, reward_state) = 100;
    R(reward_state+col, reward_state) = 100;    
elseif reward_state == size_R - col + 1 % bottom left
    R(reward_state-col, reward_state) = 100;
    R(reward_state-col+1, reward_state) = 100;
  %  R(reward_state+1, reward_state) = 100;   
elseif reward_state == size_R % bottom right
  %  R(reward_state-1, reward_state) = 100;
    R(reward_state-col, reward_state) = 100;
    R(reward_state-col-1, reward_state) = 100;
    
% check bottom and top row
elseif (reward_state>1 && reward_state<col) %top row
   % R(reward_state-1, reward_state) = 100;
   % R(reward_state+1, reward_state) = 100;
    R(reward_state + col -1, reward_state) = 100;
    R(reward_state + col, reward_state) = 100;
    R(reward_state + col + 1, reward_state) = 100;
elseif (reward_state >(size_R-col+1) && reward_state < size_R) %bottom row
   % R(reward_state-1, reward_state) = 100;
   % R(reward_state+1, reward_state) = 100;
    R(reward_state-col-1, reward_state) = 100;
    R(reward_state-col, reward_state) = 100;
    R(reward_state-col+1, reward_state) = 100;
    
% check right and left columns
elseif mod(reward_state,col) == 1 % left column
   % R(reward_state + 1, reward_state) = 100;
    R(reward_state + col, reward_state) = 100;
    R(reward_state + col + 1, reward_state) = 100;
    R(reward_state - col + 1, reward_state) = 100;
    R(reward_state - col, reward_state) = 100;
elseif mod(reward_state,col) == 0 % right column
  %  R(reward_state - 1, reward_state) = 100;
    R(reward_state + col, reward_state) = 100;
    R(reward_state + col - 1, reward_state) = 100;
    R(reward_state - col - 1, reward_state) = 100;
    R(reward_state - col, reward_state) = 100;
% middle piece 
else
    R(reward_state-col-1, reward_state) = 100;
    R(reward_state-col, reward_state) = 100;
    R(reward_state-col+1, reward_state) = 100;
  %  R(reward_state-1, reward_state) = 100;
  %  R(reward_state+1, reward_state) = 100;
    R(reward_state+col-1, reward_state) = 100;
    R(reward_state+col, reward_state) = 100;
    R(reward_state+col+1, reward_state) = 100;
end

end

