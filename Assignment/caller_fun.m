% Function to call disciplines and objective

function [W_TO_max] = caller_fun(des_vec)
% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel

import loads.*
import structures.*
import aerodynamics.*
import performance.*
import objective.*

global data;

% disp('Iteration')

% Calculate disciplines
[Cl, Cm] = loads(des_vec);
W_wing = structures(des_vec);
LD_ratio = aerodynamics(des_vec);
W_fuel = performance(des_vec);

% Objective function
W_TO_max = objective(des_vec);

% Save disciplines as global variables
data.Cl = Cl;
data.Cm = Cm;
data.W_wing = W_wing;
data.LD_ratio = LD_ratio;
data.W_fuel = W_fuel;

% ---------------------------------------------------
% ------------------ Progress file ------------------
% --------------------------------------------------- 
init = fopen('optim_progress.dat','w');

line = Cl;
format_line = 'Cl: %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n';
fprintf(init, format_line, line);

line = Cm;
format_line = 'Cm: %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n';
fprintf(init, format_line, line);

line = W_wing;
format_line = 'W_wing: %f \n';
fprintf(init, format_line, line);

line = LD_ratio;
format_line = 'LD_ratio: %f \n';
fprintf(init, format_line, line);

line = W_fuel;
format_line = 'W_fuel %f \n';
fprintf(init, format_line, line);

line = W_TO_max;
format_line = 'W_TO_max %f \n';
fprintf(init, format_line, line);


fclose(init);

end
