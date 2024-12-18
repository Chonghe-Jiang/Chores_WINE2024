function [result,t_fw] = Frank_Wolfe_Gurobi_Yalmip(n,m,B,D,opts)
    % Sequential Linear Programming - Frank Wolfe
    %% Notes: Directly use $\mu$, no $t$.
    %% Parameter Setting
    outer_epsilon = opts.outer_epsilon; % Tolerance for stopping criterion - outer loop
    max_iter = opts.max_iter; % Maximum number of outer iterations
    
    %% Objective Function and Gradient
    f = @(x) B * log(x(1:n));
    grad_f = @(x) [B'./x(1:n); zeros(m, 1)];
    
    %% Define the linear constraint matrix A and vector b
    % Inequality - The constraints are of the form Ax <= b
    A = zeros(m * n, m + n);
    for cons_loop = 1:n
        sub = zeros(m, n);
        sub(:, cons_loop) = -D(cons_loop, :)';
        A(1 + (cons_loop - 1) * m:cons_loop * m, 1:(m + n)) = [sub, eye(m)];
    end
    b = zeros(n * m, 1);
    
    % Equality - The constraints are of the form Cx = d
    C = [zeros(1, n), ones(1, m)];
    d = sum(B);
    
    
    %% Initialization - project/map x onto feasible set x = [beta(n);p(m)]
    %% Do heuristic start here; Does not take into the running time
    options = optimset('Algorithm', 'interior-point', 'Display', 'off');
    x = linprog(zeros(m+n,1),A,b,C,d,zeros(m+n,1),[],options);
    % x = [1-10^-5;1+10^-5;1-10^-5;1+10^-5];
    gradient = grad_f(x);
    
    %% Frank-Wolfe optimization loop
    tic
    value_list = [];
    for iter = 1:max_iter
        % Compute the gradient of f at the current point x
        gradient = grad_f(x);
        
        % Solve the linear minimization problem to get the optimal step direction
        % min s.t. <gradient, s> subject to the constraints
        xnew = FrankWolfeStepYalmip(x, gradient, A, b, C, d);
        % value_list = [value_list, f_lp(xnew, m, n, B, D)];
        value_list = [value_list, norm(abs((xnew(1:n)./x(1:n))-1),inf)];
        % gradient = grad_f(xnew);
        
        % Old Stopping criterion: check if the norm of the step is below the tolerance
        % New Stopping criteria: |(\beta_{i}^{t}-\beta_{i}^{t-1})-1|\leq
        % \epsilin
        % if norm(xnew - x) < outer_epsilon
        if norm(abs((xnew(1:n)./x(1:n))-1),inf) < outer_epsilon
            break;
        end
        x = xnew;
    end
   
    x_fw = xnew;
    t_fw = toc;
    
    % Result structure
    result = struct();
    result.iter = iter;
    result.time = t_fw;
    result.gap = value_list;
    result.mu = xnew;
    
    % % 获取数据点的索引
    % indices = 1:length(value_list);
    % % indices = length(measure_list)-9:length(measure_list);
    % % 绘制图表
    % figure;
    % plot(indices, value_list(indices), 'o-', 'Color', 'b');
    % xlabel('Index');
    % ylabel('Measure');
    % title('Measure List Convergence to 0');
    % grid on;
    % set(gca, 'YScale', 'log');  % 使用对数坐标轴来更好地观察线性收敛


    % Display the final result
    disp(['Frank_Wolfe Loop: ',num2str(iter)])
    disp(['Frank_Wolfe ', num2str(t_fw)]);
    % 
    % 
    % % Plotting the graph
    % figure(6)
    % plot(value_list, 'o-');
    % xlabel('Iteration');
    % ylabel('Iterate Gap of Frank Wolfe');
    % title('Iterate Gap');
    % grid on;
end

function xnew = FrankWolfeStepYalmip(x, gradient, A, b, C, d)
    % Create a new optimization problem
    s = length(x);
    x_var = sdpvar(s, 1);
    objective = gradient' * x_var;
    constraints = [A * x_var <= b;
                   C * x_var == d];
    
    % Solve the optimization problem using Gurobi
    options = sdpsettings('solver', 'gurobi', 'verbose', 0); % - Silent mode
    % options = sdpsettings('solver', 'gurobi'); - With substep output
    optimize(constraints, objective, options);
    
    % Get the optimal solution
    xnew = double(x_var);
end