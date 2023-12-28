%
% Multi-objective arithmetic optimization algorithm (多目标算术优化算法:MOAOA)
%
% CEC2020
%% Input:
%                      Dimension                    Description
%      func_name       1 x length function name     the name of test function     
%      VRmin           1 x n_var                    low bound of decision variable
%      VRmax           1 x n_var                    up bound of decision variable
%      n_obj           1 x 1                        dimensions of objective space
%      Particle_Number 1 x 1                        population size
%      Max_Gen         1 x 1                        maximum  generations

%% Output:
%                     Description
%      ps             Pareto set
%      pf             Pareto front

function [ps,pf]=MOAOA_ForCEC2020(N,M_Iter,LB,UB,Dim,nRep,CostFunction)

beta = 2;
pMutation = 0.2;
nMutation = round(pMutation*N);

VarSize = [1 Dim];

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.CrowdingDistance = [];

pop = repmat(empty_individual,N,1);

for i = 1:N
    pop(i).Position = unifrnd(LB,UB,VarSize);
    pop(i).Cost = feval(CostFunction, pop(i).Position);
end

[pop, F] = Processor(pop, 0);

rep = SaveToRepository([], pop(F{1}), nRep);

% AOA Parameters
Xnew=pop;
MOP_Max=1;
MOP_Min=0.2;
Alpha=5;
Mu=0.499; 
zeta = 1;
for C_Iter=1:M_Iter
    MOP=1-((C_Iter)^(1/Alpha)/(M_Iter)^(1/Alpha));
    MOA=MOP_Min+C_Iter*((MOP_Max-MOP_Min)/M_Iter);
    sigma = zeros(N, Dim);
    for l = 1:N
        D = 0;
        for r = 1:N
            D = D + abs(pop(l).Position - pop(r).Position);
        end
        sigma(l, :) = zeta * D / (N-1);
    end

    for i=1:N
        leader = SelectLeader(rep, beta);
        for j=1:Dim
            r1=rand();
            if r1>MOA
                r2=rand();
                if r2>0.5
                    Xnew(i).Position(j)=leader.Position(j)/(MOP+eps)*((UB(j)-LB(j))*Mu+LB(j));
                else
                    Xnew(i).Position(j)=leader.Position(j)*MOP*((UB(j)-LB(j))*Mu+LB(j));
                end
            else
                r3=rand();
                if r3>0.5
                    Xnew(i).Position(j)=leader.Position(j)-MOP*((UB(j)-LB(j))*Mu+LB(j));
                else
                    Xnew(i).Position(j)=leader.Position(j)+MOP*((UB(j)-LB(j))*Mu+LB(j));
                end
            end               
        end

        Xnew(i).Position = limitToPosition(Xnew(i).Position,LB,UB);   % 限制变量变化范围
        Xnew(i).Cost = feval(CostFunction, Xnew(i).Position);   % 计算目标函数值

    end  % end N
    
    % Cross
    popc = Cross(empty_individual, nMutation, pop, SelectLeader(rep, beta), sigma, LB, UB, CostFunction);
    
    % Mutation
    popm = Mutate(empty_individual, nMutation, pop, LB, UB, CostFunction);

    pop = [rep; Xnew; popm; popc]; 
    
    [pop, F] = Processor(pop, MOA);

    rep = SaveToRepository(rep, pop(F{1}), nRep, MOA);

    pop = pop(1:N);

%     disp(['Iteration ' num2str(C_Iter) ': Number of F1 Members = ' num2str(numel(rep))]);
% 
%     figure(1);
%     PlotCosts(rep);
%     pause(0.01);
   
end

ps=zeros(nRep, Dim);
pf=zeros(nRep, numel(rep(1).Cost));
for i = 1: numel(rep)
    ps(i, :)=rep(i).Position;
    pf(i, :)=rep(i).Cost';
end


end



