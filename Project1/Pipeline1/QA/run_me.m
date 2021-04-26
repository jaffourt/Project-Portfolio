data=readtable('subjs.csv');
for i = 1 : size(data,1)
    %evlab_save_activation_maps(data.Session{i}, lookup(data.FL{i}),'S-N','./S-N',0.001)
    evlab_save_activation_maps(data.Session{i}, lookup(data.FL{i}),'N-S','./N-S',0.001)
end

function value = lookup(key)

    switch key
        case 'DiffTasks_1'
            value = 'langloc_DiffTasks_1';
        otherwise
            value=key;
    end
    return
end