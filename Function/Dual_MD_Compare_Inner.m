function [mu,lambda,state] = Dual_MD_Compare_Inner(mu0,lambda0,B,logD,inner_epsilon,max_inner_iter,stepsize,inner_stepsize,inner_stepsize_pgd,max_inner_iter_pgd,state)
%% Data prepsration
[n,m] = size(logD);
c = (sum(B)/stepsize)*(exp(mu0)/sum(exp(mu0)))+mu0; % Genrate the coefficient vector c[j];arrow style; remember the sign
state = state;
%% For loop for gradient descent
%lambda = projection_simplex(lambda0,B/stepsize,n,m); % Initialization for lambda
lambda = ones(n,m).*(B'/(m*stepsize));
% lambda = lambda0 ;
f_list = [];
for iteration = 1:max_inner_iter_pgd
    % Compute the gradient
    gradient = repmat(sum(lambda)-c,n,1)+logD;
    f = (1/2) * norm(sum(lambda)-c,2)^2 + trace(logD'*lambda);
    f_list = [f_list,f];
    % Update of the iterative point
    current_update = inner_stepsize_pgd * gradient;
    lambda_new = projection_simplex(lambda - current_update,B/stepsize,n,m); % Projection
    if  norm(sum(lambda_new)-sum(lambda))/inner_stepsize_pgd < inner_epsilon
          current_error = norm(sum(lambda_new)-sum(lambda))/inner_stepsize_pgd;
          lambda = lambda_new;
          break;
    end
    lambda = lambda_new;
end
lambda_pgd = lambda;
iteration_pgd = iteration;
if iteration_pgd == max_inner_iter_pgd && state == 0
    figure
    plot(f_list);
    state = 1;
end



%% For loop for MD
lambda = ones(n,m).*(B'/(m*stepsize));
for iteration = 1:max_inner_iter
    % Compute the gradient
    gradient = repmat(sum(lambda)-c,n,1)+logD;
    % gradient = -Q_dual'*(Q_dual*lambda - c')-p; 
    current_update = (-inner_stepsize) * gradient;
    temp1 = exp(current_update);
    temp2 = temp1.*lambda;
    sum_temp2 = repmat(stepsize*sum(temp2,2)./B',1,m);
    lambda_new = temp2./sum_temp2;
    %lambda_new = projection_simplex(lambda - current_update,B/stepsize,n,m);
    if  norm(sum(lambda_new)-sum(lambda))/inner_stepsize < inner_epsilon
          lambda = lambda_new;
          break;
    end
    lambda = lambda_new;
end
% dual_value_pgd = -(1/2)*norm(c-n_sum(lambda,m,n),2)^2 - p'*lambda;
% disp(['Function value for the dual problem: ',num2str(dual_value_pgd)])
% x = c - n_sum(lambda,m,n);
%% Convert the dual variable to the primal one
%x = [c-n_sum(lambda_new,m,n);zeros(n,1)];
mu = c - sum(lambda);
error = norm(lambda_pgd-lambda)/norm(lambda)
iteration_pgd
end