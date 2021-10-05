function gamma = smoothing(alpha,beta)
% Smoothing from alpha and beta

% gamma stores the smoothing distribution; the first index represents the time step, the
% second index represents the option (LEFTEND and RIGHTEND), 
% and the third index represents the termination indicator (FALSE and TRUE)
T = size(alpha,1);
gamma = NaN(T,2,2);

% A quantity to store the unnormalized smoothing distribution
gamma_temp = NaN(2,2);

% The main loop
for t = 1:T
    for i1 = [1,2]
        for i2 = [1,2]
            gamma_temp(i1,i2) = alpha(t,i1,i2) * beta(t,i1,i2);
        end
    end
    norm_const = sum(gamma_temp(:));
    for i1 = [1,2]
        for i2 = [1,2]
            gamma(t,i1,i2) = gamma_temp(i1,i2) / norm_const;
        end
    end
end

end

