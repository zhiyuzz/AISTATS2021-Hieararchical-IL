function gamma_tilde = two_step_smoothing(seq,theta_hi,theta_lo,theta_b,alpha,beta,S,zeta)
% Two step smoothing from alpha and beta

% gamma_tilde stores the two step smoothing distribution; 
% the first index represents the time step, the
% second index represents the option (LEFTEND and RIGHTEND) at the last
% time step
% and the third index represents the termination indicator (FALSE and TRUE)
T = size(seq,1);
gamma_tilde = NaN(T,2,2);

% A quantity to store the unnormalized two step smoothing distribution
gamma_temp = NaN(2,2);

for t = 2:T
    for i1 = [1,2]
        % Convert the index to options
        if i1 == 1
            o_past = -1;
        else
            o_past = 1;
        end
          
        for i2 = [1,2]
            % Convert the index to termination indicators
            if i2 == 1
                b = false;
            else
                b = true;
            end
            
            gamma_temp(i1,i2) = 0;
            for i1_next = [1,2]
                if i1_next == 1
                    o = -1;
                else
                    o = 1;
                end
                
                gamma_temp(i1,i2) = gamma_temp(i1,i2) + beta(t,i1_next,i2)...
                    * Pi_combined(o_past,seq(t,1),seq(t,2),o,b,theta_hi,theta_lo,theta_b,S,zeta);
            end
            
            gamma_temp(i1,i2) = gamma_temp(i1,i2) * sum(alpha(t-1,i1,:));
            
        end
    end
    
    norm_const = sum(gamma_temp(:));
    
    for i1 = [1,2]
        for i2 = [1,2]
            gamma_tilde(t,i1,i2) = gamma_temp(i1,i2) / norm_const;
        end
    end
end

end

