% Loads

function [Cl, Cm] = loads(des_vec)

import MAC.*
import wing_area.*

[MAC_tot, ~, ~] = MAC(des_vec);
[S, ~, ~] = wing_area(des_vec);

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel

global data;

des_vec = des_vec .* data.x0;

% Extract required variables
C_r = des_vec(1);
C_mid = C_r * des_vec(2);
C_tip = C_mid * des_vec(3);

sweep_LE_2 = des_vec(4);
b2 = des_vec(5);

twist_mid = des_vec(6);
twist_tip = des_vec(7);

Au_r = des_vec(8:13);
Al_r = des_vec(14:19);
Au_t = des_vec(20:25);
Al_t = des_vec(26:31);

W_wing = des_vec(61);
W_fuel = des_vec(62);

W_TO_max = data.C_AW + W_wing + W_fuel;


% Wing planform geometry

x2 = C_r - C_mid;

x3 = x2 + b2 * tand(sweep_LE_2);
y3 = data.b1 + b2;
z3 = (data.b1 + b2)*tand(data.dihedral); % REVISE

%               x       y       z     chord(m)     twist angle (deg) 
AC.Wing.Geom = [0       0       0      C_r             data.i;      % Root
                x2+0.0813  data.y2 data.z2    C_mid       twist_mid;  % Mid
                x3      y3      z3     C_tip       twist_tip]; % Tip

% Wing incidence angle (degree)
AC.Wing.inc  = data.i;   
            
            
% Airfoil coefficients input matrix
%                    | ->            upper curve coeff.                <-|  | ->               lower curve coeff.            <-| 
AC.Wing.Airfoils   = [Au_r(1)  Au_r(2)  Au_r(3)  Au_r(4)  Au_r(5)  Au_r(6)  Al_r(1)  Al_r(2)  Al_r(3)  Al_r(4)  Al_r(5)  Al_r(6);
                      Au_t(1)  Au_t(2)  Au_t(3)  Au_t(4)  Au_t(5)  Au_t(6)  Al_t(1)  Al_t(2)  Al_t(3)  Al_t(4)  Al_t(5)  Al_t(6)];
                  
           
AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 0;                  % Loads: Inviscid
AC.Aero.MaxIterIndex = 150;    % Maximum number of Iteration for the
                               % convergence of viscous calculation
                                
                                
% [UPDATE] Flight Condition
% AC.Aero.V     = data.V_mo * sqrt(data.n_max);          % flight speed (m/s)
AC.Aero.V     = data.V_mo;          % flight speed (m/s)
AC.Aero.rho   = data.density_cr;    % air density  (kg/m3)
AC.Aero.alt   = data.h_cr;          % flight altitude (m)
Re = data.density_cr * MAC_tot * data.V_mo / data.dyn_visc_cr;
AC.Aero.Re    = Re;                 % reynolds number (based on mean aerodynamic chord)
AC.Aero.M     = data.M_mo;          % flight Mach number 
% AC.Aero.CL    = 0.4;              % lift coefficient - comment this line to run the code for given alpha%

% [CHECK IMPLEMENTATION OF n_max]
AC.Aero.CL = data.n_max * 2 * (W_TO_max*9.80665) / (data.density_cr * data.V_mo^2 * S);
% AC.Aero.CL = 2 * (W_TO_max*9.80665) / (data.density_cr * data.V_mo^2 * S);

% AC.Aero.Alpha = 2;                  % angle of attack -  comment this line to run the code for given cl 

% Q3D solver
Res = Q3D_solver(AC);

% For loads, we want Cl and Cm distributions
Cl = Res.Wing.cl';
Cm = Res.Wing.cm_c4';
Ccl = Res.Wing.ccl';
Ccm = Res.Wing.cm_c4' .* Res.Wing.chord';

positions = linspace(0, 1, length(Cl)) * (data.b1 + b2);
chords = chord(positions, des_vec);

% fprintf('Loads input CL %f \n', AC.Aero.CL)
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', Cl)
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', Ccl)
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', Cl .* chords)
% 
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', positions)
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', chords)
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', Res.Wing.chord')
% fprintf('%f %f %f \n', C_r, C_tip, data.b1 + b2)

% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', Cm)
% fprintf('%f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', Ccm)

end