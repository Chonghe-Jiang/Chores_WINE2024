function V_adjusted = Precondition_B(V, c)
    % 找出向量中的最大元素
    max_val = max(V);
    
    % 计算最小元素的目标值
    min_target = max_val / c;
    
    % 初始化调整后的向量
    V_adjusted = V;
    
    % 记录最后一个小于目标值的元素的索引
    last_small_element_index = [];
    
    % 遍历向量中的每个元素
    for i = 1:length(V)
        % 如果当前元素小于目标值
        if V_adjusted(i) < min_target
            % 在目标值和最大值之间随机选择一个值
            new_val = min_target + (max_val - min_target) * rand();
            % 更新向量元素
            V_adjusted(i) = new_val;
            % 记录最后一个小于目标值的元素的索引
            last_small_element_index = i;
        end
    end
    
    % 将最后一个小于目标值的元素设置为目标值
    if ~isempty(last_small_element_index)
        V_adjusted(last_small_element_index) = min_target;
    else
        % 如果所有元素都大于等于目标值，那么最后一个元素设置为目标值
        V_adjusted(end) = min_target;
    end
end