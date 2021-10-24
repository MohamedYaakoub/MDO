function [chord] = chord(y, des_vec)
% Calculate the chord length at a given span position

import wing_area.*

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel

[~, S1, S2] = wing_area(des_vec);

% Extract required variables
taper1 = des_vec(2);
taper2 = des_vec(3);

global data;

if y<data.b1
    chord = 2*S1 / ((1 + taper1) * data.b1) * (1 - (1 - taper1)/data.b1 * abs(2*y));

else
    y = y - data.b1;
    chord = 2*S2 / ((1 + taper2) * b2) * (1 - (1 - taper2)/b2 * abs(2*y));

end

end
