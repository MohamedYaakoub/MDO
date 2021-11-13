% Objective function

function [W_TO_max] = objective(W_wing, W_fuel)

global data;

W_TO_max = data.C_AW + W_wing + W_fuel;

% Normalise
W_TO_max = W_TO_max / data.MTOM_ref;

end

% function [W_TO_max] = objective(des_vec)
% 
% global data;
% 
% % ---------- Design vector format ----------
% % [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% % [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]
% 
% des_vec = des_vec .* data.x0;
% 
% % Extract relevant variables from vector:
% W_wing = des_vec(61);
% W_fuel = des_vec(62);
% 
% W_TO_max = data.C_AW + W_wing + W_fuel;
% 
% % Normalise
% W_TO_max = W_TO_max / data.MTOM_ref;
% 
% end


