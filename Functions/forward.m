function alpha = forward(seq,theta_hi,theta_lo,theta_b,mu,S,zeta)
% The forward recursion

% alpha stores the forward message; the first index represents the time step, the
% second index represents the option (LEFTEND and RIGHTEND), 
% and the third index represents the termination indicator (FALSE and TRUE)
T = size(seq,1);
alpha = NaN(T,2,2);

% A quantity to store the unnormalized forward message
alpha_temp = NaN(2,2);

% The first round
for i1 = [1,2]
    % Convert the index to options
    if i1 == 1
        o = -1;
    else
        o = 1;
    end
    
    for i2 = [1,2]
        % Convert the index to termination indicators
        if i2 == 1
            b = false;
        else
            b = true;
        end
        
        alpha_temp(i1,i2) = mu * Pi_combined(1,seq(1,1),seq(1,2),o,b,theta_hi,theta_lo,theta_b,S,zeta)...
            + (1-mu) * Pi_combined(-1,seq(1,1),seq(1,2),o,b,theta_hi,theta_lo,theta_b,S,zeta);
    end
end

% Normalization
norm_const = sum(alpha_temp(:));
for i1 = [1,2]
    for i2 = [1,2]
        alpha(1,i1,i2) = alpha_temp(i1,i2) / norm_const;
    end
end

% The main loop
for t = 2:T
    % Find the weight from the last iteration
    weight = sum(alpha(t-1,2,:));
    
    for i1 = [1,2]
        % Convert the index to options
        if i1 == 1
            o = -1;
        else
            o = 1;
        end
          
        for i2 = [1,2]
            % Convert the index to termination indicators
            if i2 == 1
                b = false;
            else
                b = true;
            end

            alpha_temp(i1,i2) = weight * Pi_combined(1,seq(t,1),seq(t,2),o,b,theta_hi,theta_lo,theta_b,S,zeta)...
                + (1-weight) * Pi_combined(-1,seq(t,1),seq(t,2),o,b,theta_hi,theta_lo,theta_b,S,zeta);
        end
    end
    
    norm_const = sum(alpha_temp(:));
    for i1 = [1,2]
        for i2 = [1,2]
            alpha(t,i1,i2) = alpha_temp(i1,i2) / norm_const;
        end
    end
    
end

end

