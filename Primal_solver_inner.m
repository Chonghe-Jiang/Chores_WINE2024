
function xnew = Primal_solver_inner(x, B, D, A, b, eta)
    % Define the problem dimensions
    [n, m] = size(D);
    % Set up parameters for the linear term in quadratic function
    f = [sum(B) * (-exp(x(1:m)) / sum(exp(x(1:m)))) - eta * x(1:m); B']; % column vector;
    % Set up Hessian matrix for the quadratic function
    H = eta * [eye(m), zeros(m, n); zeros(n, n + m)];
    x_var = sdpvar(m + n, 1);
    % Define the objective function
    objective = 0.5 * x_var' * H * x_var + f' * x_var;

    % Define the constraints
    constraints = [A * x_var <= b];

    % Set up the solver options for YALMIP to use Gurobi
    options = sdpsettings('solver', 'gurobi', 'verbose', 0, ...
                      'gurobi.MIPGap', 0.01, ...  % 设置MIPGap为1%
                      'gurobi.FeasibilityTol', 1e-6, ...  % 设置可行性容差
                      'gurobi.OptimalityTol', 1e-6);  % 设置最优性容差

    % Solve the quadratic programming problem
    optimize(constraints, objective, options);

    % Extract the solution
    xnew = value(x_var);
end