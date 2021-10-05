function beta = backward(seq,theta_hi,theta_lo,theta_b,S,zeta)
% The backward recursion

% beta stores the backward message; the first index represents the time step, the
% second index represents the option (LEFTEND and RIGHTEND), 
% and the third index represents the termination indicator (FALSE and TRUE)
T = size(seq,1);
beta = NaN(T,2,2);

% A quantity to store the unnormalized backward message
beta_temp = NaN(2,2);

% The first round
for i1 = [1,2]
    for i2 = [1,2]
        beta(T,i1,i2) = 0.25;
    end
end

% The main loop
for t_raw = 1:T-1
    % Reversing the time index
    t = T - t_raw;
    for i1 = [1,2]
        % Convert the index to options
        if i1 == 1
            o = -1;
        else
            o = 1;
        end
          
        for i2 = [1,2]
            beta_temp(i1,i2) = 0;
            for i1_next = [1,2]
                if i1_next == 1
                    o_next = -1;
                else
                    o_next = 1;
                end
                for i2_next = [1,2]
                    if i2_next == 1
                        b_next = false;
                    else
                        b_next = true;
                    end
                    beta_temp(i1,i2) = beta_temp(i1,i2)...
                        + (Pi_combined(o,seq(t+1,1),seq(t+1,2),o_next,b_next,theta_hi,theta_lo,theta_b,S,zeta)...
                        * beta(t+1,i1_next,i2_next));
                end
            end
        end
    end
    
    norm_const = sum(beta_temp(:));
    for i1 = [1,2]
        for i2 = [1,2]
            beta(t,i1,i2) = beta_temp(i1,i2) / norm_const;
        end
    end
end

end

