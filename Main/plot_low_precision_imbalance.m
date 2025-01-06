function plot_low_precision_imbalance(pgdtag, condition_number, repeated_time)
    n_values = [500,600,700,800,900,1000];
    m_values = [50,50,50,50,50,50];
    data_types = {'uniform'};
    methods = {'GFW', 'DCA', 'SG'};

    for i = 1:length(n_values)
        n = n_values(i);
        m = m_values(i);

        for j = 1:length(data_types)
            data_type = data_types{j};

            all_times = zeros(repeated_time, length(methods));
            for r = 1:repeated_time
                [avg_times, condition_rate_avg, results] = run_experiments_low(n, m, condition_number, pgdtag, data_type, 1);
                all_times(r, :) = avg_times;
            end
            mean_times = mean(all_times, 1);
            for k = 1:length(methods)
                fprintf('n=%d, m=%d, data_type=%s, method=%s, mean_time=%.4f\n', n, m, data_type, methods{k}, mean_times(k));
            end
        end
    end
end