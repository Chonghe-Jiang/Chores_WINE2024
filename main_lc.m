%% Toy example for linear convergence result
% x = [ones(2,1)/5;rand(2,1)];
% x = 10*rand(4,1)+0.01;
% n = 2;
% m = 2;
% B = [1,1] ;
% epsilon = 10^-2;
% D = [1,10^5;1-epsilon,1+epsilon];
% eta = 2;
% [x_Benchmark,t_Benchmark] = Dual_solver(x,n,m,B,D,eta);
% 
% opts_fw = struct();
% opts_fw.outer_epsilon = 1e-6;
% opts_fw.max_iter = 200;
% [result_fw, t_fw] = Frank_Wolfe_Gurobi_Yalmip(n, m, B, D, opts_fw);


%% CPU Time Test at High accuracy condition
profile on
n = 100;
m = 100;
D = rand(n, m)+0.1;
B = rand(1, n)+0.1;
c = 100;
D = Precondition_D(D, c);
B = Precondition_B(B, c);
eta = 1;
% [x_Benchmark,t_Benchmark] = Primal_solver(n,m,B,D,eta);
[x_Benchmark_dual,t_Benchmark_dual] = Dual_solver(n,m,B,D,eta);
% [x_Benchmark,t_Benchmark] = Primal_solver(n, m, B, D, eta);

opts_fw = struct();
opts_fw.outer_epsilon = 1e-6;
opts_fw.max_iter = 200;
[result_fw, t_fw] = Frank_Wolfe_Gurobi_Yalmip(n, m, B, D, opts_fw);
profile viewer

%% Code for time output
% c = 100;
% scales = 100:100:500; % Define the scales from 100 to 500 with step 100
% 
% for scale = scales
%     n = scale;
%     m = scale;
%     experiment_count = 0;
% 
%     while experiment_count < 50
%         [avg_times, avg_condition_rate, results] = run_experiments_high(n, m, c);
% 
%         % Check the number of entries in the times.txt file
%         dir_name = sprintf('Succeed_Data_%d', n);
%         time_file = fullfile(dir_name, 'times.txt');
% 
%         if exist(time_file, 'file')
%             fid = fopen(time_file, 'r');
%             if fid ~= -1
%                 num_lines = 0;
%                 while ~feof(fid)
%                     fgetl(fid); % Read a line
%                     num_lines = num_lines + 1;
%                 end
%                 fclose(fid);
% 
%                 % Subtract 1 for the header line
%                 num_lines = num_lines - 1;
% 
%                 if num_lines >= 5
%                     break; % Exit the loop if there are at least 5 entries
%                 end
%             end
%         end
% 
%         experiment_count = experiment_count + 1;
%     end
% end