function b_true_prob = Pi_b(s_in,o_in,theta_b,S)
% The termination policy
%   If the option is LEFT, then at all states except the left end state, with
%   probability theta_b the termination indicator is FALSE; at the left end
%   state, with probability theta_b the termination indicator is TRUE.
%   Analogously for the option RIGHT. 
%   The output is the probability that the termination indicator is TRUE. 
    if ((s_in==1)&&(o_in==-1)) || ((s_in==S)&&(o_in==1))
        b_true_prob = theta_b;
    else
        b_true_prob = 1 - theta_b;
    end
end