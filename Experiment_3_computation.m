%% Experiment 3
% Evaluate the effect mu
% The length of obervation T is fixed
% The initial parameter estimate is also fixed

close all
clear
clc

addpath('Functions')
Base_name='Data/observation_seed_';

%% Initialization of the algorithm

S = 4;
zeta = 0.1;

% Total number of sample paths
K = 50;

% Length of each sample path
T_all = 20000;

% Different lengths for computation
T = 5000;

% Total number of iterations
N = 1000;

% mu is the assumed probability that o_0=1 (the initial option is RIGHTEND)
Set_mu = [0.2,0.5,0.8];

% The parameter space for the three parameters are [delta,1-delta]
delta = 0.1;

% The initial parameter estimate
theta_init_hi = 0.5;
theta_init_lo = 0.6;
theta_init_b = 0.7;

% Load sample paths and discard the first half
data = NaN(K,T_all/2,2);
for index_sample_path = 1:K
    load([Base_name,num2str(index_sample_path),'.mat']);
    data(index_sample_path,:,:) = obs(T_all/2+1:end,:);
    clear obs
end

% The parameter output
global parameter
parameter = NaN(K,length(Set_mu),N+1,3);

%% Main loop

Index_sample_path = 1:K;
Index_length = 1:length(Set_mu);
[G1,G2] = meshgrid(Index_sample_path,Index_length);

D = parallel.pool.DataQueue;
D.afterEach(@(x) updateparameter(G1,G2,x));

% Loop over the sample paths and the lengths of observation
parfor index_grid = 1:numel(G1)
    obs = squeeze(data(G1(index_grid),:,:)); %#ok<PFBNS>
    mu = Set_mu(G2(index_grid)); %#ok<PFBNS>
    seq = obs(1:T,:);

    % Assign vectors to store the parameter estimates
    theta_est_hi = NaN(N+1,1);
    theta_est_lo = NaN(N+1,1);
    theta_est_b = NaN(N+1,1);
    
    % Initialize the parameter estimates
    theta_est_hi(1) = theta_init_hi;
    theta_est_lo(1) = theta_init_lo;
    theta_est_b(1) = theta_init_b;

    % The EM iterations
    for n = 2:N+1
        alpha = forward(seq,theta_est_hi(n-1),theta_est_lo(n-1),theta_est_b(n-1),mu,S,zeta);
        beta = backward(seq,theta_est_hi(n-1),theta_est_lo(n-1),theta_est_b(n-1),S,zeta);
        gamma = smoothing(alpha,beta);
        gamma_tilde = two_step_smoothing(seq,theta_est_hi(n-1),theta_est_lo(n-1),theta_est_b(n-1),alpha,beta,S,zeta);
        [theta_est_hi(n),theta_est_lo(n),theta_est_b(n)] = Parameter_update(seq,gamma,gamma_tilde,delta,S);
    end

    send(D,{index_grid,[theta_est_hi,theta_est_lo,theta_est_b]});
end

save('Experiment_3_output.mat','parameter')

% Update the parameter output
function updateparameter(G1,G2,x)
    index_grid = x{1};
    par_index = x{2};
    global parameter
    parameter(G1(index_grid),G2(index_grid),:,:) = par_index;
end

