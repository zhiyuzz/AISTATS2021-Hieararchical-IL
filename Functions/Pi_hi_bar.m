function o_RIGHTEND_prob = Pi_hi_bar(s_in,o_in,b_in,theta_hi,S,zeta)
% The high level policy combined with the failure structure
%   The output is the probability that the option RIGHTEND is chosen
    if b_in == true
        o_RIGHTEND_prob = Pi_hi(s_in,theta_hi,S);
    elseif o_in == 1
        o_RIGHTEND_prob = 1 - zeta/2;
    else
        o_RIGHTEND_prob = zeta/2;
    end
end

