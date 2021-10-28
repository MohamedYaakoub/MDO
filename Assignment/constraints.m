% Constraints

function [c, ceq] = constraints(des_vec)

import wing_area.*
import tank_volume.*

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

% Extract required variables
W_wing = des_vec(61);
W_fuel = des_vec(62);

global data;

% NOTE: fmincon takes <= constraints, careful with signs

% ---------- Constraint 1: Tank volume ----------
% Calculate fuel volume
V_fuel = W_fuel/data.density_fuel;

% Calculate fuel tank volume
V_tank = tank_volume(des_vec); 

% Constraint
c(1) = V_fuel - V_tank * data.f_tank;

% ---------- Constraint 2: Wing loading ---------

% Calculate first wing area and W_TO,max
[S, ~, ~] = wing_area(des_vec);
W_TO_max = data.C_AW + W_wing + W_fuel;
% Then calculate loading and compare to original one
WS = W_TO_max/S;
% Constraint
c(2) = WS - data.WS_orig;

% Equality constraints for copy variables
ceq(1) = data.Cl - des_vec(32:45);
ceq(2) = data.Cm - des_vec(46:59);
ceq(3) = data.LD_ratio - des_vec(60);
ceq(4) = data.W_wing - des_vec(61);
ceq(5) = data.W_fuel - des_vec(62);

end
