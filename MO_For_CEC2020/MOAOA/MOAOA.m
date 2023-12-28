%
% Multi-objective arithmetic optimization algorithm (��Ŀ�������Ż��㷨:MOAOA)
%
% [Cost]=MOAOA(N,M_Iter,LB,UB,Dim,nRep,CostFunction)
% -------------------Parameters----------------------
% N                 ��Ⱥ��С
% M_Iter            ��������
% LB                �������±߽�
% UB                �������ϱ߽�
% Dim               �����ģ
% nRep              �������С
% CostFunction      ��Ŀ����Ӧ�Ⱥ���
% ---------------------return------------------------
% Cost              ���Ž�ǰ��

function [rep]=MOAOA(N,M_Iter,LB,UB,Dim,nRep,CostFunction)
% ��Ŀ�������ʼ��
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
    pop(i).Cost = CostFunction(pop(i).Position);
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
                    Xnew(i).Position(j)=leader.Position(j)/(MOP+eps)*((UB-LB)*Mu+LB);
                else
                    Xnew(i).Position(j)=leader.Position(j)*MOP*((UB-LB)*Mu+LB);
                end
            else
                r3=rand();
                if r3>0.5
                    Xnew(i).Position(j)=leader.Position(j)-MOP*((UB-LB)*Mu+LB);
                else
                    Xnew(i).Position(j)=leader.Position(j)+MOP*((UB-LB)*Mu+LB);
                end
            end               
        end

        Xnew(i).Position = limitToPosition(Xnew(i).Position,LB,UB);   % ���Ʊ����仯��Χ
        Xnew(i).Cost = CostFunction(Xnew(i).Position);   % ����Ŀ�꺯��ֵ

    end  % end N
    
    % Cross
    popc = Cross(empty_individual, nMutation, pop, SelectLeader(rep, beta), sigma, LB, UB, CostFunction);
    
    % Mutation
    popm = Mutate(empty_individual, nMutation, pop, LB, UB, CostFunction);

    pop = [rep; Xnew; popm; popc]; 
    
    [pop, F] = Processor(pop, MOA);

    rep = SaveToRepository(rep, pop(F{1}), nRep, MOA);

    pop = pop(1:N);

    disp(['Iteration ' num2str(C_Iter) ': Number of F1 Members = ' num2str(numel(rep))]);

    figure(1);
    PlotCosts(rep);
    pause(0.01);
   
end

end



