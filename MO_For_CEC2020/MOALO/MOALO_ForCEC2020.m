function [ps,pf]=MOALO_ForCEC2020(N,M_Iter,LB,UB,Dim,nRep,CostFunction)


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

% Initial parameters of the MODA algorithm
max_iter=M_Iter;
ArchiveMaxSize=nRep;

Archive_X=zeros(100,dim);
Archive_F=ones(100,obj_no)*inf;

Archive_member_no=0;

r=(ub-lb)/2;
V_max=(ub(1)-lb(1))/10;

Elite_fitness=inf*ones(1,obj_no);
Elite_position=zeros(dim,1);

Ant_Position=initialization(N,dim,ub,lb);
fitness=zeros(N,2);

V=initialization(N,dim,ub,lb);
iter=0;

position_history=zeros(N,max_iter,dim);

for iter=1:max_iter
    
    for i=1:N %Calculate all the objective values first
        Particles_F(i,:)=feval(CostFunction, Ant_Position(:,i)');
        if dominates(Particles_F(i,:),Elite_fitness)
            Elite_fitness=Particles_F(i,:);
            Elite_position=Ant_Position(:,i);
        end
    end
    
    [Archive_X, Archive_F, Archive_member_no]=UpdateArchive(Archive_X, Archive_F, Ant_Position, Particles_F, Archive_member_no);
    
    if Archive_member_no>ArchiveMaxSize
        Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
        [Archive_X, Archive_F, Archive_mem_ranks, Archive_member_no]=HandleFullArchive(Archive_X, Archive_F, Archive_member_no, Archive_mem_ranks, ArchiveMaxSize);
    else
        Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
    end
    
    Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
    
    % Chose the archive member in the least population area as arrtactor
    % to improve coverage
    index=RouletteWheelSelection(1./Archive_mem_ranks);
    if index==-1
        index=1;
    end
    Elite_fitness=Archive_F(index,:);
    Elite_position=Archive_X(index,:)';
    
    Random_antlion_fitness=Archive_F(1,:);
    Random_antlion_position=Archive_X(1,:)';
    
    for i=1:N
        
        index=0;
        neighbours_no=0;
        
        RA=Random_walk_around_antlion(dim,max_iter,lb,ub, Random_antlion_position',iter);
        
        [RE]=Random_walk_around_antlion(dim,max_iter,lb,ub, Elite_position',iter);
        
        Ant_Position(:,i)=(RE(iter,:)'+RA(iter,:)')/2;
        
        
        
        Flag4ub=Ant_Position(:,i)>ub';
        Flag4lb=Ant_Position(:,i)<lb';
        Ant_Position(:,i)=(Ant_Position(:,i).*(~(Flag4ub+Flag4lb)))+ub'.*Flag4ub+lb'.*Flag4lb;
        
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