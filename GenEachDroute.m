function  Droute = GenEachDroute(data,Sv,Sd)
UAV_Nums = data.UAVNum;
Droute ={};
%������˻�·������
NowDrone = 1;
for i = 1:length(Sv)
    Oi = Sv(i);%�ж�����Ƿ��������ɵ�
    Sdlength1 = length(Sd); 
    Yes = 0;
    for j = 1:Sdlength1
        jFlyroute = Sd{j};
        num = 1;
        if jFlyroute(1)==Oi %�з���·��
            Yes =1;
            Droute{NowDrone,num} = jFlyroute;%ֱ����Ϊ��һ�����˻�·��
            Dj = jFlyroute(end);
            Sd(j) = [];%ɾ����·��
            Sdlength2 = length(Sd);
            if Dj ~=1 %�յ㲻�ǲֿ⣬�򻹿��Բ��룬ÿ��ѡ��һ������Ĳ���
                for s = 1:Sdlength2
                    canFind = 0;
                    Sdlength3 = length(Sd);
                    dist = inf;
                    for k = 1:Sdlength3
                        kFlyroute = Sd{k};
                        if kFlyroute(1)~=1 %���ǲֿ��
                            Ok = kFlyroute(1);%����·�ߵ����
                            DjIndex = find(Sv==Dj);
                            OkIndex=find(Sv==Ok);
                            if OkIndex-DjIndex>0 %���Բ��뵽����
                                if  OkIndex-DjIndex<dist
                                    dist =  OkIndex-DjIndex;
                                    InsertIndex = k;
                                    canFind = 1;
                                end
                            elseif OkIndex-DjIndex==0
                                if Ok ~= kFlyroute(end)
                                    dist = 0;
                                    InsertIndex = k;
                                    canFind = 1;
                                end
                            end
                        end
                    end
                    %����·�߲��뵽����
                    if canFind == 1
                        num = num + 1;
                        Dj = Sd{InsertIndex}(end);
                        Droute{NowDrone,num} = Sd{InsertIndex};
                        Sd(InsertIndex) = [];%ɾ����·��
                    end
                end
            end
            NowDrone = NowDrone + 1;%������һ�����˻�
        end
        if Yes == 1
            break;
        end
    end
end
% for i = 1:Sdlength %���ΰ�ÿһ������·����ӵ�ÿһ�����˻�·����
%    iFlyroute = Sd{i};
%    Oi = iFlyroute(1);
%    Di = iFlyroute(end);
%    if isempty(Droute)%ֱ�Ӽ��뵽��һ�����˻���
%        Droute{1,1} = iFlyroute;
%        hasUsedDNum = 1;
%    else
%        %�����е����˻�·���У��ж��Ƿ������·��ǰ�����iFlyroute�������ԵĻ�������һ���µ����˻�
%        canindex = 0;%����·��λ��(1�������ǰ�棬2����������)
%        for j = 1:hasUsedDNum
%            jDroneRoute = Droute(j,:);
%            firstRoute = jDroneRoute{1};%��һ������·��
%            Droutelength = length(jDroneRoute);
%            for s=1:Droutelength
%                emPtyS = jDroneRoute{s};
%                if ~isempty(emPtyS)
%                    EndRoute = emPtyS;%���һ������·��
%                end
%            end  
%            %�Ƿ���Բ嵽ǰ��
%            Oj = firstRoute(1);
%            OjIndex = find(Sv==Oj);
%            DiIndex = find(Sv==Di);%Ӧ��ѡ��ǿյ����һ��Ԫ��
%            if Di == 1%ֱ����������һ�����˻�·�߻��߳����Ƿ���Բ��뵽����
%                Dj = EndRoute(end);
%                if Oi~=1 &&Dj~=1%�����¼�һ���ɻ�
%                    OiIndex = find(Sv==Oi);
%                    DjIndex = find(Sv == Dj);
%                    if OiIndex-DjIndex >=0
%                        canindex =2;
%                        InserDrone = j;
%                    end
%                end
%            else Di ~= 1&&Oj~=1
%                if OjIndex-DiIndex > 0 %���Բ��뵽ǰ��
%                    canindex = 1;
%                    InserDrone = j;%��¼����·�ߺ�
%                end
%            end
%            %�Ƿ���Բ嵽����
%            Dj = EndRoute(end);
%            OiIndex = find(Sv==Oi);
%            DjIndex = find(Sv==Dj);
%            if Oi == 1%�Ƿ���Բ嵽ǰ��
%                Oj = firstRoute(1);
%                if Oj~=1&&Di~=1
%                    OjIndex = find(Sv==Oj);
%                    DiIndex = find(Sv==Di);
%                    if OjIndex-DiIndex>=0
%                        canindex = 1;
%                        InserDrone = j;
%                    end
%                end
%            else Dj~= 1&& Oi~=1
%                if OiIndex-DjIndex>=0
%                    canindex = 2;
%                    InserDrone=j;
%                end
%            end
%        end
%        if canindex == 0%������һ�����˻�
%            hasUsedDNum = hasUsedDNum + 1;
%            Droute{hasUsedDNum,1} = iFlyroute;
%        elseif canindex == 1%����ǰ��
%            IR =Droute(InserDrone,:);
%            newIR = [iFlyroute,IR];
%            newIRlength = length(newIR);
%            for k = 1:newIRlength
%                Droute{InserDrone,k} = newIR{k};
%            end
%        elseif canindex == 2%�������
%             IR =Droute(InserDrone,:);
%            newIR = [IR,iFlyroute];
%             newIRlength = length(newIR);
%            for k = 1:newIRlength
%                Droute{InserDrone,k} = newIR{k};
%            end
%        end
%    end
% end

end