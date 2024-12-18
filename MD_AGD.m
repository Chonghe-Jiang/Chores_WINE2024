function [result,t] = MD_AGD(mu,n,m,B,D,opts)
%% Parameter Setting
outer_epsilon = opts.outer_epsilon; % Tolerance for stopping criterion - outer loop
inner_epsilon = opts.inner_epsilon; % Tolerance for stopping criterion - inner loop
low_inner_epsilon = opts.low_inner_epsilon; % Tolerance for stopping criterion - switching criteria
max_iter = opts.max_iter; % Maximum number of outer iterations
max_inner_iter = opts.max_inner_iter;
stepsize = opts.stepsize;
inner_stepsize_md = opts.inner_stepsize_md;
inner_stepsize_pgd = opts.inner_stepsize_pgd;
logD = log(D);
b = sum(B);

%% SG to 1e-2
opts_sg = struct();
opts_sg.max_iter = 1e5; % Maximum number of outer iterations
opts_sg.mu0 = mu;
mode = 0; % mode = 0, low precision direct; 1 low precision two stage; 2 high precision
ratio = 1.3; % Calculated by He

%% Start timing - SG start
tic;
[result_SG, t_SG] = SG_mode(mode, n, m, B, D, ratio, opts_sg);
mu = result_SG.mu;

%% MD-PGD start - measure initialization
max_mu = max(mu); % enhance computation stability
temp = exp(mu-max_mu);
q = b*temp/sum(temp);
measure_old = q + mu*stepsize;

%% MD-PGD start - dual initialization
lambda = ones(n,m).*(B'/(m*stepsize));

%% MD-PGD start - measure list initialization

value_list = []; 
for iter = 1:max_iter
    [mu_new,lambda_new]= MD_AGD_Inner_solver(mu,lambda,B,logD,inner_epsilon,low_inner_epsilon,max_inner_iter,stepsize,inner_stepsize_md,inner_stepsize_pgd); % So in the inner solver -> x->c->initial lambda->final lambda->final x
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
        mu = mu_new;
        break;
    end
    mu = mu_new;
    % lambda = lambda_new;
end
t = toc;
result = struct();
result.iter = iter;
result.time = t+t_SG;
result.gap = value_list;
% Display the final result
disp(['MD_PGD Loop: ',num2str(iter)])
disp(['MD_PGD Time ', num2str(t)]);
% 
% % Plotting the graph
% figure(4)
% plot(value_list, 'o-');
% xlabel('Iteration');
% ylabel('Iterate Gap of MD AGD');
% title('Iterate Gap');
% grid on;