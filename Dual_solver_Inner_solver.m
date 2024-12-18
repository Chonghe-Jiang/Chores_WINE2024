function mu_new = Dual_solver_Inner_solver(m, n, mu, B, D, stepsize, A_dual_eq, b_dual_eq, Q_dual, H_dual)
    %% Dual formulation - solved by Gurobi using YALMIP

    %% Establishment for the linear term
    c_ratio = sum(B) / sum(exp(mu));
    c = c_ratio * exp(mu) + stepsize * mu / stepsize;
    c = c';
    D_t = D'; % Second term
    f_dual = -Q_dual' * c + log(D_t(:)); % Linear parameter

    %% Solve by Gurobi

    % % Ensure matrices are sparse
    % H_dual = sparse(H_dual);
    % Q_dual = sparse(Q_dual);
    % A_dual_eq = sparse(A_dual_eq);
    % 
    % % Define the dual variables using YALMIP
    % lambda = sdpvar(m*n, 1);
    % 
    % %% Define the objective function
    % objective = 0.5 * lambda' * H_dual * lambda + f_dual' * lambda;
    % 
    % %% Define the constraints
    % constraints = [A_dual_eq * lambda == b_dual_eq, lambda >= 0];
    % 
    % %% Set up the solver options for YALMIP to use Gurobi
    % options = sdpsettings('solver', 'gurobi', 'verbose', 1, 'gurobi.LogToConsole', 1);  % 使用4个线程
    % 
    % %% Solve the optimization problem
    % optimize(constraints, objective, options);
    % 
    % %% Extract the solution
    % lambda_solver = value(lambda);

    %% Solve by simple QP
    H_dual = sparse(H_dual);
    Q_dual = sparse(Q_dual);
    A_dual_eq = sparse(A_dual_eq);

    % Define the objective function and constraints for quadprog
    f_quadprog = f_dual;
    Aeq_quadprog = A_dual_eq;
    beq_quadprog = b_dual_eq;
    lb_quadprog = zeros(m*n, 1);

    % Solve the optimization problem using quadprog
    options = optimoptions('quadprog', 'Display', 'off');  % 设置不显示输出
    [lambda_solver, fval_dual_solver] = quadprog(H_dual, f_quadprog, [], [], Aeq_quadprog, beq_quadprog, lb_quadprog, [], [], options);

    %% Map back to the mu_new variable
    lambda_dual_solver_matrix = reshape(lambda_solver, m, n); % reshape it to a m*n matrix
    mu_new = (c - sum(lambda_dual_solver_matrix, 2))';
    
end