function flag2 = checkfromVehicle(data,merged_route,VehiclePath,Droute,cmRouteindex,cnRouteindex)
UAV_Nums = data.UAVNum;%���˻���Ŀ����
%��m��n��·�ߴ�Droute��ɾ�������Ұ�merged_route���µ�Droute��
Droute([cmRouteindex,cnRouteindex]) =[];
Droute{end+1} = merged_route;
Vpathlength = length(VehiclePath);
flag2 = 1;

%����һ������(���˻���ɵ�ͽ����֮������˻���Ŀ����)
DispatchList = zeros(1,Vpathlength);%���˻���ɵ���Ŀ�б�
CollectList = zeros(1,Vpathlength);%���˻����յ���Ŀ�б�
Droutelength = length(Droute);
for i = 1:Droutelength
    idRoute = Droute{i};
    Oi = idRoute(1);%����·�����
    Di = idRoute(end);%����·�ߵ��յ�
    if Oi ~=Di %�����յ㲻һ������Ҫͳ�����˻���Ŀ
        Oindex = find(VehiclePath==Oi);
        Dindex = find(VehiclePath == Di);
        if Oi  ~= 1&&Di~=1%��ɵ�ͽ���㶼���ǲֿ�
            DispatchList(Oindex) = DispatchList(Oindex) + 1;
            CollectList(Dindex) = CollectList(Dindex) + 1;
        elseif Oi  == 1&&Di~=1%�ֿ�����ɵ�
            DispatchList(Oindex(1)) = DispatchList(Oindex(1)) + 1;
            CollectList(Dindex) = CollectList(Dindex) + 1;
        elseif Oi  ~= 1&&Di==1%�ֿ��ǽ����
            DispatchList(Oindex) = DispatchList(Oindex) + 1;
            CollectList(Dindex(2)) = CollectList(Dindex(2)) + 1;
        end
    end
end
%�ж�ÿһ�����Ƿ�Υ�����˻���ĿҪ��
for i = 1:Vpathlength
    if DispatchList(i)>UAV_Nums || CollectList(i)>UAV_Nums
        flag2 = 0;
        break
    end
end
if flag2 == 0  %Υ����һ������ֱ�ӷ���
    return
end

%���ڶ���������ɵ�����ڽ����֮ǰ��
for i = 1:Droutelength
    idRoute = Droute{i};
    Oi = idRoute(1);%����·�����
    Di = idRoute(end);%����·�ߵ��յ�
    if Oi ~=Di %�����յ㲻һ������Ҫͳ�����˻���Ŀ
        Oindex = find(VehiclePath==Oi);
        Dindex = find(VehiclePath == Di);
         if Oi  ~= 1&&Di~=1%��ɵ�ͽ���㶼���ǲֿ�
             if Dindex<Oindex
                 flag2 =0;
                 break;
             end
        end
    end
end
if flag2==0%Υ���ڶ�������ֱ�ӷ���
    return
end

%������������(ȷ��ÿһ��ͣ����֮����һ�����˻���������һ��ͣ������Χ�Ŀͻ�)
DispatchList = zeros(1,Vpathlength);%���˻���ɵ���Ŀ�б�
CollectList = zeros(1,Vpathlength);%���˻����յ���Ŀ�б�
remainNum = UAV_Nums;
for i = 1:Vpathlength %���ſ���·�߽��м��
    Vi = VehiclePath(i);
    for j = 1:Droutelength
        jdRoute = Droute{j};
        Oj = jdRoute(1);%����·�����
        Dj = jdRoute(end);%����·�ߵ��յ�
        if Oj~=Dj %�����յ㲻һ������Ҫͳ�����˻���Ŀ
            if Oj == Vi %������
                DispatchList(i) = DispatchList(i)+1;
            elseif Dj == Vi %�����
                CollectList(i) = CollectList(i) + 1;
            end
        end
    end
    if i == Vpathlength %Ϊ�ֿ��
        remainNum = UAV_Nums;
    elseif i == 1
        remainNum = UAV_Nums - DispatchList(i);
        if remainNum <1
            flag2 =0;
            break;
        end
    elseif i~=1 && i ~= Vpathlength
        remainNum = remainNum + CollectList(i) - DispatchList(i);
        if i == Vpathlength-1 && remainNum<0 %����ȫ�����ɳ�ȥ
            flag2 =0;
            break;
        elseif i ~= Vpathlength-1  && remainNum<1 %����Ҫ��һ�����˻��ڿ�����ʻ����һ��ͣ����
            flag2 =0;
            break;
        end
    end  
end
if flag2 == 0
    return
end
end