function [D_new, B_new] = scale_matrices_to_conditions(D, B, D_condition, B_condition, isint)
    D_max = max(D(:));
    D_min = min(D(:));
    current_D_condition = D_max / D_min;
    
    B_max = max(B);
    B_min = min(B);
    current_B_condition = B_max / B_min;
    
    scale_factor_D = sqrt(D_condition / current_D_condition);
    scale_factor_B = sqrt(B_condition / current_B_condition);
    D_scaled = D * scale_factor_D;
    B_scaled = B * scale_factor_B;
    
    if isint
        D_new = round(D_scaled);
        D_new(D_new < 1) = 1;
        D_new(D_new > 1000) = 1000;
    else
        D_new = D_scaled;
        B_new = B_scaled;
    end
end
