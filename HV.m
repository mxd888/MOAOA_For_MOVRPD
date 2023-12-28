function [hv] = HV(front, ref_point)
% HV指标计算
% 输入参数:
% front: 帕累托前沿点集，每行为一个解，每列为一个目标函数值
% ref_point: 参考点，用于度量解到参考点的距离
% 输出参数:
% hv: HV指标值

% 计算每个点到参考点的距离
D = pdist2(front, ref_point);

% 找到帕累托前沿中最小的和最大的目标函数值
min_f = min(front,[],1);
max_f = max(front,[],1);

% 构造真实前沿上的网格点
range = linspace(0,1,11); 
[grid_x, grid_y] = meshgrid(range*max_f(1), range*max_f(2));
grid_points = [grid_x(:) grid_y(:)];
grid_size = size(grid_points,1);

% 筛选出真实前沿上的点
is_pareto = paretofront(front);
pareto_front = front(is_pareto,:);
pareto_size = size(pareto_front,1);

% 标记真实前沿上的点
pareto_idx = false(pareto_size,1);
for i = 1:pareto_size
    if any(pareto_front(i,:) == max_f) % 最大值点
        pareto_idx(i) = true;
    else % 判断该点是否被网格点包围
        pareto_d = pdist2(pareto_front(i,:), grid_points);
        if all(pareto_d <= D)
            pareto_idx(i) = true;
        end
    end
end

% 计算HV指标值
hv = 0;
for i = 1:grid_size
    % 找到网格点中最近的前沿点
    dist = pdist2(grid_points(i,:),pareto_front);
    [min_dist, ~] = min(dist);
    
    % 网格面积
    if i == 1
        area = min_dist^2;
    else
        area = (min_dist^2 - pre_min_dist^2) / 2;
    end
    
    % 更新HV指标值
    hv = hv + area;
    
    % 保存上一个最小距离值
    pre_min_dist = min_dist;
end

end



function pareto = paretofront(front)
% 自定义函数：计算帕累托前沿
% 输入参数:
% front: 前沿点集，每行为一个解，每列为一个目标函数值
% 输出参数:
% pareto: 帕累托前沿点集

N = size(front, 1);
is_pareto = true(1, N);

for i = 1:N
    for j = 1:N
        if all(front(j,:) <= front(i,:)) && any(front(j,:) < front(i,:))
            is_pareto(i) = false;
            break;
        end
    end
end

pareto = front(is_pareto,:);
end
