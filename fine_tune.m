%% Tiny testing

n = 50;
m = 50;
D = rand(n,m)+0.01; % It becomes very different if we use D+0.01
B = rand(1,n)+0.01;
mu0 = ones(1,m)/10;
[condition_D,condition_B]=calculate_condition(D,B);
condition_rate = condition_D/condition_B;

%% SG
opts = struct();
opts.max_iter = 1e5; % Maximum number of outer iterations
opts.mu0 = mu0;
mode = 0; % mode = 0, low precision direct; 1 low precision two stage; 2 high precision
ratio = 1.3; % Calculated by He
[result_SG, t_SG] = SG_mode(mode, n, m, B, D, ratio, opts);

%% DCA-PGD Method
opts_pgd = struct();
opts_pgd.outer_epsilon = 1e-2; % Tolerance for stopping criterion - outer loop
opts_pgd.inner_epsilon = 1e-4; % Tolerance for stopping criterion - inner loop
opts_pgd.max_iter = 1000; % Maximum number of outer iterations
opts_pgd.max_inner_iter = 4000;
opts_pgd.stepsize = 2;
opts_pgd.inner_stepsize = 1/sqrt(n);
[result_pgd,t_pgd] = Dual_PGD(mu0, n, m, B, D, opts_pgd);
%s = 4/sqrt(n) when n = 50

%% DCA-MD Method
opts_md = struct();
opts_md.outer_epsilon = 1e-2; % Tolerance for stopping criterion - outer loop
opts_md.inner_epsilon = 1e-4; % Tolerance for stopping criterion - inner loop
opts_md.max_iter = 200; % Maximum number of outer iterations
opts_md.max_inner_iter = 2000;
opts_md.stepsize = 2;
opts_md.inner_stepsize = 2;

[result_md,t_MD] = Dual_MD(mu0, n, m, B, D, opts_md);
% inner_stepsize is the key parameter. Under epsilons = 1e-2 and uniform data
% s = 2; for n = 50; s = 1; for n = 100, 200; s = 0.5 for n=300, 400;
% s = 0.6 for n = 500

%% Frank Wolfe Method
opts_fw = struct();
opts_fw.outer_epsilon = 1e-2; % Tolerance for stopping criterion - outer loop
opts_fw.max_iter = 200; % Maximum number of outer iterations
[result_fw,t_fw] = Frank_Wolfe_Gurobi_Yalmip(n, m, B, D, opts_fw);