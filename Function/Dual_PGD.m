function [result,t] = Dual_PGD(mu,n,m,B,D,opts)
% Outer loop - Sequential convex programming
% Inner loop - Convex programming by converting to dual and use pgd

%% Notes: Directly use $\mu$, no $t$.
%% Parameter Setting
outer_epsilon = opts.outer_epsilon; % Tolerance for stopping criterion - outer loop
inner_epsilon = opts.inner_epsilon; % Tolerance for stopping criterion - inner loop
max_iter = opts.max_iter; % Maximum number of outer iterations
max_inner_iter = opts.max_inner_iter;
stepsize = opts.stepsize; % eta in the paper
inner_stepsize = opts.inner_stepsize;
logD = log(D);

%% Initialization
lambda = ones(n,m).*(B'/(m*stepsize)); 
% lambda = ones(n,m)/(m*stepsize); % This version is wrong
b = sum(B);

%% Ini for measure-old: will update in the outer loop iteration
max_mu = max(mu); % enhance computation stability
temp = exp(mu-max_mu);
q = b*temp/sum(temp);
measure_old = q + mu*stepsize;

%% Outer Loop
% DCA Algorithm
tic
value_list = [];

for iter = 1:max_iter
    % Solve the inner convex subproblem
    [mu_new,lambda_new] = Dual_PGD_Inner_solver(mu,lambda,B,logD,inner_epsilon,max_inner_iter,stepsize,inner_stepsize); % So in the inner solver -> x->c->initial lambda->final lambda->final x  
    % Calculate q
    max_mu = max(mu_new); % enhance computation stability
    temp = exp(mu_new-max_mu);
    q = b*temp/sum(temp);
    % Calculate sub differential
    % \lambda g(before) - \lambda g(now)
    % stepsize count here
    measure_new = q + mu_new*stepsize;
    measure_vec = abs(measure_old - measure_new);
    measure = norm(measure_vec ./q,inf);
    measure_old = measure_new;
    value_list = [value_list, measure];
    % Stopping criterion - use function value directly
    if measure < outer_epsilon || iter ==max_iter
        % disp(['Dual PGD variable gap: ',norm(x_new(1:m)-x(1:m),2)])
        % disp(['Dual PGD outer iteration: ',num2str(iter)])
        mu = mu_new;
        break;
    end
    mu = mu_new;
    lambda = lambda_new;
end
t = toc;
disp(['DCA-PGD Loop: ',num2str(iter)])
disp(['DCA-PGD Time ', num2str(t)]);
result = struct();
result.iter = iter;
result.time = t;
result.gap = value_list;
% Display the final result
% disp(['Dual_PGD Outer Loop: ',num2str(iter)])
% disp(['Dual_PGD Time ', num2str(t)]);
% 
% % Plotting the graph
% figure(2)
% plot(value_list, 'o-');
% xlabel('Iteration');
% ylabel('Iterate Gap of PGD');
% title('Iterate Gap');
% grid on;