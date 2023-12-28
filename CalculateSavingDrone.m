
% CalculateSavingDrone
%
% data              µÿÕº
% CloseStopS        Õ£øøµ„
%
function SavingMatrixD = CalculateSavingDrone(data,CloseStopS)
customerNum = size(CloseStopS,1);
row=1;
SavingMatrixD = zeros(customerNum * customerNum, 3);
for i = 1:customerNum % º∆À„Savings
    ci = CloseStopS(i,1);
    for j =1:customerNum
        cj = CloseStopS(j,1);
        if ci ~= cj
            SavingMatrixD(row,1) = ci;
            SavingMatrixD(row,2) = cj;
            SavingMatrixD(row,3) = data.disMatrix(CloseStopS(i,2),ci)+data.disMatrix(CloseStopS(j,2),cj)-data.disMatrix(ci,cj);
            row=row+1;
        end
        
    end
end
SavingMatrixD = sortrows(SavingMatrixD,3,"descend");
end