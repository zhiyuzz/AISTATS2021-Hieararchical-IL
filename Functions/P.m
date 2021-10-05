function s_out = P(s_in,a_in)
% The environment dynamics
%   At any state, if the action is LEFT, then the next state is sampled
%   uniformly from the set of states on the left of the current state
%   (including the current state). Analogously for the action RIGHT.
    global S
    if a_in == -1
        s_out = unidrnd(s_in);
    else
        s_out = s_in + unidrnd(S+1-s_in) - 1;
    end
end