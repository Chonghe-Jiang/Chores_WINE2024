function [mu,lambda] = Dual_PGD_Inner_solver(mu0,lambda0,B,logD,inner_epsilon,max_inner_iter,stepsize,inner_stepsize)
%% Data prepsration
[n,m] = size(logD);
c = (sum(B)/stepsize)*(exp(mu0)/sum(exp(mu0)))+mu0; % -part of the gradient (1,m) row vector

%% For loop for gradient descent
%% Ini by last iteration/unified
% lambda = lambda0;
% lambda = ones(n,m).*(B'/(m*stepsize));
lambda = ones(n,m).*(B'/(m*stepsize)); 



for iteration = 1:max_inner_iter
    % Compute the gradient
    gradient = repmat(sum(lambda)-c,n,1)+logD; % 1*m spread to n*m
    % gradient = -Q_dual'*(Q_dual*lambda - c')-p; 
    current_update = inner_stepsize * gradient; 
    lambda_new = projection_simplex(lambda - current_update,B/stepsize,n,m);
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
mu = c - sum(lambda); % 1*m row vector
iteration
end
