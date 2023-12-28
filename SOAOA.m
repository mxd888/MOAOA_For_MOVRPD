%% ��Ŀ�������Ż��㷨��AOA��
% ---------------------------
% ��Ȩ��
% ��Ȩ��
% ---------------------------
% data      ��ͼ����
% N         ��Ⱥ����
% M_Iter    ��������
% ---------------------------
% BestVehiclePath   ��ѿ���·��
% BestDronePath     ������˻�·��
% BestCost          ��ѳɱ�
function [BestVehiclePath, BestDronePath, BestCost]=SOAOA(data, N, M_Iter)

% Ӧ�ò���
stoppingNum=data.stoppingNum;
% ��ʼ��ͣ���㼯��
StopSet = zeros(1,stoppingNum);
for i = 1:stoppingNum
    StopSet(i) = i;
end
% ����ʵ��Ӧ�ö�̬����AOA����
LB = StopSet(1);
UB = StopSet(stoppingNum);
Dim = stoppingNum;

BestVehiclePath = [];
BestDronePath = [];
%Two variables to keep the positions and the fitness value of the best-obtained solution

Best_P=zeros(1,Dim);
Best_FF=inf;
Conv_curve=zeros(1,M_Iter);

%Initialize the positions of solution
X=initialization(N,Dim,UB,LB);
Xnew=X;
Ffun=zeros(1,size(X,1));% (fitness values)
Ffun_new=zeros(1,size(Xnew,1));% (fitness values)

MOP_Max=1;
MOP_Min=0.2;
C_Iter=1;
Alpha=5;
Mu=0.499;

for i=1:size(X,1)
    [VehiclePath, DronePath, Cost] = F_obj(data, unique(floor(X(i,:))));
    if Cost == 0
        continue;
    end
    Ffun(1,i)=Cost;  %Calculate the fitness values of solutions
    if Ffun(1,i)<Best_FF
        Best_FF=Ffun(1,i);
        Best_P=X(i,:);
        BestVehiclePath = VehiclePath;
        BestDronePath = DronePath;
    end
end


while C_Iter<M_Iter+1  %Main loop
    MOP=1-((C_Iter)^(1/Alpha)/(M_Iter)^(1/Alpha));   % Probability Ratio 
    MOA=MOP_Min+C_Iter*((MOP_Max-MOP_Min)/M_Iter); %Accelerated function
   
    %Update the Position of solutions
    for i=1:size(X,1)   % if each of the UB and LB has a just value 
        for j=1:size(X,2)
           r1=rand();
            if (size(LB,2)==1)
                if r1>MOA
                    r2=rand();
                    if r2>0.5
                        Xnew(i,j)=Best_P(1,j)/(MOP+eps)*((UB-LB)*Mu+LB);
                    else
                        Xnew(i,j)=Best_P(1,j)*MOP*((UB-LB)*Mu+LB);
                    end
                else
                    r3=rand();
                    if r3>0.5
                        Xnew(i,j)=Best_P(1,j)-MOP*((UB-LB)*Mu+LB);
                    else
                        Xnew(i,j)=Best_P(1,j)+MOP*((UB-LB)*Mu+LB);
                    end
                end               
            end
            
           
            if (size(LB,2)~=1)   % if each of the UB and LB has more than one value 
                r1=rand();
                if r1<MOA
                    r2=rand();
                    if r2>0.5
                        Xnew(i,j)=Best_P(1,j)/(MOP+eps)*((UB(j)-LB(j))*Mu+LB(j));
                    else
                        Xnew(i,j)=Best_P(1,j)*MOP*((UB(j)-LB(j))*Mu+LB(j));
                    end
                else
                    r3=rand();
                    if r3>0.5
                        Xnew(i,j)=Best_P(1,j)-MOP*((UB(j)-LB(j))*Mu+LB(j));
                    else
                        Xnew(i,j)=Best_P(1,j)+MOP*((UB(j)-LB(j))*Mu+LB(j));
                    end
                end               
            end
            
        end
        
        Flag_UB=Xnew(i,:)>UB; % check if they exceed (up) the boundaries
        Flag_LB=Xnew(i,:)<LB; % check if they exceed (down) the boundaries
        Xnew(i,:)=(Xnew(i,:).*(~(Flag_UB+Flag_LB)))+UB.*Flag_UB+LB.*Flag_LB;
 
        [VehiclePath, DronePath, Cost] = F_obj(data, unique(floor(Xnew(i,:))));  % calculate Fitness function 
        if Cost == 0
            continue;
        end
        Ffun_new(1,i)=Cost;
        if Ffun_new(1,i) < Ffun(1,i) || Ffun(1,i) == 0
            X(i,:) = Xnew(i,:);
            Ffun(1,i) = Ffun_new(1,i);
        end
        if Ffun(1,i)<Best_FF && Ffun(1,i) > 0
            Best_FF=Ffun(1,i);
            Best_P=X(i,:);
            BestVehiclePath = VehiclePath;
            BestDronePath = DronePath;
        end
       
    end
    

    %Update the convergence curve
    Conv_curve(C_Iter)=Best_FF;
    
    disp(['���������У� ', num2str((C_Iter/M_Iter)*100), '%']);
    C_Iter=C_Iter+1;  % incremental iteration
    
end
BestCost = Best_FF;
end

% ���һ������Ӧ�Ⱥ���
function [VehiclePath, DronePath, Cost] = F_obj(data,StopSet)
    Cost=0;
    VehiclePath=[];
    DronePath=[];
    % �������о���˿������ͣ����
    [CloseStopS,hasfound]=FindclosestStop(data,StopSet);
    % �жϵ�ǰ��������Ƿ���У���Ҫ������
    if hasfound==1
        % ���㱣�����˻�·��
        SavingMatrixD=CalculateSavingDrone(data,CloseStopS);
        % ��Ҫ����CloseStopS�����ɳ�ʼ���˻�·��
        SavingMatrixV=CalculateMultimodelSaving(data,SavingMatrixD,CloseStopS,StopSet);
        % ����·��
        VehiclePath=CW(StopSet,SavingMatrixV);
        % ���˻�·��
        DronePath=BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VehiclePath);
        % ������Ӧ�Ⱥ���
        Cost=CalcateCostF2(data,VehiclePath,DronePath);
        % ��齫����·�߽��з�ת�Ƿ���Լ�С����ɱ�
        ReVehiclePath=VehiclePath(end:-1:1);
        % ���㷭ת������˻�·��
        ReDronePath=BuildDroneRoutes(data,SavingMatrixD,CloseStopS,ReVehiclePath);
        % ���㷭ת�����Ӧ��ֵ
        Cost2=CalcateCostF2(data,ReVehiclePath,ReDronePath);
        % ̰��ȡ����
        if Cost2<Cost
%             disp('��ת�������ֵ')
            VehiclePath=ReVehiclePath;
            DronePath=ReDronePath;
            Cost=Cost2;
        end
    end
    
end




