function [ps,pf]=MSSA_ForCEC2020(N,M_Iter,LB,UB,Dim,nRep,CostFunction)

% Change these details with respect to your problem%%%%%%%%%%%%%%
dim=Dim;
lb=LB;
ub=UB;
obj_no=numel(feval(CostFunction, unifrnd(lb(1), ub(1), [1 dim])));

if size(ub,2)==1
    ub=ones(1,dim)*ub;
    lb=ones(1,dim)*lb;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

max_iter=M_Iter;
ArchiveMaxSize=nRep;

Archive_X=zeros(100,dim);
Archive_F=ones(100,obj_no)*inf;

Archive_member_no=0;

r=(ub-lb)/2;
V_max=(ub(1)-lb(1))/10;

Food_fitness=inf*ones(1,obj_no);
Food_position=zeros(dim,1);

Salps_X=initialization(N,dim,ub,lb);
fitness=zeros(N,2);

V=initialization(N,dim,ub,lb);
iter=0;

position_history=zeros(N,max_iter,dim);

for iter=1:max_iter
    
    c1 = 2*exp(-(4*iter/max_iter)^2); % Eq. (3.2) in the paper
    
    for i=1:N %Calculate all the objective values first
        Salps_fitness(i,:)=feval(CostFunction, Salps_X(:,i)');
        if dominates(Salps_fitness(i,:),Food_fitness)
            Food_fitness=Salps_fitness(i,:);
            Food_position=Salps_X(:,i);
        end
    end
    
    [Archive_X, Archive_F, Archive_member_no]=UpdateArchive(Archive_X, Archive_F, Salps_X, Salps_fitness, Archive_member_no);
    
    if Archive_member_no>ArchiveMaxSize
        Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
        [Archive_X, Archive_F, Archive_mem_ranks, Archive_member_no]=HandleFullArchive(Archive_X, Archive_F, Archive_member_no, Archive_mem_ranks, ArchiveMaxSize);
    else
        Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
    end
    
    Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
    % Archive_mem_ranks
    % Chose the archive member in the least population area as food`
    % to improve coverage
    index=RouletteWheelSelection(1./Archive_mem_ranks);
    if index==-1
        index=1;
    end
    Food_fitness=Archive_F(index,:);
    Food_position=Archive_X(index,:)';
    
    for i=1:N
        
        index=0;
        neighbours_no=0;
        
        if i<=N/2
            for j=1:1:dim
                c2=rand();
                c3=rand();
                %%%%%%%%%%%%% % Eq. (3.1) in the paper %%%%%%%%%%%%%%
                if c3<0.5
                    Salps_X(j,i)=Food_position(j)+c1*((ub(j)-lb(j))*c2+lb(j));
                else
                    Salps_X(j,i)=Food_position(j)-c1*((ub(j)-lb(j))*c2+lb(j));
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        elseif i>N/2 && i<N+1
            
            point1=Salps_X(:,i-1);
            point2=Salps_X(:,i);
            
            Salps_X(:,i)=(point2+point1)/(2); % Eq. (3.4) in the paper
        end
        
        Flag4ub=Salps_X(:,i)>ub';
        Flag4lb=Salps_X(:,i)<lb';
        Salps_X(:,i)=(Salps_X(:,i).*(~(Flag4ub+Flag4lb)))+ub'.*Flag4ub+lb'.*Flag4lb;
        
    end
    
%     display(['At the iteration ', num2str(iter), ' there are ', num2str(Archive_member_no), ' non-dominated solutions in the archive']);
    
end
%% Resluts

ps=zeros(nRep, Dim);
pf=zeros(nRep, numel(Archive_F(1, :)));
for i = 1: size(Archive_X, 1)
    ps(i, :)=Archive_X(i, :);
    pf(i, :)=Archive_F(i, :);
end

end