% Structures

function [W_wing] = structures(des_vec)
% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

import chord.*
import MAC.*

global data;

% Extract relevant variables from vector:
C_r = des_vec(1);
C_mid = C_r * des_vec(2);
C_tip = C_mid * des_vec(3);

sweep_LE_2 = des_vec(4);
b2 = des_vec(5);

Cl = des_vec(12);
Cm = des_vec(13);

W_wing = des_vec(15);
W_fuel = des_vec(16);

% Wing planform geometry
x2 = C_r - C_mid;

x3 = x2 + b2 * tand(sweep_LE_2);
y3 = data.b1 + b2;
z3 = (data.b1 + b2)*tand(data.dihedral); % REVISE

% Area
% TODO S = 1;


% First, create a script that takes the design vector as an
% input and writes the .init and airfoil coords file to read EMWET

% ---------------------------------------------------
% -------------------- Init file --------------------
% --------------------------------------------------- 
init = fopen('b767.init','w');

% Line 1 [MTOW, ZFW]
line = [data.C_AW+W_wing+W_fuel, data.C_AW+W_wing];
format_line = '%f %f \n';
fprintf(init, format_line, line);

% Line 2 [n_max]
line = [data.n_max];
format_line = '%f \n';
fprintf(init, format_line, line);

% Line 3 [area, span, #sec for planform, #sec for airfoil]
line = [S, 2*data.b1+2*b2, 3, 2];
format_line = '%f %f %.0f %.0f \n';
fprintf(init, format_line, line);

% Line 4 [y/b span, name airfoil file]
line = [0, 'airfoil_root'];
format_line = '%.0f %s \n';
fprintf(init, format_line, line);

% Line 5 [y/b span, name airfoil file]
line = [1, 'airfoil_tip'];
format_line = '%.0f %s \n';
fprintf(init, format_line, line);

% Line 6 Root: [chord, x, y, z, x/c front spar, x/c rear spar]
line = [C_r, 0, 0, 0, data.x_spar_f, data.x_spar_r];
format_line = '%f %f %f %f %f %f \n';
fprintf(init, format_line, line);

% Line 7 Mid: [chord, x, y, z, x/c front spar, x/c rear spar]
line = [C_mid, x2, data.y2, data.z2, data.x_spar_f, data.x_spar_r];
format_line = '%f %f %f %f %f %f \n';
fprintf(init, format_line, line);

% Line 8 Tip: [chord, x, y, z, x/c front spar, x/c rear spar]
line = [C_tip, x3, y3, z3, data.x_spar_f, data.x_spar_r];
format_line = '%f %f %f %f %f %f \n';
fprintf(init, format_line, line);

% Line 9 [start fuel tank, end fuel tank]
line = [data.min_b_tank, data.max_b_tank];
format_line = '%f %f \n';
fprintf(init, format_line, line);

% Line 10 [# engines per wing]
line = data.n_eng_wing;
format_line = '%d \n';
fprintf(init, format_line, line);

% Line 11 [spanwise location engine, mass engine [kg]]
line = [data.eng_pos, data.eng_mass];
format_line = '%f %f \n';
fprintf(init, format_line, line);

% Line 12 [Young's modulus, density, tensile stress, compressive stress]
line = [data.E_al, data.density_al, data.yield_stress_al_ten, data.yield_stress_al_comp];
format_line = '%f %f %f %f \n';
fprintf(init, format_line, line);

% Line 13 [Young's modulus, density, tensile stress, compressive stress]
line = [data.E_al, data.density_al, data.yield_stress_al_ten, data.yield_stress_al_comp];
format_line = '%f %f %f %f \n';
fprintf(init, format_line, line);

% Line 14 [Young's modulus, density, tensile stress, compressive stress]
line = [data.E_al, data.density_al, data.yield_stress_al_ten, data.yield_stress_al_comp];
format_line = '%f %f %f %f \n';
fprintf(init, format_line, line);

% Line 15 [Young's modulus, density, tensile stress, compressive stress]
line = [data.E_al, data.density_al, data.yield_stress_al_ten, data.yield_stress_al_comp];
format_line = '%f %f %f %f \n';
fprintf(init, format_line, line);

% Line 16 [f stiffened panel, rib pitch [m]]
line = [data.stiff_eff_factor, data.rib_pitch];
format_line = '%f %f \n';
fprintf(init, format_line, line);

% Line 17 [display option]
line = 0;
format_line = '%d \n';
fprintf(init, format_line, line);

fclose(init);

% ---------------------------------------------------
% -------------------- Load file --------------------
% --------------------------------------------------- 
load = fopen('b767.load','w');

% File needs lift and pitching moment (dimensional), not coefficients

% Array with spanwise positions
positions = linspace(0, 1, length(Cl));

q = 0.5 * data.density_cr * data.V_cr^2;    % Dynamic pressure
[MAC_tot, ~, ~] = MAC(des_vec);             % Mean Aerodynamic Chord
chords = chord(positions, des_vec);         % Chord at each position



% Arrays with dimensional lift and moment
L = chords.*Cl * q;
M = chords.*Cm * MAC_tot * q;


% [Spanwise position, Lift, Pitching moment]
lines = [positions; L; M]; 
fprintf(init, '%f %f %f \n', lines);

fclose(load);

% ---------------------------------------------------
% -------------------- Airfoil files ----------------
% --------------------------------------------------- 
airfoil_root = fopen('airfoil_root.dat','w');

% [TODO]

fclose(airfoil_root);

airfoil_tip = fopen('airfoil_tip.dat','w');

% [TODO]

fclose(airfoil_tip);

% Then, run EMWET
EMWET 767

% Then, retrieve wing weight from the file and return as output

% [TODO]

end



