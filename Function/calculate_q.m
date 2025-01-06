function q = calculate_q(mu, B)
    % mu = mu(:);
    % B = B(:);
    b = sum(B);
    max_mu = max(mu); 
    temp= exp(mu-max_mu);
    q = b*temp/sum(temp);
end

