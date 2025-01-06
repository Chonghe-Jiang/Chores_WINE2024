function [result,t] = Dual_MD_Compare(mu,n,m,B,D,opts_MD,opts_PGD)
% Outer loop - Sequential convex programming
% Inner loop - Convex programming by converting to dual and use pgd

%% Notes: Directly use $\mu$, no $t$.
%% Parameter Setting
outer_epsilon = opts_MD.outer_epsilon; % Tolerance for stopping criterion - outer loop
inner_epsilon = opts_MD.inner_epsilon; % Tolerance for stopping criterion - inner loop
max_iter = opts_MD.max_iter; % Maximum number of outer iterations
max_inner_iter = opts_MD.max_inner_iter;
stepsize = opts_MD.stepsize;
inner_stepsize = opts_MD.inner_stepsize;
logD = log(D);
%% Parameter Setting PGD
max_inner_iter_PGD = opts_PGD.max_inner_iter;
inner_stepsize_PGD = opts_PGD.inner_stepsize;
%% Initialization
lambda = ones(n,m).*(B'/(m*stepsize) ); % Error
% lambda = ones(n,m)/(m*stepsize);
b = sum(B);
%% Ini for measure old
max_mu = max(mu); % enhance computation stability
temp = exp(mu-max_mu);
q = b*temp/sum(temp);
measure_old = q + mu*stepsize;


%% Outer Loop
% DCA Algorithm
tic
value_list = [];
state = 0;
for iter = 1:max_iter
    % Solve the inner convex subproblem
    [mu_new,lambda_new,state] = Dual_MD_Compare_Inner(mu,lambda,B,logD,inner_epsilon,max_inner_iter,stepsize,inner_stepsize,inner_stepsize_PGD,max_inner_iter_PGD,state); % So in the inner solver -> x->c->initial lambda->final lambda->final x
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
    if measure < outer_epsilon || iter ==max_iter
        break;
    end
    mu = mu_new;
    lambda = lambda_new;
end
t = toc;
result = struct();
result.iter = iter;
result.time = t;
result.gap = value_list;
% % Display the final result
disp(['Dual_MD Loop: ',num2str(iter)])
disp(['Dual_MD Time ', num2str(t)]);

% Plotting the graph
% figure(3)
% plot(value_list, 'o-');
% xlabel('Iteration');
% ylabel('Iterate Gap of MD');
% title('Iterate Gap');
% grid on;