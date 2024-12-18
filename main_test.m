
n = 50;
m = 50;

% Low precision
% 调用run_experiments_low函数
pgdtag = 0;
[avg_times, condition_rate_avg,results] = run_experiments_low(n, m, 100, 0);

% 打印平均时间和条件率 - pgdtag = 1
fprintf('Average times (FW, MD, PGD, SG): %.4f %.4f %.4f %.4f\n', avg_times);
fprintf('Average condition rate: %.4f\n', condition_rate_avg);

% 打印平均时间和条件率 - pgdtag = 0
fprintf('Average times (FW, MD, SG): %.4f %.4f %.4f\n', avg_times);
fprintf('Average condition rate: %.4f\n', condition_rate_avg);

% %% High precision
% % 调用run_experiments_low函数
% [avg_times, condition_rate_avg,results] = run_experiments_high(n, m, 1000);
% 
% % 打印平均时间和条件率
% fprintf('Average times (FW, DCA): %.4f %.4f \n', avg_times);
% fprintf('Average condition rate: %.4f\n', condition_rate_avg);
