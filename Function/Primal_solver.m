function [x, t] = Primal_solver(n, m, B, D, eta)
    %% Outer loop - DCA programming - x as variable
    outer_epsilon = 1e-6; % Tolerance for stopping criterion - outer loop
    max_iter = 200; % Maximum number of outer iterations
    b = sum(B);

    %% Construct the matrix - Constraint inequality
    m_matrix = cell(1, m);
    for i = 1:m % design n*(m+n) matrix
        matrix_i = zeros(n, m);
        matrix_i(:, i) = ones(n, 1);
        matrix_i = [matrix_i, -eye(n)];
        m_matrix{i} = matrix_i;
    end
    A_cons = m_matrix{1};
    for i = 1:m-1
        A_cons = [A_cons; m_matrix{i+1}];
    end
    b_cons = log(D(:));
    
    %% SG to 1e-2
    opts_sg = struct();
    opts_sg.max_iter = 1e5; % Maximum number of outer iterations
    opts_sg.mu0 = ones(1, m) / 10;
    mode = 0; % mode = 0, low precision direct; 1 low precision two stage; 2 high precision
    ratio = 1.3; 
    [result_SG, t_SG] = SG_mode(mode, n, m, B, D, ratio, opts_sg);
    mu = result_SG.mu;

    %% Size transformation from m to m+n
    mu_comb = mu';
    t_bound = max(mu)-min(b_cons);
    x0 = [mu_comb;ones(n,1)*t_bound];
    
    %% Ini for measure old
    mu = x0(1:m);
    max_mu = max(mu); % enhance computation stability
    temp = exp(mu - max_mu);
    q = b * temp / sum(temp);
    measure_old = q + mu * eta;
    measure_list = [];

    %% DCA Algorithm - Inner solver for primal
    tic
    for iter = 1:max_iter
        % Solve the inner convex subproblem
        x_new = Primal_solver_inner(x0, B, D, A_cons, b_cons, eta);
        mu_new = x_new(1:m);
        max_mu = max(mu_new); % enhance computation stability
        temp = exp(mu_new - max_mu);
        q = b * temp / sum(temp);
        measure_new = q + mu_new * eta;
        measure_vec = abs(measure_old - measure_new);
        measure = norm(measure_vec ./ q, inf);
        measure_old = measure_new;
        measure_list = [measure_list, measure];

        % Stopping criterion - use function value directly
        if measure < outer_epsilon || iter == max_iter
            x = x_new;
            result = q;
            break;
        end

        x0 = x_new;
    end
    t = toc;
    disp(['QP Solver Loop: ', num2str(iter)])
    disp(['QP Solver Time ', num2str(t+t_SG)]);
end
