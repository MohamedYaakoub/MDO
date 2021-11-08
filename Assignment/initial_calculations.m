% Run structures once to calculate C_AW

import loads.*
import structures.*
import chord.*

global data;

x0 = [8.57, 0.207, 0.207, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 20000, 44559];
data.x0 = x0;

% Airfoil coeffs
Au_r = [0.2473    0.0841    0.2841    0.0935    0.2953    0.4031];
Al_r = [-0.2385   -0.1729   -0.0498   -0.5047   0.0777    0.3444];
Au_t = [0.1413    0.0482    0.1620    0.0539    0.1684    0.2305];
Al_t = [-0.1363   -0.0989   -0.0282   -0.2887   0.0446    0.1967];

% Calculate initial Cl and Cm distributions

% Initialise with random distribution, not used by loads
Cl = [0.5440    0.5630    0.5789    0.5930    0.6060    0.6180    0.6294    0.6403    0.6510    0.6614    0.6715    0.6808    0.6858    0.6623];
Cm = [-0.1170   -0.1187   -0.1195   -0.1200   -0.1203   -0.1206   -0.1208   -0.1210   -0.1211   -0.1212   -0.1213   -0.1213   -0.1211   -0.1197];

% Design vector
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

x0 = [8.57, 0.207, 0.207, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 20000, 44559];

% Run loads to obtain actual Cl and Cm distribution for original aircraft
[Cl, Cm] = loads(x0/x0);

% Update x0 with these distributions
x0 = [8.57, 0.207, 0.207, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 20000, 44559];


ww = structures(x0/x0);

disp(ww)

LD = aerodynamics(x0/x0);

disp(LD)
