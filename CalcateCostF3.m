
% Ŀ��3��
%   ������С������ʱ�䡣
%   ��ϸ��ʽ���ο���1���Ĺ�ʽ(7), min(f3)
% 
%   �������£���1��A novel multi-objective optimization model for the vehicle routing problem with drone delivery and dynamic flight endurance��
% 
function Cost = CalcateCostF3(data,VehiclePath,DronePath)
% ��ʼ�������ܺ�Ϊ0
Cost = 0;
% �����ٶ�
VV = data.ST;
% ���˻��ٶ�
VD = data.SD;
% �������߾������������
VpathLength = length(VehiclePath);
% ���㿨���ľ���
for i = 1:VpathLength-1
    % ������ǰͣ����
    istar=VehiclePath(i);
    % ������һ��ͣ����
    iend=VehiclePath(i+1);
    % ��ʻ�ľ���
    Vdist =data.disMatrix(istar,iend);
    % ����ʱ��������˻�����·��
    Ddist = 0;
    %�������˻��ľ���
    DpathLength = length(DronePath);
    % �����������˻�·��
    for j = 1:DpathLength
        iDdist = 0;
        iflyRoute = DronePath{j};
        % ��ȡ���˻��յ�λ��
        iVend = iflyRoute(length(iflyRoute));
        % �ҳ��Ե�ǰͣ����Ϊ�������˻��������յ�Ϊ�������˻�
        if iflyRoute(1) == istar && iVend == istar
            % ��ô�istarͣ���㷢��ȥ�����˻��Լ��˿����к�
            for k = 1:length(iflyRoute) -1
                % ���˻�����ʱ��
                iDdist=iDdist+data.disMatrix(iflyRoute(k),iflyRoute(k+1));
            end
        end
        if iDdist>Ddist
            Ddist = iDdist;
        end
    end
    % ����ǰ����һ��ͣ��������ʱ��
    TV = Vdist/VV;
    % ���˻�����ʱ��
    TD = Ddist/VD;
    % �ӵ�ǰͣ����ǰ����һ��ͣ����������ʱ��
    TotalTime = TV + TD;
    % �ۼӼ��㿨���ܺ���Ӧ��ֵ����Ӧ����f3��
    Cost = Cost + TotalTime;
end
end