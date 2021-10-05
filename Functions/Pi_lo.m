function a_RIGHT_prob = Pi_lo(~,o_in,theta_lo)
% The low level policy
%   If the option is LEFT, then at all states, with probability theta_lo the
%   action LEFT is chosen, and with probability 1-theta_lo the action RIGHT
%   is chosen. Analogously for the option RIGHT.
%   The output is the probability that the action RIGHT is chosen. 
    if o_in == 1
        a_RIGHT_prob = theta_lo;
    else
        a_RIGHT_prob = 1 - theta_lo;
    end
end