% 定义文件名列表
fileNames = {'uniform', 'log_uniform', 'exponential', 'integer'};

% 循环处理每个文件
for i = 1:length(fileNames)
    % 打开 .fig 文件
    fig = openfig([fileNames{i} '.fig']);

    % 找到所有的线条对象
    lines = findobj(fig, 'Type', 'line');

    % 提取数据
    data = [];
    for j = 1:length(lines)
        xData = get(lines(j), 'XData');
        yData = get(lines(j), 'YData');
        data = [data; {xData, yData}];
    end

    % 关闭原始图形
    close(fig);

    % 重新绘制折线图
    figure;
    hold on;

    % 第一条线：实线，红色
    plot(data{1,1}, data{1,2}, 'r-*', 'LineWidth', 3);

    % 第二条线：虚线，蓝色
    plot(data{2,1}, data{2,2}, 'b-*', 'LineWidth', 3);

    % 第三条线：点划线，绿色
    plot(data{3,1}, data{3,2}, 'g-*', 'LineWidth', 3);

    hold off;

    % 添加边框
    box on;

    % 添加标题和标签
    set(gca, 'FontSize', 15);
    xlabel('n and m', 'FontSize', 18, 'LineWidth', 2);
    ylabel('Running Time by Seconds', 'FontSize', 18, 'LineWidth', 2);
    legend('SG', 'DCA', 'GFW', 'Location', 'northwest');

    % 保存图形为 EPS 文件
    saveas(gcf, [fileNames{i} '_version0.eps'], 'epsc');
end