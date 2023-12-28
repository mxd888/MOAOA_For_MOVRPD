% ������������
%
% xRange            350     X�����
% yRange            250     Y�����
% customerNum       50      �˿�����
% interval          50      ���
% maxFlightRange    100     �����з�Χ
% payload           10      ��Ч�غ�
% vt                1
% vd                1
% UAV_Nums          3       ���˻���Ŀ
%
function data = GenData(xRange,yRange,customerNum,interval,maxFlightRange,payload,UAV_Nums,Parameters)
rand('twister', sum(100*clock));
x_range = xRange/interval;
y_range = yRange/interval;
m = x_range*y_range+1;
data.customerPos(1,:)=(xRange-50)*rand(1,customerNum)+50;%һ�д���һ������λ��
data.customerPos(2,:)=(yRange-50)*rand(1,customerNum)+50;
%     Request = round(rand(1,customerNum));%�����������У�0-��ȡ��1-�ɷ�
%����Pw��dw
Pw = 5*rand(1,customerNum);
Dw = 5*rand(1,customerNum);

for i=1:x_range
    for j=1:y_range
        data.stoppingPos(1,(i-1)*y_range+j)=interval*i;
        data.stoppingPos(2,(i-1)*y_range+j)=interval*j;
    end
end
    data.depotPos = [0;0];
    data.stoppingPos = [data.depotPos,data.stoppingPos];
    data.allPos = [data.stoppingPos,data.customerPos];
    data.allKdtree = KDTreeSearcher(data.allPos');
    data.stoppingKdtree = KDTreeSearcher(data.stoppingPos');
    data.customerKdtree = KDTreeSearcher(data.customerPos');
    data.stoppingNum = length(data.stoppingPos(1,:));
    data.customerNum = length(data.customerPos(1,:));
    data.maxFlightRange = maxFlightRange;
    data.payload = payload;
    data.vt = Parameters.CT;
    data.vd = Parameters.CD;
    data.ST = Parameters.ST;
    data.SD = Parameters.SD;
    data.UAVNum = UAV_Nums;
%     data.Request = Request;
    data.Pw = Pw;
    data.Dw = Dw;
    data.CB = Parameters.CB;
    num = length(data.allPos(1,:));
    
    for i=1:num
        for j=i:num
            if i~=j
                if i<=length(data.stoppingPos) && j<=length(data.stoppingPos)
                    % ͣ���㡢������·�߲��������پ������
                    dist = norm(data.allPos(:,i)-data.allPos(:,j),1);
                    data.disMatrix(i,j) = dist;
                    data.disMatrix(j,i) = dist;
                else
                    % ���˻��������ڵ�֮��ֱ���н�����ŷ�Ͼ��������·��
                    dist = norm(data.allPos(:,i)-data.allPos(:,j),2);
                    data.disMatrix(i,j) = dist;
                    data.disMatrix(j,i) = dist;
                end
            else
                data.disMatrix(i,j) = 0.0;
            end
        end
    end
    
    % �˿�����������
    DroneMax = 2;
    % ÿ���˿ͻ�������
    DroneWeight = ceil(rand(1,customerNum)*DroneMax);
    % ������ÿ��ͣ�������ʱ������
    VehicleWeight = zeros(1,length(data.stoppingPos(1,:)));
    % ��ʼ��������������Ϊ���л��������
    VehicleWeight(1) = sum(DroneWeight);
    % ���˿ͻ���������������̬�仯�Ļ��������й�һ��
    totleWeight = [VehicleWeight, DroneWeight];
    % ��ֵ��data��
    data.customerCommodityWeight = totleWeight;
    % ÿ��ͣ���㿨�������˻�����
    data.UAVNums = zeros(1,length(data.stoppingPos(1,:)));
end
