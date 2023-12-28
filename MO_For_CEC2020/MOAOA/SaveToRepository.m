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

function rep = SaveToRepository(rep, pop, nRep, P)

    if isempty(rep)

        % ≥ı ºªØ
        if numel(pop)<=nRep

            rep = pop;

        else

            rep = pop(1:nRep);

        end

    else

        if numel(rep) + numel(pop) <= nRep

            rep = MatrixMerge(rep, pop);

        else

            rep = DeleteRepMemebrAndSave(rep, pop, nRep, P);

        end

    end

end

