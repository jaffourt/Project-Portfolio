% Performing Q-learning

function [q,JJ]=q_learning(R, gamma, goalState)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Q learning of single agent move in N rooms 
% Matlab Code companion of 
% Q Learning by Example, by Kardi Teknomo 
% (http://people.revoledu.com/kardi/)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


format short
format compact

A=5000;
% Two input: R and gamma
if nargin<1
% immediate reward matrix; row and column = states; -A = no door between room
    R=[-A, -A, -A, -A, 50, 50, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %A
       -A, -A, -A, -A, -A, 70, 30, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %B
       -A, -A, -A, -A, -A, -A, 50, 50, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %C
       -A, -A, -A, -A, -A, -A, -A, 30, 70, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %D
       10, -A, -A, -A, -A, -A, -A, -A, -A, 30, 60, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %E
       5, 10, -A, -A, -A, -A, -A, -A, -A, -A, 60, 25, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;           %F
       -A, 10, 10, -A, -A, -A, -A, -A, -A, -A, -A, 30, 50, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %G
       -A, -A, 5, 5, -A, -A, -A, -A, -A, -A, -A, -A, 50, -A, 40, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;            %H
       -A, -A, -A, 10, -A, -A, -A, -A, -A, -A, -A, -A, 35, 55, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %I
       -A, -A, -A, -A, 60, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 40, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %J
       -A, -A, -A, -A, 10, 10, -A, -A, -A, -A, -A, -A, -A, -A, -A, 10, 70, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %K
       -A, -A, -A, -A, -A, 10, 10, -A, -A, -A, -A, -A, -A, -A, -A, -A, 80, -A, -A, -A, -A, -A, -A, -A, -A, -A;          %L
       -A, -A, -A, -A, -A, -A, 10, 10, -A, -A, -A, -A, -A, -A, -A, -A, 30, 50, -A, -A, -A, -A, -A, -A, -A, -A;          %M
       -A, -A, -A, -A, -A, -A, -A, -A, 55, -A, -A, -A, -A, -A, -A, -A, -A, -A, 45, -A, -A, -A, -A, -A, -A, -A;          %N
       -A, -A, -A, -A, -A, -A, -A, 10, 10, -A, -A, -A, -A, -A, -A, -A, -A, 50, 30, -A, -A, -A, -A, -A, -A, -A;          %O
       -A, -A, -A, -A, -A, -A, -A, -A, -A, 25, 50, -A, -A, -A, -A, -A, -A, -A, -A, 25, -A, -A, -A, -A, -A, -A;          %P
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 10, 10, 10, -A, -A, -A, -A, -A, -A, 10, 10, 50, -A, -A, -A, -A;          %17 Q
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 3, -A, 3, -A, -A, -A, -A, -A, 3, 35, 55, -A, -A, -A;             %18 R
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 20, 20, -A, -A, -A, -A, -A, -A, -A, 60, -A, -A, -A;          %19 S
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 15, 35, -A, -A, -A, -A, -A, -A, 50, -A, -A;          %20 T
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 10, 10, -A, -A, -A, -A, -A, 35, 45, -A;          %21 U
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 10, 10, -A, -A, -A, -A, -A, -A, 40, 40;          %22 V
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 10, 10, -A, -A, -A, -A, -A, -A, 80;          %23 W
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 0, 0, -A, -A, 100, -A, -A;           %24 X
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 0, 0, -A, -A, 100, -A;           %25 Y
       -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, -A, 0, 0, -A, -A, 100];          %26 Z
end
if nargin<2
    gamma=0.1;              % learning parameter
end
if nargin<3
    goalState=26;
end

[a,b] = size(R);
if (a ~= b)
    error("Matrix is not square.");
end

q=zeros(size(R));        % initialize Q as zero
q1=ones(size(R))*A;    % initialize previous Q as big number
count=0;
T = 5000;

%counter
time_counter = 0;

%QQ = zeros(26,26, T);

h = waitbar(0,'Agent is learning.');
for episode=0:T

    %time_counter = time_counter + 1;
   
    %random initial state
    y=randperm(size(R,1));
    state=1;            % current state

    while state~=goalState            % loop until find goal state
%        select any action from this state
        
        
        x=find(R(state,:)>=0);         % find possible action of this state
        if size(x,1)>0

            x1=RandomPermutation(x);   % randomize the possible action
            x1=x1(1);                  % select an action (only the first element of random sequence)
        end

        qMax=max(q,[],2);
        q(state,x1)= R(state,x1)+gamma*qMax(x1);     % get max of all actions from the next state for Q of current state
        state=x1;

    end
    %break if convergence: small deviation on q for 1000 consecutive
    if sum(sum(abs(q1-q)))<0.0001 && sum(sum(q >0))
        if count>1000
              % report last episode
            break % for
        else
            count=count+1; % set counter if deviation of q is small
        end
    else
        q1=q;
        count=0;  % reset counter when deviation of q from previous q is large
     end
     %QQ(:,:,time_counter) =q;
      try
        waitbar(episode/5000,h);
     catch
         error("Canceled");
         return
     end
end    
close(h);

%normalize q
g=max(max(q));
if g>0 
    q=100*q/g;
end
% episode
[~,JJ] = max(q'); % Provide the best action for each state -q(s,a) -> q(a,s) ->q(s)
%                   % Result is a series of states q(s) which comes from the
              % best action

     