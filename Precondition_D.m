function D_adjusted = Precondition_D(D, c)
    % 找出矩阵中的最大元素
    max_val = max(D(:));
    
    % 计算最小元素的目标值
    min_target = max_val / c;
    
    % 初始化调整后的矩阵
    D_adjusted = D;
    
    % 记录最后一个小于目标值的元素的索引
    last_small_element_index = [];
    
    % 遍历矩阵中的每个元素
    for i = 1:size(D, 1)
        for j = 1:size(D, 2)
            % 如果当前元素小于目标值
            if D_adjusted(i, j) < min_target
                % 在目标值和最大值之间随机选择一个值
                new_val = min_target + (max_val - min_target) * rand();
                % 更新矩阵元素
                D_adjusted(i, j) = new_val;
                % 记录最后一个小于目标值的元素的索引
                last_small_element_index = [i, j];
            end
        end
    end
    
    % 将最后一个小于目标值的元素设置为目标值
    if ~isempty(last_small_element_index)
        D_adjusted(last_small_element_index(1), last_small_element_index(2)) = min_target;
    else
        % 如果所有元素都大于等于目标值，那么最后一个元素设置为目标值
        D_adjusted(end, end) = min_target;
    end
end