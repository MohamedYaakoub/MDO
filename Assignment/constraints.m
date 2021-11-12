% Constraints

function [c, ceq] = constraints(des_vec)

import wing_area.*
import tank_volume.*

[S, ~, ~] = wing_area(des_vec);
% Calculate fuel tank volume (before denormalising vector)
V_tank = tank_volume(des_vec); 

global data;

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]


des_vec = des_vec .* data.x0;

% Extract required variables
W_wing = des_vec(61);
W_fuel = des_vec(62);


% NOTE: fmincon takes <= constraints, careful with signs

% ---------- Constraint 1: Tank volume ----------
% Calculate fuel volume
V_fuel = W_fuel/data.density_fuel;


% Constraint (normalised)
c(1) = V_fuel/data.V_f_ref - V_tank * data.f_tank / data.V_f_ref ;

fprintf('V_fuel %f V_tank*f_tank %f \n', V_fuel, V_tank * data.f_tank)


% ---------- Constraint 2: Wing loading ---------

% Calculate first wing area and W_TO,max

W_TO_max = data.C_AW + W_wing + W_fuel;
% Then calculate loading and compare to original one
WS = W_TO_max/S;

% Constraint
c(2) = WS / data.WS_orig - 1;

fprintf('WS %f WS_orig %f \n', WS, data.WS_orig)

% Print for debugging
% disp(data.Cl)
% disp(data.Cm)
% disp(data.LD_ratio)
% disp(data.W_wing)
% disp(data.W_fuel)

% Equality constraints for copy variables (normalised)
ceq(1:14) = data.Cl / des_vec(32:45) - ones(size(data.Cl));
ceq(15:28) = data.Cm / des_vec(46:59) - ones(size(data.Cm));
ceq(3) = data.LD_ratio / des_vec(60) - 1;
ceq(4) = data.W_wing / des_vec(61) - 1;
ceq(5) = data.W_fuel / des_vec(62) - 1;



end
