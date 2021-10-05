function output = Pi_combined(ot_past,st,at,ot,bt,theta_hi,theta_lo,theta_b,S,zeta)
% The combined function of the three policy components, used in the forward
% and backward recursion

if ot == 1
    pihi_eval = Pi_hi_bar(st,ot_past,bt,theta_hi,S,zeta);
else
    pihi_eval = 1 - Pi_hi_bar(st,ot_past,bt,theta_hi,S,zeta);
end

if at == 1
    pilo_eval = Pi_lo(st,ot,theta_lo);
else
    pilo_eval = 1 - Pi_lo(st,ot,theta_lo);
end

if bt == true
    pib_eval = Pi_b(st,ot_past,theta_b,S);
else
    pib_eval = 1 - Pi_b(st,ot_past,theta_b,S);
end

output = pihi_eval * pilo_eval * pib_eval;

end

