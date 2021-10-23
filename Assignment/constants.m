% Global data
% File with fixed inputs/data for the assignment

global data;

% Outer wing geometry
data.i = 4.15;        % Incidence angle [deg]
data.dihedral = 6;    % Dihedral angle [deg]
data.b1 = 8.13;       % Inner wing span (fus centreline to mid sec) [m]
data.sweep_TE_1 = 0;  % Trailing edge sweep of inboard section [deg]

% Wing structure
data.x_spar_f = 0.15;   % PLACEGHOLDER x/c of the front spar
data.x_spar_r = 0.85;   % PLACEGHOLDER x/c of the rear spar
data.max_b_tank = 0.85; % Maximum 85\% of the half span up to which the tank gets [-]

% Coordinates of wing sections (1 -> Root, 2 -> Mid, 3 -> Tip)
[x1, y1, z1] = deal(0, 0, 0);                % [m]
[y2, z2] = deal(8.13, 8.13*tand(6));  % [m] 

% Aircraft performance
data.V_cr = 236.644;    % Cruise speed (taken as long range) [m/s] (460 kt)
% [ADD] data.V_mo = ;           % Maximum operative speed [m/s]
% [ADD] data.M_cr = ;       % Cruise Mach number [-]
% [ADD] data.M_mo = ;       % Maximum operative Mach number [-]
data.h_cr = 11887.2;    % Cruise height [m] (39000 ft)
data.range = 7445040;   % Design range [m] (4020 nm) (check max payload)
data.WS_orig = 552.38;  % Original max wing loading [kg/m^2]

% Air at cruise height
data.density_cr = 0.316406;         % Air density at cruise height [kg/m^3]
data.dyn_visc_cr = 0.0000143226;    % Air dynamic viscosity at cruise height [Pa*s]
% Structures
data.rib_pitch = 0.5;          % Rib pitch [m]
data.n_max = 2.5;              % Maximum positive limit load factor
data.E_al = 70e9;              % Aluminium Young's modulus [Pa]
data.yield_stress_al = 295e6;  % Aliminiun tension/compression yield stress [Pa]
data.density_al = 2800;        % Density of aliminium [kg/m^3]
data.stiff_eff_fac = 0.96;     % Stiffened panel efficiency factor [-] (top hat)

% Performance
% [ADD] data.WeWs = 1;  % W_end,cr / W_start,cr [-]

% Other
data.f_tank = 0.93;             % Tank volume factor [-]
data.density_fuel = 0.81715e3;  % Fuel density [kg/m^3]
%data.C_AW = 1;                  % Aircraft less wing mass [kg]