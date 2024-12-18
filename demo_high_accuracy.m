n = 100;
m = 100;
c = 100;

D = rand(n, m)+0.01;
B = rand(1, n)+0.01;
D = Precondition_D(D, c);
B = Precondition_B(B, c);
mu0 = ones(1, m) / 10;

%% SG-MD-PGD Method - Need SG inside
opts_md_agd = struct();
opts_md_agd.outer_epsilon = 1e-4; % Tolerance for stopping criterion - outer loop
opts_md_agd.inner_epsilon = 1e-8; % Tolerance for stopping criterion - inner loop
opts_md_agd.low_inner_epsilon = 1e-4; % Tolerance for stopping criterion - inner loop
opts_md_agd.max_iter = 500; % Maximum number of outer iterations
opts_md_agd.max_inner_iter = 5000;
opts_md_agd.stepsize = 2;
opts_md_agd.inner_stepsize_md = 2;
opts_md_agd.inner_stepsize_pgd = 30/ sqrt(n * m);
% n=50:30/sqrt(n*m)
[result_md_agd, t_md_agd] = MD_AGD(mu0, n, m, B, D, opts_md_agd);

%% Frank Wolfe Method
opts_fw = struct();
opts_fw.outer_epsilon = 1e-4; % Tolerance for stopping criterion - outer loop
opts_fw.max_iter = 200; % Maximum number of outer iterations
[result_fw, t_fw] = Frank_Wolfe_Gurobi_Yalmip(n, m, B, D, opts_fw);
    