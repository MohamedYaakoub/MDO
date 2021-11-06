% Performance

function [W_fuel] = performance(des_vec)
% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]


global data;

des_vec = des_vec .* data.x0;

% Extract relevant variables from vector:
LD_ratio = des_vec(60);
W_wing = des_vec(61);


% Function to calculate fuel weight
WsWe = exp(data.range*data.C_T/data.V_cr/LD_ratio);  % From Breguet's range equation 
WeWs = 1/WsWe;      % W_end,cr / W_start,cr [-]


W_fuel = (data.C_AW + W_wing) * (1 - 0.938*WeWs) / (0.938*WeWs);

end
