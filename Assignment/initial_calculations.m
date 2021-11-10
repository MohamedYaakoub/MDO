% Run structures once to calculate C_AW

import loads.*
import structures.*
import chord.*
import plot_results.*

global data;

Cl = [0.742300 0.800000 0.854800 0.906000 0.953200 0.932700 0.907000 0.884600 0.859500 0.829200 0.790700 0.740000 0.668800 0.548300];
Cm = [-0.337500 -0.345700 -0.348800 -0.345900 -0.334500 -0.273000 -0.241600 -0.227500 -0.218500 -0.210300 -0.201300 -0.190400 -0.176300 -0.153700];

x0 = [8.57, 0.4, 0.4, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 9213.02, 44559];
data.x0 = x0;

% Airfoil coeffs
Au_r = [0.2473    0.0841    0.2841    0.0935    0.2953    0.4031];
Al_r = [-0.2385   -0.1729   -0.0498   -0.5047   0.0777    0.3444];
Au_t = [0.1413    0.0482    0.1620    0.0539    0.1684    0.2305];
Al_t = [-0.1363   -0.0989   -0.0282   -0.2887   0.0446    0.1967];

% Calculate initial Cl and Cm distributions

% Initialise with random distribution, not used by loads
Cl = [0.742300 0.800000 0.854800 0.906000 0.953200 0.932700 0.907000 0.884600 0.859500 0.829200 0.790700 0.740000 0.668800 0.548300];
Cm = [-0.337500 -0.345700 -0.348800 -0.345900 -0.334500 -0.273000 -0.241600 -0.227500 -0.218500 -0.210300 -0.201300 -0.190400 -0.176300 -0.153700];

% Design vector
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

x0 = [8.57, 0.4, 0.4, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 9213.02, 44559];

% Run loads to obtain actual Cl and Cm distribution for original aircraft
[Cl, Cm] = loads(x0/x0);

% Update x0 with these distributions
x0 = [8.57, 0.4, 0.4, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 9213.02, 44559];

ww = structures(x0/x0);

fprintf('Wing weight %f \n', ww)

LD = aerodynamics(x0/x0);

fprintf('LD ratio %f \n', LD)

% chords = chord(data.b1 + 14.16, x0);
% 
% fprintf('Chord %f \n', chords)
