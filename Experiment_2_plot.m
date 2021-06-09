close all
clear
clc

load('Experiment_2_output.mat')

%% Calculating the L2 distance to the true parameter

theta_hi_star = 0.6;
theta_lo_star = 0.7;
theta_b_star = 0.8;

K = size(parameter,1);
T = size(parameter,2);
N = size(parameter,3);

avg_distance = NaN(T,N);
avg_distance_outlier_rmd = NaN(T,N);

for t = 1:T
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

x_1 = 0:N-1;
log_length = (N-1) / 100;
x_2 = 0:log_length;

figure('Position',[0 0 900 280])

subplot('Position',[0.08 0.17 0.4 0.78]);
plot(x_1,avg_distance(1,:),'LineWidth',3)
hold on
plot(x_1,avg_distance(2,:),'LineWidth',3)
plot(x_1,avg_distance(3,:),'LineWidth',3)
legend('w = 0.1','w = 0.2','w = 0.3')
xlabel('Number of iterations (n)','FontSize',14)
ylabel('err(n,T)','FontSize',14)

subplot('Position',[0.58 0.17 0.4 0.78]);
plot(x_2,log(avg_distance(1,1:log_length+1)),'LineWidth',3)
hold on
plot(x_2,log(avg_distance(2,1:log_length+1)),'LineWidth',3)
plot(x_2,log(avg_distance(3,1:log_length+1)),'LineWidth',3)
legend('w = 0.1','w = 0.2','w = 0.3')
xlabel('Number of iterations (n)','FontSize',14)
ylabel('log[err(n,T)]','FontSize',14)

saveas(gcf,'Experiment_2_figure','epsc')