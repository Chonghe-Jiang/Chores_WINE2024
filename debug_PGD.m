%% Tiny testing
%% Testing - Condition number(Fixed); Balanced of n,m (or not); Data type; SG/FW

%% Parameter Settings
%% Different n,m - value/balance or not 
%% Different D,B generation
%% Different condition number 
%% Different initialization formulation


% rng(0);
n = 50;
m = 50;
D = rand(n,m)+0.01; % It becomes very different if we use D+0.01
B = rand(1,n)+0.01;
mu0 = ones(1,m)/10;
[condition_D,condition_B]=calculate_condition(D,B);

%% Parameter
opts_pgd = struct();
opts_pgd.outer_epsilon = 1e-2; % Tolerance for stopping criterion - outer loop
opts_pgd.inner_epsilon = 1e-4; % Tolerance for stopping criterion - inner loop
opts_pgd.max_iter = 1000; % Maximum number of outer iterations
opts_pgd.max_inner_iter = 2000;
opts_pgd.stepsize = 2;
opts_pgd.inner_stepsize = 1/sqrt(n);
opts_md = struct();
opts_md.outer_epsilon = 1e-2; % Tolerance for stopping criterion - outer loop
opts_md.inner_epsilon = 1e-4; % Tolerance for stopping criterion - inner loop
opts_md.max_iter = 200; % Maximum number of outer iterations
opts_md.max_inner_iter = 2000;
opts_md.stepsize = 2;
opts_md.inner_stepsize = 2;

%% Algorithm
[result_md,t_MD] = Dual_MD_Compare(mu0, n, m, B, D, opts_md,opts_pgd);