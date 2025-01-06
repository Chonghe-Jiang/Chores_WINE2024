function V_adjusted = Precondition_B(V, c)
    max_val = max(V);
    
    min_target = max_val / c;
    
    V_adjusted = V;
    
    last_small_element_index = [];
    
    for i = 1:length(V)
        if V_adjusted(i) < min_target
            new_val = min_target + (max_val - min_target) * rand();
            V_adjusted(i) = new_val;
            last_small_element_index = i;
        end
    end
    
    if ~isempty(last_small_element_index)
        V_adjusted(last_small_element_index) = min_target;
    else
        V_adjusted(end) = min_target;
    end
end