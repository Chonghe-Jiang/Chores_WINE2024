% c = 100;
% results = cell(4, 1); % 用于存储结果的单元格数组
% 
% % 定义数据生成方法的函数句柄
% data_generators = {@generate_uniform_data, @generate_log_uniform_data, @generate_exponential_data, @generate_integer_data};
% 
% for gen_idx = 1:length(data_generators)
%     data_generator = data_generators{gen_idx};
%     ratio_matrix = zeros(10, 1); % 用于存储ratio的矩阵
% 
%     for i = 100:100:1000
%         m = i;
%         n = i;
%         mu0 = ones(1, m) / 10;
% 
%         % 生成数据
%         [D, B] = data_generator(n, m);
% 
%         % 预处理
%         D = Precondition_D(D, c);
%         B = Precondition_B(B, c);
% 
%         % 设置选项
%         opts = struct();
%         opts.max_iter = 1e5;
%         opts.mu0 = mu0;
%         mode = 0;
%         ratio_input = 1.3;
% 
%         % 运行SG_mode
%         [result_SG, t_SG] = SG_mode(mode, n, m, B, D, ratio_input, opts);
%         ratio = result_SG.ratio;
% 
%         % 存储结果
%         ratio_matrix((i / 100), 1) = ratio;
%     end
% 
%     % 存储当前数据生成方法的结果
%     results{gen_idx} = ratio_matrix;
% end
% 
% % 将结果写入CSV文件
% csv_data = [];
% for gen_idx = 1:length(data_generators)
%     csv_data = [csv_data, results{gen_idx}];
% end
% csvwrite('ratio.csv', csv_data);
% 
% % 数据生成函数
% function [D, B] = generate_uniform_data(n, m)
%     D = rand(n, m) + 0.01;
%     B = rand(1, n) + 0.01;
% end
% 
% function [D, B] = generate_log_uniform_data(n, m)
%     D = lognrnd(0, 1, [n, m]) + 0.01;
%     B = rand(1, n) + 0.01;
% end
% 
% function [D, B] = generate_exponential_data(n, m)
%     D = exprnd(1, n, m);
%     B = rand(1, n) + 0.01;
% end
% 
% function [D, B] = generate_integer_data(n, m)
%     D = randi([1, 1000], n, m);
%     B = rand(1, n) + 0.01;
% end

c = 100;
results = cell(4, 1); % 用于存储结果的单元格数组

% 定义数据生成方法的函数句柄
data_generators = {@generate_uniform_data, @generate_log_uniform_data, @generate_exponential_data, @generate_integer_data};

for gen_idx = 1:length(data_generators)
    data_generator = data_generators{gen_idx};
    ratio_matrix = zeros(6, 1); % 用于存储ratio的矩阵

    for i = 1:6
        n = 500 + (i - 1) * 100; % n = 500, 600, 700, 800, 900, 1000
        m = 500;
        mu0 = ones(1, m) / 10;

        % 生成数据
        [D, B] = data_generator(n, m);

        % 预处理
        D = Precondition_D(D, c);
        B = Precondition_B(B, c);

        % 设置选项
        opts = struct();
        opts.max_iter = 1e5;
        opts.mu0 = mu0;
        mode = 0;
        ratio_input = 1.3;

        % 运行SG_mode
        [result_SG, t_SG] = SG_mode(mode, n, m, B, D, ratio_input, opts);
        ratio = result_SG.ratio;

        % 存储结果
        ratio_matrix(i, 1) = ratio;
    end

    % 存储当前数据生成方法的结果
    results{gen_idx} = ratio_matrix;
end

% 将结果写入CSV文件
csv_data = [];
for gen_idx = 1:length(data_generators)
    csv_data = [csv_data, results{gen_idx}];
end
csvwrite('ratio.csv', csv_data);

% 数据生成函数
function [D, B] = generate_uniform_data(n, m)
    D = rand(n, m) + 0.01;
    B = rand(1, n) + 0.01;
end

function [D, B] = generate_log_uniform_data(n, m)
    D = lognrnd(0, 1, [n, m]) + 0.01;
    B = rand(1, n) + 0.01;
end

function [D, B] = generate_exponential_data(n, m)
    D = exprnd(1, n, m);
    B = rand(1, n) + 0.01;
end

function [D, B] = generate_integer_data(n, m)
    D = randi([1, 1000], n, m);
    B = rand(1, n) + 0.01;
end