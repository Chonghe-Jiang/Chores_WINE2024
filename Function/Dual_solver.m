function [result, t] = Dual_solver(n, m, B, D, stepsize)
    %% Outer loop - DCA programming - x as variable
    outer_epsilon = 1e-6; % Tolerance for stopping criterion - outer loop
    max_iter = 200; % Maximum number of outer iterations
    b = sum(B);

    %% SG to 1e-2
    opts_sg = struct();
    opts_sg.max_iter = 1e5; % Maximum number of outer iterations
    opts_sg.mu0 = ones(1, m) / 10;
    mode = 0; % mode = 0, low precision direct; 1 low precision two stage; 2 high precision
    ratio = 1.3; % Calculated by He
    [result_SG, t_SG] = SG_mode(mode, n, m, B, D, ratio, opts_sg);
    mu = result_SG.mu;

    %% Dual_solver start - measure initialization
    max_mu = max(mu); % enhance computation stability
    temp = exp(mu-max_mu);
    q = b*temp/sum(temp);
    measure_old = q + mu*stepsize;

    %% Some parameters in the inner optimization problem
    %% Constraint
    A_dual_eq = zeros(n,n*m); % Ax = b
    for index = 1:n
        A_dual_eq(index,(index-1)*m+1:index*m) = ones(1,m);
    end
    b_dual_eq = B'/stepsize;
    %% Hessian
    Q_dual = zeros(m,n*m);
    for index = 1:m
        Q_dual(index,index:m:n*m) = ones(1,n);
    end
    H_dual = Q_dual'*Q_dual; % Quadratic parameter

    %% Start

    value_list = [];
    tic
    for iter = 1:max_iter
        mu_new = Dual_solver_Inner_solver(m, n, mu, B, D,stepsize,A_dual_eq,b_dual_eq,Q_dual,H_dual); % So in the inner solver -> x->c->initial lambda->final lambda->final x
        % Calculate q
        max_mu = max(mu_new); % enhance computation stability
        temp = exp(mu_new-max_mu);
        q = b*temp/sum(temp);
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
    disp(['QP Dual Solver Loop: ',num2str(iter)])
    disp(['QP DUal Solver Time ', num2str(t+t_SG)]);
end