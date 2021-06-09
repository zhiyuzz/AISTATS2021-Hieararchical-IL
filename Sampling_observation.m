close all
clear
clc

addpath('Functions')
Base_name='Data/observation_seed_';

%% Definition of the environment

% Size of the state space
S = 4;

% The failure probability
zeta = 0.1;

% The action space has two elements: LEFT (-1) and RIGHT (1)
% The environment dynamics is defined in the function P

%% Definition of the expert policy

% The option space has two elements: LEFTEND (-1) and RIGHTEND (1)
% The structure of the policy is defined in the functions Pi_hi, Pi_lo and
% Pi_b; combined with the failure structure, the high level policy becomes
% Pi_hi_bar

% The parameter for the expert policy
theta_hi_star = 0.6;
theta_lo_star = 0.7;
theta_b_star = 0.8;

%% Sampling the observation sequence

% Length of the observation sequence
T = 20000;

% Initial state and option
s_init = S / 2;
o_init = -1;

for k = 1:50
    % Setting the random seed
    rng(k)
    
    % The observation sequence is stored in a T by 2 matrix. The first column
    % represents the states, and the second column represents the actions. The
    % t-th row represents the state and action pair s_t and a_t. 
    obs = NaN(T,2);

    % The first round
    obs(1,1) = s_init;
    b_temp = logical(binornd(1,Pi_b(obs(1,1),o_init,theta_b_star,S)));
    o_temp = 2 * binornd(1,Pi_hi_bar(obs(1,1),o_init,b_temp,theta_hi_star,S,zeta)) - 1;
    obs(1,2) = 2 * binornd(1,Pi_lo(obs(1,1),o_temp,theta_lo_star)) - 1;

    % The remaining rounds
    for t = 2:T
        obs(t,1) = P(obs(t-1,1),obs(t-1,2));
        b_temp = logical(binornd(1,Pi_b(obs(t,1),o_temp,theta_b_star,S)));
        o_temp = 2 * binornd(1,Pi_hi_bar(obs(t,1),o_temp,b_temp,theta_hi_star,S,zeta)) - 1;
        obs(t,2) = 2 * binornd(1,Pi_lo(obs(t,1),o_temp,theta_lo_star)) - 1;
    end
    
    % Saving the observation sequence into a file
    File_name=[Base_name,num2str(k),'.mat'];
    save(File_name,'obs');
end
