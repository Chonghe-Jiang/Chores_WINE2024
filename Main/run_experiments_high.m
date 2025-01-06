function [avg_times, avg_condition_rate, results] = run_experiments_high(n, m, c)
    % Initialization
    t_fw_sum = 0;
    t_md_agd_sum = 0;
    condition_rate_sum = 0;
    results = cell(10, 2); % Cell for results
    
    % Create directory for storing data
    dir_name = sprintf('Succeed_Data_%d', n);
    if ~exist(dir_name, 'dir')
        mkdir(dir_name);
    end
    
    % File to store times
    time_file = fullfile(dir_name, 'times.txt');
    if exist(time_file, 'file')
        fid = fopen(time_file, 'a'); % Append mode if file exists
    else
        fid = fopen(time_file, 'w'); % Write mode if file does not exist
        if fid == -1
            error('Cannot create the time file.');
        end
        fprintf(fid, 'Experiment\tt_md_agd\tt_fw\n');
    end

    for i = 1:10
        D = rand(n, m);
        B = rand(1, n);        
        D = Precondition_D(D, c);
        B = Precondition_B(B, c);
        [condition_D, condition_B] = calculate_condition(D, B);
        condition_rate = condition_D / condition_B;
        condition_rate_sum = condition_rate_sum + condition_rate;
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
        opts_md_agd.inner_stepsize_pgd = 10 / sqrt(n * m);
        % n=50:30/sqrt(n*m)
        [result_md_agd, t_md_agd] = MD_AGD(mu0, n, m, B, D, opts_md_agd);
        t_md_agd_sum = t_md_agd_sum + t_md_agd;
        results{i, 1} = {result_md_agd}; % MD_AGD result
        
        %% Frank Wolfe Method
        opts_fw = struct();
        opts_fw.outer_epsilon = 1e-6; % Tolerance for stopping criterion - outer loop
        opts_fw.max_iter = 200; % Maximum number of outer iterations
        [result_fw, t_fw] = Frank_Wolfe_Gurobi_Yalmip(n, m, B, D, opts_fw);
        t_fw_sum = t_fw_sum + t_fw;
        results{i, 2} = {result_fw}; % FW result
        
        if t_md_agd < t_fw
            filename = fullfile(dir_name, sprintf('data_%d.mat', i));
            save(filename, 'D', 'B');
            fprintf(fid, '%d\t%.6f\t%.6f\n', i, t_md_agd, t_fw);
        end
    end
    
    % Close the time file
    fclose(fid);
    
    % average time and average condition rate
    avg_times = [t_fw_sum / 10, t_md_agd_sum / 10];
    avg_condition_rate = condition_rate_sum / 10;
end