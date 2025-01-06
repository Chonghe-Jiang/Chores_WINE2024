function [avg_times, condition_rate_avg, results] = run_experiments_low(n, m, c, pgdtag, data_type, repeated_time)
    %% Summation Setting
    t_fw_sum = 0;
    t_MD_sum = 0;
    t_pgd_sum = 0;
    t_SG_sum = 0;
    condition_rate_sum = 0;
    results = cell(repeated_time, 4); % Cell for results
    valid_pgd_experiments = 0; % PGD validation for its relation with stepsize
    
    %% Data Setting - No stochastic condition
    mu0 = ones(1, m) / 10;
    
    % repeated_time experiments
    if pgdtag == 1
        for i = 1:repeated_time
            [D, B] = generate_data(n, m, data_type);
            D = Precondition_D(D,c);
            B = Precondition_B(B,c);
            [condition_D, condition_B] = calculate_condition(D, B);
            condition_rate = condition_D / condition_B;
            condition_rate_sum = condition_rate_sum + condition_rate;
            
            % SG methods
            opts = struct();
            opts.max_iter = 1e5;
            opts.mu0 = mu0;
            mode = 0;
            ratio = 1.3;
            [result_SG, t_SG] = SG_mode(mode, n, m, B, D, ratio, opts);
            t_SG_sum = t_SG_sum + t_SG;
            results{i, 4} = {result_SG};

            % DCA-PGD method
            opts_pgd = struct();
            opts_pgd.outer_epsilon = 1e-2;
            opts_pgd.inner_epsilon = 1e-4;
            opts_pgd.max_iter = 1000;
            opts_pgd.max_inner_iter = 4000;
            opts_pgd.stepsize = 2;
            opts_pgd.inner_stepsize = 2 / sqrt(n*m);
            [result_pgd, t_pgd] = Dual_PGD(mu0, n, m, B, D, opts_pgd);

            % PGD iteration validation
            if result_pgd.iter < opts_pgd.max_iter
                valid_pgd_experiments = valid_pgd_experiments + 1;
                t_pgd_sum = t_pgd_sum + t_pgd;
            end
            results{i, 2} = {result_pgd}; % PGD results

            % DCA-MD method
            opts_md = struct();
            opts_md.outer_epsilon = 1e-2;
            opts_md.inner_epsilon = 1e-4;
            opts_md.max_iter = 200;
            opts_md.max_inner_iter = 2000;
            opts_md.stepsize = 2;
            opts_md.inner_stepsize = 2;
            [result_md, t_MD] = Dual_MD(mu0, n, m, B, D, opts_md);
            t_MD_sum = t_MD_sum + t_MD;
            results{i, 3} = {result_md}; % MD result

            % FW method
            opts_fw = struct();
            opts_fw.outer_epsilon = 1e-2;
            opts_fw.max_iter = 200;
            [result_fw, t_fw] = Frank_Wolfe_Gurobi_Yalmip(n, m, B, D, opts_fw);
            t_fw_sum = t_fw_sum + t_fw;
            results{i, 1} = {result_fw}; % FW result
        end
        % average time and avarage condition numer
        avg_times = [t_fw_sum / repeated_time, t_MD_sum / repeated_time, t_pgd_sum / valid_pgd_experiments, t_SG_sum / repeated_time];
        condition_rate_avg = condition_rate_sum / repeated_time;
    else
        for i = 1:repeated_time
            [D, B] = generate_data(n, m, data_type);
            D = Precondition_D(D,c);
            B = Precondition_B(B,c);
            [condition_D, condition_B] = calculate_condition(D, B);
            condition_rate = condition_D / condition_B;
            condition_rate_sum = condition_rate_sum + condition_rate;
            
            % SG methods
            opts = struct();
            opts.max_iter = 1e5;
            opts.mu0 = mu0;
            mode = 0;
            ratio = 1.3;
            [result_SG, t_SG] = SG_mode(mode, n, m, B, D, ratio, opts);
            t_SG_sum = t_SG_sum + t_SG;
            results{i, 1} = {result_SG}; % 保存SG结果

            % DCA-MD method
            opts_md = struct();
            opts_md.outer_epsilon = 1e-2;
            opts_md.inner_epsilon = 1e-4;
            opts_md.max_iter = 200;
            opts_md.max_inner_iter = 2000;
            opts_md.stepsize = 2;
            opts_md.inner_stepsize = 2;
            [result_md, t_MD] = Dual_MD(mu0, n, m, B, D, opts_md);
            t_MD_sum = t_MD_sum + t_MD;
            results{i,2} = {result_md}; % MD result

            % FW method
            opts_fw = struct();
            opts_fw.outer_epsilon = 1e-2;
            opts_fw.max_iter = 200;
            [result_fw, t_fw] = Frank_Wolfe_Gurobi_Yalmip(n, m, B, D, opts_fw);
            t_fw_sum = t_fw_sum + t_fw;
            results{i, 3} = {result_fw}; % FW result
        end
        % average time and avarage condition numer
        avg_times = [t_fw_sum / repeated_time, t_MD_sum / repeated_time, t_SG_sum / repeated_time];
        condition_rate_avg = condition_rate_sum / repeated_time;
    end
end

function [D, B] = generate_data(n, m, data_type)
    switch data_type
        case 'uniform'
            D = rand(n, m) + 0.01;
            B = rand(1, n) + 0.01;
        case 'log-uniform'
            D = lognrnd(0, 1, [n, m]) + 0.01;
            B = rand(1, n) + 0.01;
        case 'exponential'
            D = exprnd(1, n, m);
            B = rand(1, n) + 0.01;
        case 'integer'
            D = randi([1, 1000], n, m);
            B = rand(1, n) + 0.01;
        otherwise
            error('Unknown data type');
    end
end