function plot_low_precision_imbalance(pgdtag, condition_number, repeated_time)
    n_values = [500,600,700,800,900,1000];
    m_values = [50,50,50,50,50,50];
    data_types = {'uniform'};
    methods = {'GFW', 'DCA', 'SG'};

    % 遍历不同的 n 和 m 值
    for i = 1:length(n_values)
        n = n_values(i);
        m = m_values(i);

        % 遍历不同的数据类型
        for j = 1:length(data_types)
            data_type = data_types{j};

            % 初始化存储每次实验运行时间的矩阵
            all_times = zeros(repeated_time, length(methods));

            % 运行十次实验
            for r = 1:repeated_time
                % 运行实验并获取结果
                [avg_times, condition_rate_avg, results] = run_experiments_low(n, m, condition_number, pgdtag, data_type, 1);
                all_times(r, :) = avg_times;
            end

            % 计算十次实验运行时间的均值
            mean_times = mean(all_times, 1);

            % 打印结果
            for k = 1:length(methods)
                fprintf('n=%d, m=%d, data_type=%s, method=%s, mean_time=%.4f\n', n, m, data_type, methods{k}, mean_times(k));
            end
        end
    end
end