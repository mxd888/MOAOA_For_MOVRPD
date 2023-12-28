
% Ŀ��1��
%   ������С�����ܺġ�����ֻ���ǿ�������Դ���ģ���Ϊ���˻��ɵ����������Ի�����Ӱ�켸��Ϊ�㡣
%   �������ܺ����为�غ���ʻ�����йأ�Kara���ˣ�2007�꣩
%   ��ϸ��ʽ���ο���2���Ĺ�ʽ(5), min(f1)
%   �������£���1����Kara, ?., Kara, B. Y., & Yetis, M. K. (2007). Energy minimizing vehicle routing problem. 
%   In Proceedings of the 1st International Conference on Combinatorial Optimization and Applications, August 14-16, Xi'an, China, 62-71.����
%   ��2��A novel multi-objective optimization model for the vehicle routing problem with drone delivery and dynamic flight endurance��
function Cost = CalcateCostF1(data,VehiclePath,DronePath)
% ��ʼ�������ܺ�Ϊ0
Cost = 0;
% ͣ��������
StoppingNum = data.stoppingNum;
% ���˻�����
UAV_Nums=data.UAVNum;
% ��ŷɳ�ȥ�����˻���������
indexUAV_NUM=data.UAVNums;
% ��̬�׶��Ի�����������
totleWeight = data.customerCommodityWeight;
% ��ǰ��������
currentWeight = totleWeight(1);
% �������߾������������
VpathLength = length(VehiclePath);
% ���㿨���ľ���
for i = 1:VpathLength-1
    % �������
    istar=VehiclePath(i);
    % �����յ�
    iend=VehiclePath(i+1);
    % ��ʻ�ľ���
    Vdist =data.disMatrix(istar,iend);
    % ��������˻��ͳ�ȥ�Ļ���
    iflySend = 0;
    %�������˻��ľ���
    DpathLength = length(DronePath);
    % �������˻������������ֵ�ǰͣ������û��ͣ�ŵ����˻���������뿨��
    UAV_Nums = UAV_Nums + indexUAV_NUM(i);
    % �����������˻�·��
    for j = 1:DpathLength
        iflyRoute = DronePath{j};
        % �ҳ��Ե�ǰͣ����Ϊ�������˻�
        if iflyRoute(1) == istar
            % ��ô�istarͣ���㷢��ȥ�����˻��Լ��˿����к�
            for k = 1:length(iflyRoute)
                % ���˻�����·�ߵ�
                iflyStar=iflyRoute(k);
                % iflyStar>StoppingNum ʱ�����˻�����Ϊ�˿ͷ���С�ڻ����ʱ��Ϊ��ͣ�������
                if iflyStar>StoppingNum
                    % �����ۼ�ÿ���˿ͻ�������������õ�ǰ���˻������ѵĻ����������ٴ��ۼ�����õ�ǰͣ�����ܹ����ѻ�������
                    iflySend = iflySend + totleWeight(iflyStar);
                end
            end
            % ��ȡ���˻��յ�λ��
            iVend = iflyRoute(length(iflyRoute));
            if iVend ~= istar
                % ֤�������˻�û�з��ص�ǰͣ���㣬����ȥ������ͣ����ȴ�������ȥ
                UAV_Nums = UAV_Nums - 1;
                % ����indexUAV_NUM
                indexUAV_NUM(iVend) = indexUAV_NUM(iVend) + 1;
            end
        end
    end
    % ����ǰͣ���������˻������µ�ǰͣ���㿨����������
    if iflySend > 0 
        % ���µ�ǰ��������
        currentWeight = currentWeight - iflySend;
    end
    % ��¼��ǰͣ���������������
    totleWeight(istar) = currentWeight;
    % ����Ƥ��
    kache = 1500;
    % ��Ч�غɵ�����PIjV = currentWeight
    % ���˻�Ƥ��
    wurenji = 25;
    % װ�صĿ���v�ӽڵ�i��ʻ���ڵ�j ʱ��ë��
    Wij=kache+currentWeight+wurenji*UAV_Nums;
    % �ۼӼ��㿨���ܺ���Ӧ��ֵ����Ӧ����f1��
    Cost = Cost + Vdist * Wij;
end
end