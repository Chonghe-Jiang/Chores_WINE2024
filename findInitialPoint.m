function x0 = findInitialPoint(A, b)
    % Define the problem dimensions
    [numConstraints, numVariables] = size(A);

    % Define the objective function (which is 0)
    f = zeros(numVariables, 1);

    % Define the constraints
    Aineq = A;
    bineq = b;

    % Define the lower and upper bounds for the variables
    lb = -inf(numVariables, 1);
    ub = inf(numVariables, 1);

    % Solve the linear programming problem
    options = optimoptions('linprog', 'Display', 'off');
    x0 = linprog(f, Aineq, bineq, [], [], lb, ub, options);
end