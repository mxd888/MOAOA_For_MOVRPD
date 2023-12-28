%% 单目标算术优化算法（AOA）
% ---------------------------
% 版权：
% 版权：
% ---------------------------
% data      地图数据
% N         种群个数
% M_Iter    迭代次数
% ---------------------------
% BestVehiclePath   最佳卡车路径
% BestDronePath     最佳无人机路径
% BestCost          最佳成本
function [BestVehiclePath, BestDronePath, BestCost]=SOAOA(data, N, M_Iter)

% 应用参数
stoppingNum=data.stoppingNum;
% 初始化停靠点集合
StopSet = zeros(1,stoppingNum);
for i = 1:stoppingNum
    StopSet(i) = i;
end
% 根据实际应用动态调整AOA参数
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
    
    disp(['程序已运行： ', num2str((C_Iter/M_Iter)*100), '%']);
    C_Iter=C_Iter+1;  % incremental iteration
    
end
BestCost = Best_FF;
end

% 最后一公里适应度函数
function [VehiclePath, DronePath, Cost] = F_obj(data,StopSet)
    Cost=0;
    VehiclePath=[];
    DronePath=[];
    % 计算所有距离顾客最近的停靠点
    [CloseStopS,hasfound]=FindclosestStop(data,StopSet);
    % 判断当前解决方案是否可行，不要求最优
    if hasfound==1
        % 计算保存无人机路线
        SavingMatrixD=CalculateSavingDrone(data,CloseStopS);
        % 需要根据CloseStopS来生成初始无人机路线
        SavingMatrixV=CalculateMultimodelSaving(data,SavingMatrixD,CloseStopS,StopSet);
        % 货车路线
        VehiclePath=CW(StopSet,SavingMatrixV);
        % 无人机路径
        DronePath=BuildDroneRoutes(data,SavingMatrixD,CloseStopS,VehiclePath);
        % 计算适应度函数
        Cost=CalcateCostF2(data,VehiclePath,DronePath);
        % 检查将卡车路线进行反转是否可以减小总体成本
        ReVehiclePath=VehiclePath(end:-1:1);
        % 计算翻转后的无人机路径
        ReDronePath=BuildDroneRoutes(data,SavingMatrixD,CloseStopS,ReVehiclePath);
        % 计算翻转后的适应度值
        Cost2=CalcateCostF2(data,ReVehiclePath,ReDronePath);
        % 贪心取最优
        if Cost2<Cost
%             disp('翻转获得最优值')
            VehiclePath=ReVehiclePath;
            DronePath=ReDronePath;
            Cost=Cost2;
        end
    end
    
end




