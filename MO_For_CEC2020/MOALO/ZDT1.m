%_________________________________________________________________________%
%  Multi-Objective Ant Lion Optimizer (MALO) source codes demo            %
%                           version 1.0                                   %
%                                                                         %
%  Developed in MATLAB R2011b(7.13)                                       %
%                                                                         %
%  Author and programmer: Seyedali Mirjalili                              %
%                                                                         %
%         e-Mail: ali.mirjalili@gmail.com                                 %
%                 seyedali.mirjalili@griffithuni.edu.au                   %
%                                                                         %
%       Homepage: http://www.alimirjalili.com                             %
% Paper: Mirjalili, Seyedali, Pradeep Jangir, and Shahrzad Saremi.        %
% Multi-objective ant lion optimizer: a multi-objective optimization      % 
%  algorithm for solving engineering problems." Applied Intelligence      %
% (2016): 1-17, DOI: http://dx.doi.org/10.1007/s10489-016-0825-8          %
%_________________________________________________________________________%

% Modify this file with respect to your objective function
function o = ZDT1(x)

o = [0, 0];

dim = length(x);
g = 1 + 9*sum(x(2:dim))/(dim-1);

o(1) = x(1);
o(2) = g*(1-sqrt(x(1)/g));



