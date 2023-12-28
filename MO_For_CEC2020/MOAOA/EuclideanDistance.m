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

function res = EuclideanDistance(positionOne, positionTwo)

    if numel(positionOne) == numel(positionTwo)

        res = 0;
        
        for i=1:numel(positionOne)

            res = res + (positionOne(i) - positionTwo(i))^2;

        end

        res = sqrt(res);

    else

        error('stats:EuclideanDistance:Dimension is inconsistent'); 

    end

end
