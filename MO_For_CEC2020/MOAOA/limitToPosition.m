%
% Copyright (c) 2015, Mostapha Kalami Heris & Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
%
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
%
% Cite as:
% Mostapha Kalami Heris, NSGA-II in MATLAB (URL: https://yarpiz.com/56/ypea120-nsga2), Yarpiz, 2015.
%
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function Position = limitToPosition(Position,VarMin,VarMax)
for i =1:size(Position,2)
    if size(VarMin, 2) == 1
        if Position(i)<VarMin
            Position(i) = VarMin;
        elseif Position(i) > VarMax
            Position(i) = VarMax;
        end
    else
        if Position(i)<VarMin(i)
            Position(i) = VarMin(i);
        elseif Position(i) > VarMax(i)
            Position(i) = VarMax(i);
        end
    end
    
end
end