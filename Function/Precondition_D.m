function D_adjusted = Precondition_D(D, c)
    max_val = max(D(:));
    
    min_target = max_val / c;
    
    D_adjusted = D;
    
    last_small_element_index = [];
    
    for i = 1:size(D, 1)
        for j = 1:size(D, 2)
            if D_adjusted(i, j) < min_target
                new_val = min_target + (max_val - min_target) * rand();
                D_adjusted(i, j) = new_val;
                last_small_element_index = [i, j];
            end
        end
    end
    
    if ~isempty(last_small_element_index)
        D_adjusted(last_small_element_index(1), last_small_element_index(2)) = min_target;
    else
        D_adjusted(end, end) = min_target;
    end
end