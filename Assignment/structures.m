% Structures

function [W_wing] = structures(des_vec)
% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

import chord.*
import MAC.*
import wing_area.*
import D_airfoil2.*

global data;

% Extract relevant variables from vector:
C_r = des_vec(1);
C_mid = C_r * des_vec(2);
C_tip = C_mid * des_vec(3);

sweep_LE_2 = des_vec(4);
b2 = des_vec(5);

Au_r = des_vec(8:13);
Al_r = des_vec(14:19);
Au_t = des_vec(20:25);
Al_t = des_vec(26:31);

Cl = des_vec(32:45);
Cm = des_vec(46:59);

W_wing = des_vec(61);
W_fuel = des_vec(62);

% Wing planform geometry
x2 = C_r - C_mid;

x3 = x2 + b2 * tand(sweep_LE_2);
y3 = data.b1 + b2;
z3 = (data.b1 + b2)*tand(data.dihedral); % REVISE

% Area
[S, ~, ~] = wing_area(des_vec);


% First, create a script that takes the design vector as an
% input and writes the .init and airfoil coords file to read EMWET

% ---------------------------------------------------
% -------------------- Init file --------------------
% --------------------------------------------------- 
init = fopen('767.init','w');

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
line = [data.stiff_eff_fac, data.rib_pitch];
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
load = fopen('767.load','w');

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
fprintf(load, '%f %f %f \n', lines);

fclose(load);

% ---------------------------------------------------
% -------------------- Airfoil files ----------------
% --------------------------------------------------- 
X_vect = linspace(0,1,75)';

% Root airfoil
airfoil_root = fopen('airfoil_root.dat','w');

% Convert coefficients into coordinates
[Xtu, Xtl, ~] = D_airfoil2(Au_r, Al_r, X_vect);

% x and y arrays for upper and lower sides
x_u_root = Xtu(:,1);
y_u_root = Xtu(:,2);      
x_l_root = Xtl(:,1);
y_l_root = Xtl(:,2);

% Upper side
% Reverse airfoil (start from trailing edge)
x_u_root = flip(x_u_root);
y_u_root = flip(y_u_root);
for point = 1:length(x_u_root)
format_line = '%f %f \n';
fprintf(airfoil_root, format_line, x_u_root(point), y_u_root(point));
end

% Lower side (start from 2 to avoid repeating trailing edge twice)
for point = 2:length(x_l_root)
format_line = '%f %f \n';
fprintf(airfoil_root, format_line, x_l_root(point), y_l_root(point));
end

fclose(airfoil_root);

% Tip airfoil
airfoil_tip = fopen('airfoil_tip.dat','w');


% Convert coefficients into coordinates
[Xtu, Xtl, ~] = D_airfoil2(Au_t, Al_t, X_vect);

% x and y arrays for upper and lower sides
x_u_tip = Xtu(:,1);
y_u_tip = Xtu(:,2);      
x_l_tip = Xtl(:,1);
y_l_tip = Xtl(:,2);

% Upper side
% Reverse airfoil (start from trailing edge)
x_u_tip = flip(x_u_tip);
y_u_tip = flip(y_u_tip);
for point = 1:length(x_u_tip)
format_line = '%f %f \n';
fprintf(airfoil_tip, format_line, x_u_tip(point), y_u_tip(point));
end

% Lower side (start from 2 to avoid repeating trailing edge twice)
for point = 2:length(x_l_tip)
format_line = '%f %f \n';
fprintf(airfoil_tip, format_line, x_l_tip(point), y_l_tip(point));
end

fclose(airfoil_tip);

% Then, run EMWET
EMWET 767

% Lastly, retrieve wing weight from the file and return as output

% Open weight file
weight = fopen('767.weight', 'r');

% Read only first line (contains weight)
weight_line = fgetl(weight);

% Convert line into cell
% Format of line is: Wing total weight(kg) 4436.79
W_wing = textscan(weight_line,'%s%s%s%f');

% Weight is the last element in the cell, select and convert to number
W_wing = W_wing{end};

fclose(weight);

end



