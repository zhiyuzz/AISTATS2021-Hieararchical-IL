close all
clear
clc

load('Experiment_1_output.mat')

%% Calculating the L2 distance to the true parameter

theta_hi_star = 0.6;
theta_lo_star = 0.7;
theta_b_star = 0.8;

K = size(parameter,1);
N = size(parameter,3);
index_T = 2; % T = 8000;

distance = NaN(K,N);
avg_distance = NaN(N,1);
for k = 1:K
    parameter_new = squeeze(parameter(k,index_T,:,:));
    for n = 1:N
        distance(k,n) = sqrt((parameter_new(n,1)-theta_hi_star)^2+(parameter_new(n,2)-theta_lo_star)^2 ...
            +(parameter_new(n,3)-theta_b_star)^2);
    end
end

for n = 1:N
    avg_distance(n) = mean(distance(:,n));
end

% Evaluating the average distance to the true parameter over smaller sets
% of sample paths
M = 10;
avg_distance_small = NaN(M,N);
for m = 1:M
    index_small = ~isoutlier(distance(:,end),'percentile',[10*(m-1),10*m]);
    distance_small = distance(index_small,:);
    for n = 1:N
        avg_distance_small(m,n) = mean(distance_small(:,n));
    end
end

x_1 = 0:N-1;

figure('Position',[0 0 900 280])

subplot('Position',[0.08 0.17 0.4 0.78]);
for m = 1:5
    plot(x_1,avg_distance_small(m,:),'LineWidth',3)
    hold on
end
plot(x_1,avg_distance,'LineWidth',3)
legend('I = [0,10]','I = [10,20]','I = [20,30]','I = [30,40]','I = [40,50]','I = [0,100]')
xlabel('Number of iterations (n)','FontSize',14)
ylabel('err(n,T,I)','FontSize',14)

subplot('Position',[0.58 0.17 0.4 0.78]);
for m = 6:10
    plot(x_1,avg_distance_small(m,:),'LineWidth',3)
    hold on
end
plot(x_1,avg_distance,'LineWidth',3)
legend('I = [50,60]','I = [60,70]','I = [70,80]','I = [80,90]','I = [90,100]','I = [0,100]')
xlabel('Number of iterations (n)','FontSize',14)
ylabel('err(n,T,I)','FontSize',14)

saveas(gcf,'Experiment_1_figure_by_percentile','epsc')