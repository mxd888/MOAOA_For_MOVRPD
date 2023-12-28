function [hv] = HV(front, ref_point)
% HVָ�����
% �������:
% front: ������ǰ�ص㼯��ÿ��Ϊһ���⣬ÿ��Ϊһ��Ŀ�꺯��ֵ
% ref_point: �ο��㣬���ڶ����⵽�ο���ľ���
% �������:
% hv: HVָ��ֵ

% ����ÿ���㵽�ο���ľ���
D = pdist2(front, ref_point);

% �ҵ�������ǰ������С�ĺ�����Ŀ�꺯��ֵ
min_f = min(front,[],1);
max_f = max(front,[],1);

% ������ʵǰ���ϵ������
range = linspace(0,1,11); 
[grid_x, grid_y] = meshgrid(range*max_f(1), range*max_f(2));
grid_points = [grid_x(:) grid_y(:)];
grid_size = size(grid_points,1);

% ɸѡ����ʵǰ���ϵĵ�
is_pareto = paretofront(front);
pareto_front = front(is_pareto,:);
pareto_size = size(pareto_front,1);

% �����ʵǰ���ϵĵ�
pareto_idx = false(pareto_size,1);
for i = 1:pareto_size
    if any(pareto_front(i,:) == max_f) % ���ֵ��
        pareto_idx(i) = true;
    else % �жϸõ��Ƿ�������Χ
        pareto_d = pdist2(pareto_front(i,:), grid_points);
        if all(pareto_d <= D)
            pareto_idx(i) = true;
        end
    end
end

% ����HVָ��ֵ
hv = 0;
for i = 1:grid_size
    % �ҵ�������������ǰ�ص�
    dist = pdist2(grid_points(i,:),pareto_front);
    [min_dist, ~] = min(dist);
    
    % �������
    if i == 1
        area = min_dist^2;
    else
        area = (min_dist^2 - pre_min_dist^2) / 2;
    end
    
    % ����HVָ��ֵ
    hv = hv + area;
    
    % ������һ����С����ֵ
    pre_min_dist = min_dist;
end

end



function pareto = paretofront(front)
% �Զ��庯��������������ǰ��
% �������:
% front: ǰ�ص㼯��ÿ��Ϊһ���⣬ÿ��Ϊһ��Ŀ�꺯��ֵ
% �������:
% pareto: ������ǰ�ص㼯

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
