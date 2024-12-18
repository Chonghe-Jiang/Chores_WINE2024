function [mu,lambda] = MD_AGD_Inner_solver(mu,lambda,B,logD,inner_epsilon,low_inner_epsilon,max_inner_iter,stepsize,inner_stepsize_md,inner_stepsize_pgd)
%% Data preparation
[n,m] = size(logD);
c = (sum(B)/stepsize)*(exp(mu)/sum(exp(mu)))+mu; % Generate the coefficient vector c[j]; arrow style; remember the sign
lambda = ones(n,m).*(B'/(m*stepsize));
for iteration = 1:max_inner_iter
    % lambda = ones(n,m)/(m*stepsize) ;
    gradient = repmat(sum(lambda)-c,n,1)+logD;
    current_update = (-inner_stepsize_md) * gradient;
    temp1 = exp(current_update);
    temp2 = temp1.*lambda;
    sum_temp2 = repmat(stepsize*sum(temp2,2)./B',1,m);
    lambda_new = temp2./sum_temp2;
    if  norm(sum(lambda_new)-sum(lambda))/inner_stepsize_md < low_inner_epsilon
        lambda = lambda_new;
        break
    end
    lambda = lambda_new;
end

for new_iteration = iteration:max_inner_iter
    %% PGD Implementation - AGD NOT STABLE
    gradient = repmat(sum(lambda)-c,n,1)+logD;
    % gradient = -Q_dual'*(Q_dual*lambda - c')-p;
    current_update = inner_stepsize_pgd * gradient;
    lambda_new = projection_simplex(lambda - current_update,B/stepsize,n,m);
    if  norm(sum(lambda_new)-sum(lambda))/inner_stepsize_pgd < inner_epsilon
        lambda = lambda_new;
        break;
    end
    lambda = lambda_new;
end
%% Print iteration
% fprintf('Iteration for MD: %d\n', iteration); % Print iteration value
% fprintf('Iteration for PGD: %d\n', new_iteration); % Print new_iteration value
mu = c - sum(lambda);
end