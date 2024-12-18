%% Need to change the data-generating function in run-experiments-low
%% logic: main_plot - plot_low_precision - run_experiments_low
% repeated_time = 1;
% % plot_low_precision(0, 100, repeated_time);
% plot_high_precision_imbalance(0, 100, repeated_time);

%% High dimension case - obtain five doc per size
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