function [mu,lambda] = Dual_PGD_Inner_solver(mu0,lambda0,B,logD,inner_epsilon,max_inner_iter,stepsize,inner_stepsize)
%% Data prepsration
[n,m] = size(logD);
c = (sum(B)/stepsize)*(exp(mu0)/sum(exp(mu0)))+mu0; % Part of the gradient

%% For loop for gradient descent
lambda = ones(n,m).*(B'/(m*stepsize)); 

for iteration = 1:max_inner_iter
    % Compute the gradient
    gradient = repmat(sum(lambda)-c,n,1)+logD;
    % Update of the iterative point
    current_update = inner_stepsize * gradient;
    lambda_new = projection_simplex(lambda - current_update,B/stepsize,n,m); % Projection
    if  norm(sum(lambda_new)-sum(lambda))/inner_stepsize < inner_epsilon
          lambda = lambda_new;
          break;
    end
    lambda = lambda_new;
end
%% Convert the dual variable to the primal one
mu = c - sum(lambda);
end