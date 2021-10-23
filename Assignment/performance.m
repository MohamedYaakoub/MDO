% Performance

function [W_fuel] = performance(des_vec)
% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

% Extract relevant variables from vector:
W_wing = des_vec(15);

global data;

% Function to calculate fuel weight
W_fuel = (data.C_AW + W_wing) * (1 - 0.938*data.WeWs) / (0.938*data.WeWs);
end
