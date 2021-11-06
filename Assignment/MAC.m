function [MAC, MAC1, MAC2] = MAC(des_vec)
% Calculate the mean aerodynamic chord of inboard, outboard and total wing
% Source: https://core.ac.uk/download/pdf/79175663.pdf

import wing_area.*

[~, S1, S2] = wing_area(des_vec);

global data;

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel

des_vec = des_vec .* data.x0;

% Extract required variables
C_r = des_vec(1);
C_mid = C_r * des_vec(2);

taper1 = des_vec(2);
taper2 = des_vec(3);

% Inboard wing
MAC1 = 2/3 * C_r * (1 + taper1 + taper1^2)/(1 + taper1);

% Outboard wing
MAC2 = 2/3 * C_mid * (1 + taper2 + taper2^2)/(1 + taper2);

% Total
MAC = (MAC1*S1 + MAC2*S2)/(S1 + S2);

end