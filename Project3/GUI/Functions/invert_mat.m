function dijk_SAR_02 = invert_mat(SAR_02)
%INVERT Summary of this function goes here
%   Detailed explanation goes here
[~,m] = size(SAR_02);
for i = 1: m
    for j = 1: m
        if SAR_02(i,j) ~= 0
            dijk_SAR_02(i,j) = (SAR_02(i,j))^(-1);
        else
            dijk_SAR_02(i,j) = 1000;
        end
    end
end

end

