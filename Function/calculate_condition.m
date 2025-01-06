function [D_condition, B_condition] = calculate_conditions(D, B)
    D_max = max(D(:));
    D_min = min(D(:));
    D_condition = D_max / D_min;
    B_max = max(B);
    B_min = min(B);
    B_condition = B_max / B_min;
end
