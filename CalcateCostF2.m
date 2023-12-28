
% Ŀ��2��
%   ������С���ܽ����ɱ���
%   CT = ����ÿ��λ��������гɱ�
%   CD = ���˻�ÿ��λ��������гɱ�
%   CB = ʹ���䱸���˻��Ŀ����Ļ����ɱ�
%   Cost = CT * Vpath + CD * Dpath + CB (���Ա��)����ϸ��ʽ���ο���1���Ĺ�ʽ(6), min(f2)
% 
%   �������£���1��A novel multi-objective optimization model for the vehicle routing problem with drone delivery and dynamic flight endurance��
% 
function Cost = CalcateCostF2(data,VehiclePath,DronePath)
% ����ÿ��λ��������гɱ�
costV = data.vt;
% ���˻�ÿ��λ��������гɱ�
costD = data.vd;
VpathLength = length(VehiclePath);
Vdist = 0;
%���㿨���ľ���
for i = 1:VpathLength-1
    Vdist =Vdist + data.disMatrix(VehiclePath(i),VehiclePath(i+1));
end
%�������˻��ľ���
DpathLength = length(DronePath);
Ddist =0;
for i = 1:DpathLength
    iflyRoute = DronePath{i};
    for j = 1:length(iflyRoute)-1
        Ddist=Ddist+data.disMatrix(iflyRoute(j),iflyRoute(j+1));
    end
end
Cost = Vdist*costV + Ddist*costD + data.CB;
end