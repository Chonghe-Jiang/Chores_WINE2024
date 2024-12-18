function value = f(x,m,n,B,D)
value = 0;
for i = 1:n
    max_term = zeros(m,1);
    for j = 1:m
        max_term(j) = x(j)-log(D(i,j));
    end
    value = value + B(i)*max(max_term);
end
value = value - sum(B)*log(sum(exp(x(1:m))));
end

