
clear all; clc; close;


Solution_no=20; %Number of search solutions
F_name='F1';    %Name of the test function F1-f23
M_Iter=1000;    %Maximum number of iterations
 
[LB,UB,Dim,F_obj]=Get_F(F_name); %Give details of the underlying benchmark function


MOP_Max=1;
MOP_Min=0.2;
C_Iter=1;
Alpha=5;
c=zeros(2,M_Iter);
while C_Iter<M_Iter+1  %Main loop
    MOP=1-((C_Iter)^(1/Alpha)/(M_Iter)^(1/Alpha));   % Probability Ratio 
    MOA=MOP_Min+C_Iter*((MOP_Max-MOP_Min)/M_Iter); %Accelerated function
    c(1, C_Iter) = MOP;
    c(2, C_Iter) = MOA;
    C_Iter=C_Iter+1;  % incremental iteration
end

[Best_FF,Best_P,Conv_curve]=AOA(Solution_no,M_Iter,LB,UB,Dim,F_obj); % Call the AOA   -100 100 10
 

% Best_FF
% Best_P
figure('Position',[454   445   694   297]);
subplot(1,2,1);
func_plot(F_name);
title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([F_name,'( x_1 , x_2 )'])
% 
% 
subplot(1,2,2);
semilogy(Conv_curve,'Color','b','LineWidth',2)
title('Convergence curve')
xlabel('Iteration#');
ylabel('Best fitness function');
axis tight
legend('AOA')



% display(['The best-obtained solution by Math Optimizer is : ', num2str(Best_P)]);
% display(['The best optimal value of the objective funciton found by Math Optimizer is : ', num2str(Best_FF)]);

        



