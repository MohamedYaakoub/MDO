% Objective function

function [W_TO_max] = objective(des_vec)
% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

% Extract relevant variables from vector:
W_wing = des_vec(61);
W_fuel = des_vec(62);

global data;

W_TO_max = data.C_AW + W_wing + W_fuel;

end


