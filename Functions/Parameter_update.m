function [theta_hi,theta_lo,theta_b] = Parameter_update(seq,gamma,gamma_tilde,delta,S)
% The parameter update step

T = size(seq,1);

% Update theta_hi first
theta_hi_temp = 0;
for t = 1:T
    if seq(t,1) <= S/2
        theta_hi_temp = theta_hi_temp + gamma(t,1,2);
    else
        theta_hi_temp = theta_hi_temp + gamma(t,2,2);
    end
end
theta_hi = theta_hi_temp / sum(sum(gamma(:,:,2)));

if theta_hi < delta
    theta_hi = delta;
elseif theta_hi > 1-delta
    theta_hi = 1-delta;
end

% Update theta_lo
theta_lo_temp = 0;
for t = 1:T
    if seq(t,2) == -1
        theta_lo_temp = theta_lo_temp + sum(gamma(t,1,:));
    else
        theta_lo_temp = theta_lo_temp + sum(gamma(t,2,:));
    end
end
theta_lo = theta_lo_temp / T;

if theta_lo < delta
    theta_lo = delta;
elseif theta_lo > 1-delta
    theta_lo = 1-delta;
end

% Update theta_b
theta_b_temp = 0;
for t = 2:T
    for o = [1,2]
        if ((seq(t,1)==1)&&(o==1)) || ((seq(t,1)==S)&&(o==2))
            theta_b_temp = theta_b_temp + gamma_tilde(t,o,2);
        else
            theta_b_temp = theta_b_temp + gamma_tilde(t,o,1);
        end
    end
end
theta_b = theta_b_temp / (T-1);

if theta_b < delta
    theta_b = delta;
elseif theta_b > 1-delta
    theta_b = 1-delta;
end

end

