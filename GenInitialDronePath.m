function Droute = GenInitialDronePath(CloseStopS)
Droute={};
customerNum=size(CloseStopS,1);
for i =1: customerNum
    Droute{i}=[CloseStopS(i,2),CloseStopS(i,1),CloseStopS(i,2)];
end
end