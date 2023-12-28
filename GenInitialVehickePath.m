function Vroute = GenInitialVehickePath(StopSet)
Pathlength = length(StopSet);
Vroute = {};
row = 1;
for i = 1:Pathlength
    if StopSet(i)~=1
        Vroute{row} = [1,StopSet(i),1];
        row = row +1;
    end
end
end