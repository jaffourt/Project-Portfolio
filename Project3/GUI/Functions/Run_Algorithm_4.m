function Run_Algorithm_4(reward,handles)
[j,i] = size(reward);
% get GUI gamma value
gamma = get(handles.slider3,'Value');

%Check which optimal pathway is used
if handles.policybutton.Value == 1
    R = create_reward_matrix_1(reward,j*i);
elseif handles.dijkstrabutton.Value == 1
    R = create_reward_matrix(reward,j*i);
end

%q or sarsa
if handles.qbutton.Value == 1
    [Q,JJ] = q_learning(R,gamma,j*i);
elseif handles.sarsabutton.Value ==1
    [Q,JJ] = sarsa(R,gamma,j*i);
end

%output
if handles.policybutton.Value == 1
    find_optimal_paths(JJ,j*i,reward);
elseif handles.dijkstrabutton.Value == 1
    invertedmat = invert_mat(Q);
    [~,route]=dijkstra(invertedmat,1,i*j);
    plot_dijk(route,reward);
end

end

