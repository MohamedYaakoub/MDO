% Aerodynamics

function [LD_ratio] = aerodynamics(des_vec)
% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel

% Extract required variables
C_r = des_vec(1);
C_mid = C_r * des_vec(2);
C_tip = C_mid * des_vec(3);

sweep_LE_2 = des_vec(4);
b2 = des_vec(5);

twist_mid = des_vec(6);
twist_tip = des_vec(7);

global data;

% Wing planform geometry

x2 = C_r - C_mid;

x3 = x2 + b2 * tand(sweep_LE_2);
y3 = data.b1 + b2;
z3 = (data.b1 + b2)*tand(data.dihedral); % REVISE

%               x       y       z     chord(m)     twist angle (deg) 
AC.Wing.Geom = [0       0       0      C_r             0;      % Root
                x2  data.y2 data.z2    C_mid       twist_mid;  % Mid
                x3      y3      z3     C_tip       twist_tip]; % Tip

% Wing incidence angle (degree)
AC.Wing.inc  = data.i;   
            
            
% Airfoil coefficients input matrix
%                    | ->            upper curve coeff.                <-|  | ->               lower curve coeff.            <-| 
AC.Wing.Airfoils   = [Au_r(1)  Au_r(2)  Au_r(3)  Au_r(4)  Au_r(5)  Au_r(6)  Al_r(1)  Al_r(2)  Al_r(3)  Al_r(4)  Al_r(5)  Al_r(6);
                      Au_t(1)  Au_t(2)  Au_t(3)  Au_t(4)  Au_t(5)  Au_t(6)  Al_t(1)  Al_t(2)  Al_t(3)  Al_t(4)  Al_t(5)  Al_t(6)];
                  

AC.Wing.eta = [0;1];  % Spanwise location of the airfoil sections

% Viscous vs inviscid
AC.Visc  = 1;                  % Aerodynamics: viscous analysis
AC.Aero.MaxIterIndex = 150;    % Maximum number of Iteration for the
                               % convergence of viscous calculation
                                
                                
% [UPDATE] Flight Condition
AC.Aero.V     = data.V_cr;          % flight speed (m/s)
AC.Aero.rho   = data.density_cr;    % air density  (kg/m3)
AC.Aero.alt   = data.h_cr;          % flight altitude (m)
% Calculate MAC and Re based on that
AC.Aero.Re    = 1.14e7;             % reynolds number (based on mean aerodynamic chord)
AC.Aero.M     = 0.2;                % flight Mach number 
% AC.Aero.CL    = 0.4;                % lift coefficient - comment this line to run the code for given alpha%
AC.Aero.Alpha = 2;                  % angle of attack -  comment this line to run the code for given cl 

% Q3D solver
Res = Q3D_solver(AC);

% For Aerodynamics, we want L/D ratio as an output
LD_ratio = Res.CLwing/Res.CDwing;

end