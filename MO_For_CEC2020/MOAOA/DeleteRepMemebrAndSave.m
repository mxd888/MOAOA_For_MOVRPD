%
% Copyright (c) 2022, Xiao Dong Mi & MDong
% All rights reserved. Please read the "LICENSE" file for license terms.
%
% Project Code: MDong
% Project Title: Multi-Objective Arithmetic Optimization Algorithm (MOAOA)
% Publisher: MDong (https://gitee.com/starboot)
% 
% Developer: Xiao Dong Mi (Member of GXMZ Team)
% 
% Cite as:
% Xiao Dong Mi, Multi-Objective AOA in MATLAB (URL: https://gitee.com/starboot), MDong, 2022.
% 
% Contact Info: 15511090450@163.com, 1191998028@qq.com
%

function rep = DeleteRepMemebrAndSave(rep, pop, nRep, P)

    [rep, pop] = DetermineDomination(rep, pop);
    
    if isfield(pop, 'VehiclePath')
        index = find([pop.hasfound]==0);
        pop(index) = [];
    else
        index = find([pop.DominatedCount]>0);
        pop(index) = [];
    end
    

    
    PopNum = numel(pop);
    
    repDel = [];
    
    repNum = numel(rep);
    
    for i=1:repNum
        
        if rep(i).DominatedCount > 0
            
            repDel = [repDel i];
            
        end
        
    end

    if repNum + PopNum <= nRep
        
        % 清除pop后就可以放
        rep = MatrixMerge(rep, pop);
        
    elseif nRep - (repNum - numel(repDel)) >= PopNum
        
        % 删了够放，按照被支配次数将序排序进行删除
        RepIndex = nRep - repNum;
        
        delNum = PopNum - RepIndex;
        
        repDel = sort(repDel, 'descend');
        
        for i=1:delNum
            
            rep(repDel(i)) = [];
            
        end
        
        rep = MatrixMerge(rep, pop);
        
    else
        
        % 删除也不够放
        rep(repDel(:)) = [];
        
        rep = MatrixMerge(rep, pop);
        
        [rep, ~] = Processor(rep, P);
        
        rep=rep(1:nRep);
        
    end

end