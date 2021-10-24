function [S, S1, S2] = wing_area(des_vec)
% Calculate the wing planform area

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel

% Extract required variables
C_r = des_vec(1);
C_mid = C_r * des_vec(2);
C_tip = C_mid * des_vec(3);

b2 = des_vec(5);

global data;

% NOTE: aree formulas are for one side of the wing, so they are multiplied
% by 2 to get the total area for both inner and outer wings

% Area inboard wing
S1 = 2 * (0.5 * (C_r + C_mid) * data.b1);

% Area outboard wing
S2 = 2 * (0.5 * (C_mid + C_tip) * b2);

% Total area
S = S1 + S2;

end