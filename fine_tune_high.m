%% Tiny testing - High SG & FW

n = 50;
m = 50;
D = rand(n,m)+0.01; % It becomes very different if we use D+0.01
B = rand(1,n)+0.01;
mu0 = rand(1,m);
% mu0 = ones(1,m)/10;
isint = 0; 
D_condition = 100;
B_condition = 100;
[D_new, B_new] = scale_matrices_to_conditions(D, B, D_condition, B_condition, isint);


%% SG-MD-PGD Method - Need SG inside
opts_md_agd = struct();
opts_md_agd.outer_epsilon = 1e-4; % Tolerance for stopping criterion - outer loop
opts_md_agd.inner_epsilon = 1e-8; % Tolerance for stopping criterion - inner loop
opts_md_agd.low_inner_epsilon = 1e-4; % Tolerance for stopping criterion - inner loop
opts_md_agd.max_iter = 200; % Maximum number of outer iterations
opts_md_agd.max_inner_iter = 2000;
opts_md_agd.stepsize = 2;
opts_md_agd.inner_stepsize = 0.6;
[result_md_agd,t_md_agd] = MD_AGD(mu0,n, m, B, D, opts_md_agd);

%% Frank Wolfe Method
opts_fw = struct();
opts_fw.outer_epsilon = 1e-4; % Tolerance for stopping criterion - outer loop
opts_fw.max_iter = 200; % Maximum number of outer iterations
[result_fw,t_fw] = Frank_Wolfe_Gurobi_Yalmip(n, m, B, D, opts_fw);