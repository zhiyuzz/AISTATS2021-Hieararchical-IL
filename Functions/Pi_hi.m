function o_RIGHTEND_prob = Pi_hi(s_in,theta_hi,S)
% The high level policy
%   If the state is closer to the left end, then with probability theta_hi
%   the option LEFTEND is chosen, and with probability 1-theta_hi the option
%   RIGHTEND is chosen. Analogously for the other direction.
%   The output is the probability that the option RIGHTEND is chosen
    if s_in <= S/2
        o_RIGHTEND_prob = 1 - theta_hi;
    else
        o_RIGHTEND_prob = theta_hi;
    end
end