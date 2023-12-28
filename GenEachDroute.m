function  Droute = GenEachDroute(data,Sv,Sd)
UAV_Nums = data.UAVNum;
Droute ={};
%逐架无人机路线生成
NowDrone = 1;
for i = 1:length(Sv)
    Oi = Sv(i);%判断这点是否可以是起飞点
    Sdlength1 = length(Sd); 
    Yes = 0;
    for j = 1:Sdlength1
        jFlyroute = Sd{j};
        num = 1;
        if jFlyroute(1)==Oi %有飞行路线
            Yes =1;
            Droute{NowDrone,num} = jFlyroute;%直接作为第一段无人机路线
            Dj = jFlyroute(end);
            Sd(j) = [];%删除该路线
            Sdlength2 = length(Sd);
            if Dj ~=1 %终点不是仓库，则还可以插入，每次选择一个最近的插入
                for s = 1:Sdlength2
                    canFind = 0;
                    Sdlength3 = length(Sd);
                    dist = inf;
                    for k = 1:Sdlength3
                        kFlyroute = Sd{k};
                        if kFlyroute(1)~=1 %不是仓库点
                            Ok = kFlyroute(1);%插入路线的起点
                            DjIndex = find(Sv==Dj);
                            OkIndex=find(Sv==Ok);
                            if OkIndex-DjIndex>0 %可以插入到后面
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
                    %将该路线插入到后面
                    if canFind == 1
                        num = num + 1;
                        Dj = Sd{InsertIndex}(end);
                        Droute{NowDrone,num} = Sd{InsertIndex};
                        Sd(InsertIndex) = [];%删除该路线
                    end
                end
            end
            NowDrone = NowDrone + 1;%启用另一架无人机
        end
        if Yes == 1
            break;
        end
    end
end
% for i = 1:Sdlength %依次把每一个飞行路线添加到每一架无人机路线中
%    iFlyroute = Sd{i};
%    Oi = iFlyroute(1);
%    Di = iFlyroute(end);
%    if isempty(Droute)%直接加入到第一个无人机中
%        Droute{1,1} = iFlyroute;
%        hasUsedDNum = 1;
%    else
%        %在已有的无人机路线中，判断是否可以在路线前后插入iFlyroute，不可以的话，则用一架新的无人机
%        canindex = 0;%插入路线位置(1代表插入前面，2代表插入后面)
%        for j = 1:hasUsedDNum
%            jDroneRoute = Droute(j,:);
%            firstRoute = jDroneRoute{1};%第一个飞行路线
%            Droutelength = length(jDroneRoute);
%            for s=1:Droutelength
%                emPtyS = jDroneRoute{s};
%                if ~isempty(emPtyS)
%                    EndRoute = emPtyS;%最后一个飞行路线
%                end
%            end  
%            %是否可以插到前边
%            Oj = firstRoute(1);
%            OjIndex = find(Sv==Oj);
%            DiIndex = find(Sv==Di);%应该选择非空的最后一个元素
%            if Di == 1%直接另外启用一个无人机路线或者尝试是否可以插入到后面
%                Dj = EndRoute(end);
%                if Oi~=1 &&Dj~=1%否则新加一个飞机
%                    OiIndex = find(Sv==Oi);
%                    DjIndex = find(Sv == Dj);
%                    if OiIndex-DjIndex >=0
%                        canindex =2;
%                        InserDrone = j;
%                    end
%                end
%            else Di ~= 1&&Oj~=1
%                if OjIndex-DiIndex > 0 %可以插入到前面
%                    canindex = 1;
%                    InserDrone = j;%记录卡车路线号
%                end
%            end
%            %是否可以插到后面
%            Dj = EndRoute(end);
%            OiIndex = find(Sv==Oi);
%            DjIndex = find(Sv==Dj);
%            if Oi == 1%是否可以插到前面
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
%        if canindex == 0%新启用一个无人机
%            hasUsedDNum = hasUsedDNum + 1;
%            Droute{hasUsedDNum,1} = iFlyroute;
%        elseif canindex == 1%插入前面
%            IR =Droute(InserDrone,:);
%            newIR = [iFlyroute,IR];
%            newIRlength = length(newIR);
%            for k = 1:newIRlength
%                Droute{InserDrone,k} = newIR{k};
%            end
%        elseif canindex == 2%插入后面
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