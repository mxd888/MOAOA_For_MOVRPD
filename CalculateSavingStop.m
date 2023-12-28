function SavingMatrixV = CalculateSavingStop(data,StopSet)
stoppingNum = length(StopSet);%只计算可用的停靠点之间的节约矩阵
row = 1;
for i = 1:stoppingNum
    si = StopSet(i);
    for j = 1:stoppingNum
        sj = StopSet(j);
        if si~=sj
            SavingMatrixV(row,1)=si;
            SavingMatrixV(row,2)=sj;
            SavingMatrixV(row,3)=data.disMatrix(1,si) + data.disMatrix(1,sj)-data.disMatrix(si,sj);
        end
        row = row+1;
    end
end
SavingMatrixV = sortrows(SavingMatrixV,3,"descend");
end