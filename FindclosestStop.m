% �������о���˿������ͣ����
% 
% data              100     ��ͼ����
% StopSet           10      ͣ���㼯��
%
function [CloseStopS,hasfound] = FindclosestStop(data, StopSet)
Slength = length(StopSet);
stoppingNum = data.stoppingNum;
customerNum =data.customerNum;
maxFlightRange=data.maxFlightRange;
CloseStopS = zeros(customerNum,2);
%Ϊÿһ���ͻ��������������ͣ����
for i = 1:customerNum
    dist = inf;
    hasfound = 0;
    for j =1:Slength
        distij = data.disMatrix(StopSet(j),i+stoppingNum);%ͣ���㵽�ͻ��ľ���
        if distij<dist &&distij<maxFlightRange/2%λ�ڷ��з�Χ��
            dist=distij;
            Closti = StopSet(j);
            hasfound=1;
        end
    end
    if hasfound == 0%û���ҵ�����Ҫ���ͣ����
        break
    end
    CloseStopS(i,1) = i+stoppingNum;
    CloseStopS(i,2) = Closti;
end

end