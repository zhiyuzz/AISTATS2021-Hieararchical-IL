close all
clear
clc

load('Experiment_3_output.mat')

%% Calculating the L2 distance to the true parameter

theta_hi_star = 0.6;
theta_lo_star = 0.7;
theta_b_star = 0.8;

K = size(parameter,1);
Mu = size(parameter,2);
N = size(parameter,3);

avg_distance = NaN(Mu,N);

for t = 1:Mu
    distance_t = NaN(K,N);
    for k = 1:K
        parameter_new = squeeze(parameter(k,t,:,:));
        for n = 1:N
            distance_t(k,n) = sqrt((parameter_new(n,1)-theta_hi_star)^2+(parameter_new(n,2)-theta_lo_star)^2 ...
                +(parameter_new(n,3)-theta_b_star)^2);
        end
    end
    
    for n = 1:N
        avg_distance(t,n) = mean(distance_t(:,n));
    end
end

error_ratio = (avg_distance(3,end)-avg_distance(1,end)) / avg_distance(1,end);

x_1 = 0:N-1;
figure('Position',[0 0 400 250])
plot(x_1,avg_distance(1,:),'LineWidth',3)
hold on
plot(x_1,avg_distance(2,:),'LineWidth',3)
plot(x_1,avg_distance(3,:),'LineWidth',3)
legend('\mu = 0.2','\mu = 0.5','\mu = 0.8')
xlabel('Number of iterations (n)','FontSize',14)
ylabel('err(n,T)','FontSize',14)

saveas(gcf,'Experiment_3_figure','epsc')