function project_x = projection_simplex(x,B,n,m)

% Original Reformulation
project_x = zeros(n,m);
for i = 1:n
    y = x(i,:)/B(i); 
    s = sort(y,'descend'); tmpsum = 0;
    for ii = 1:m-1
        tmpsum = tmpsum + s(ii);
        tmax = (tmpsum - 1)/ii;
        if tmax >= s(ii+1)
            break;
        end
    end
    project_x(i,:) = B(i)*max(y-tmax,0);
end

%project_x = project_x(:);





