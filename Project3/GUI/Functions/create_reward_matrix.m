function R = create_reward_matrix(reward_field, final_state)
% Input Arguments:
%    - reward Field is an m x n matrix. 
%    - final_state is target image chip.
% Creates a reward matrix for a row x col passed matrix


% Instant Reward Matrix (R) is a matrix representation for an undirected
% graph. Meaning, a graph with N nodes will have an R matrix of size N x N.
% This function is used for Q-Learning, so the R matrix is interpreted as N
% states, with N actions. Of course, depending on the structure of the
% graph some node N_i will not have N actions available, those actions
% which are unavailable are denoted with a -Inf value. Any real value is
% an available action. Furthermore, if you look at row 5 you are
% looking at the "State" for node number 5. Each column denotes the action
% of moving to that new respective state. E.g., in state 5 the 6th column has a
% value of 50. This means that from state 5, moving to state 6 is a
% rewarding action (50 reward units). If the value in column 15 is -Inf,
% that means that State 5 and State 15 are not connected, thus you cannot
% move into that state.

% The construction of R for any rectangular or square image is as follows*:

% *This version allows for complete freedom of movement within the bounds
%  of the image. Left column and right column are not connected because this
%  R matrix represents a real environment.

% test case
if nargin<1
    reward_field = zeros(2);
end

% get dimensions
[row, col] = size(reward_field);
size_R = row*col;

% Create R matrix, and initialize it to all -inf. No states are connected.
R = ones(size_R).*(-inf);

%add rewards test case -- completed after for loop
if nargin < 2
    final_state = size(reward_field,1)*size(reward_field,2);
end

% avoid errors
if final_state>size_R
    error("Reward State value is larger than number of locations.");
elseif final_state <= 0
    error("Reward State must be 1 or greater.");
end

%% R Matrix Size and Connections
for n = 1 : size_R
    
    % This for loop iterates N times, through each row it looks at which
    % columns should be set to 0 and which should be set to -Inf. If the
    % state can take an action to another state the value for that action
    % is set to 0.
    
    % some indices are set to 0 more than once.. no harm 
    % kept for simplicity
    
    % check for corners and connect them to other nodes
    if n == 1 % top left
        R(n,n+1) = 0; % Right Neighbor
        R(n,n+col) = 0; % Bottom Neighbor
        R(n,n+col+1) = 0; % Bottom-Right Diagonal Neighbor
        
    elseif n == col % top right
        R(n,n-1) = 0; % Left Neighbor
        R(n,n+col) = 0; % Bottom Neighbor
        R(n,n+col-1) = 0; % Bottom-Left Diagonal Neighbor
        
    elseif n == size_R - col + 1 % bottom left
        R(n,n+1) = 0; % Right Neighbor
        R(n,n-col) = 0; % Bottom Neighbor
        R(n,n-col+1) = 0; % Bottom-Right Diagonal Neighbor
        
    elseif n == size_R % bottom right
        R(n,n-1) = 0; % This methodology repeats ... 
        R(n,n-col) = 0;
        R(n,n-col-1) = 0;
    
    % check bottom and top row
    elseif (n>1 && n<col)
        R(n,n-1) = 0;
        R(n,n+1) = 0;
        R(n,n+col) = 0;
        R(n,n+col+1) = 0;
        R(n,n+col-1) = 0;
        
    elseif (n >(size_R-col+1) && n < size_R)
        R(n,n-1) = 0;
        R(n,n+1) = 0;
        R(n,n-col) = 0;
        R(n,n-col-1) = 0;
        R(n,n-col+1) = 0;
   
    % check right and left columns
    elseif mod(n,col) == 1 % left column
        R(n,n-col) = 0;
        R(n,n+1) = 0;
        R(n,n-col+1) = 0;
        R(n,n+col) = 0;
        R(n,n+col+1) = 0;
        
    elseif mod(n,col) == 0 % right column
        R(n,n-1) = 0;
        R(n,n+col-1) = 0;
        R(n,n+col) = 0;
        R(n,n-col) = 0;
        R(n,n-col-1) = 0;
        
    % middle piece 
    else
        R(n,n-1) = 0;
        R(n,n+1) = 0;
        R(n,n-col-1) = 0;
        R(n,n-col) = 0;
        R(n,n-col+1) = 0;
        R(n,n+col-1) = 0;
        R(n,n+col) = 0;
        R(n,n+col+1) = 0;
    end

end
%barebones R matrix complete

%% Add Reward Values to R based on Reward Field

% This method works by changing different row's values, based on if they
% can move into the state being looked at. E.g., the chip is the
% state and the value is the reward so that any state that can take an action
% into the chip's state is given the value's reward.

for n = 1 : row % iterate rows
    for m = 1 : col % iterate columns
        chip = m*n;
        value = reward_field(n,m); % reward field value
        if value ~= 0 %if zero then change R accordingly
            % change connected nodes action values based on location
            % and reward_field value at n, m
            if chip == 1 % top left
                R(chip+1,chip) = value;
                R(chip+col,chip) = value;
                R(chip+col+1,chip) = value;
            elseif chip == col % top right
                R(chip-1, chip) = value;
                R(chip+col-1, chip) = value;
                R(chip+col, chip) = value;    
            elseif chip == size_R - col + 1 % bottom left
                R(chip-col, chip) = value;
                R(chip-col+1, chip) = value;
                R(chip+1, chip) = value;   
            elseif chip == size_R % bottom right
                R(chip-1, chip) = value;
                R(chip-col, chip) = value;
                R(chip-col-1, chip) = value;

            % check bottom and top row
            elseif (chip>1 && chip<col) %top row
                R(chip-1, chip) = value;
                R(chip+1, chip) = value;
                R(chip + col -1, chip) = value;
                R(chip + col, chip) = value;
                R(chip + col + 1, chip) = value;
            elseif (chip >(size_R-col+1) && chip < size_R) %bottom row
                R(chip-1, chip) = value;
                R(chip+1, chip) = value;
                R(chip-col-1, chip) = value;
                R(chip-col, chip) = value;
                R(chip-col+1, chip) = value;

            % check right and left columns
            elseif mod(chip,col) == 1 % left column
                R(chip + 1, chip) = value;
                R(chip + col, chip) = value;
                R(chip + col + 1, chip) = value;
                R(chip - col + 1, chip) = value;
                R(chip - col, chip) = value;
            elseif mod(chip,col) == 0 % right column
                R(chip - 1, chip) = value;
                R(chip + col, chip) = value;
                R(chip + col - 1, chip) = value;
                R(chip - col - 1, chip) = value;
                R(chip - col, chip) = value;
            % middle piece 
            else
                R(chip-col-1, chip) = value;
                R(chip-col, chip) = value;
                R(chip-col+1, chip) = value;
                R(chip-1, chip) = value;
                R(chip+1, chip) = value;
                R(chip+col-1, chip) = value;
                R(chip+col, chip) = value;
                R(chip+col+1, chip) = value;
            end
        end
    end
end

%% Add End State Reward Values

% Given a end state, any action into this state is maximally rewarded. 

%complete nargin<2 if statement
if nargin<2
    R(final_state-1, final_state) = 100;
    R(final_state-col, final_state) = 100;
    R(final_state-col-1, final_state) = 100;
end

% add reward values determined by final state

if final_state == col % top right
    R(final_state-1, final_state) = 100;
    R(final_state+col-1, final_state) = 100;
    R(final_state+col, final_state) = 100;    
elseif final_state == size_R - col + 1 % bottom left
    R(final_state-col, final_state) = 100;
    R(final_state-col+1, final_state) = 100;
    R(final_state+1, final_state) = 100;   
elseif final_state == size_R % bottom right
    R(final_state-1, final_state) = 100;
    R(final_state-col, final_state) = 100;
    R(final_state-col-1, final_state) = 100;
    
% check bottom and top row
elseif (final_state>1 && final_state<col) %top row
    R(final_state-1, final_state) = 100;
    R(final_state+1, final_state) = 100;
    R(final_state + col -1, final_state) = 100;
    R(final_state + col, final_state) = 100;
    R(final_state + col + 1, final_state) = 100;
elseif (final_state >(size_R-col+1) && final_state < size_R) %bottom row
    R(final_state-1, final_state) = 100;
    R(final_state+1, final_state) = 100;
    R(final_state-col-1, final_state) = 100;
    R(final_state-col, final_state) = 100;
    R(final_state-col+1, final_state) = 100;
    
% check right and left columns
elseif mod(final_state,col) == 1 % left column
    R(final_state + 1, final_state) = 100;
    R(final_state + col, final_state) = 100;
    R(final_state + col + 1, final_state) = 100;
    R(final_state - col + 1, final_state) = 100;
    R(final_state - col, final_state) = 100;
elseif mod(final_state,col) == 0 % right column
    R(final_state - 1, final_state) = 100;
    R(final_state + col, final_state) = 100;
    R(final_state + col - 1, final_state) = 100;
    R(final_state - col - 1, final_state) = 100;
    R(final_state - col, final_state) = 100;
% middle piece 
else
    R(final_state-col-1, final_state) = 100;
    R(final_state-col, final_state) = 100;
    R(final_state-col+1, final_state) = 100;
    R(final_state-1, final_state) = 100;
    R(final_state+1, final_state) = 100;
    R(final_state+col-1, final_state) = 100;
    R(final_state+col, final_state) = 100;
    R(final_state+col+1, final_state) = 100;
end

end

