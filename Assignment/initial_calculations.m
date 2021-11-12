% Run structures once to calculate C_AW

import loads.*
import structures.*
import chord.*
import plot_results.*
import wing_area.*

global data;

Cl = [0.690900 0.719400 0.739100 0.747300 0.740300 0.710300 0.705700 0.700200 0.689900 0.672900 0.646800 0.607700 0.547500 0.443000];
Cm = [-0.336300 -0.339500 -0.338300 -0.331700 -0.317900 -0.278400 -0.255300 -0.241000 -0.230700 -0.221600 -0.211800 -0.200200 -0.184900 -0.161000];

x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 9102.43, 44559];
data.x0 = x0;

x1 = [8.57, 1, 1, 0, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 9102.43, 44559];
plot_results(x1 * 0.95);

% Airfoil coeffs
Au_r = [0.2473    0.0841    0.2841    0.0935    0.2953    0.4031];
Al_r = [-0.2385   -0.1729   -0.0498   -0.5047   0.0777    0.3444];
Au_t = [0.1413    0.0482    0.1620    0.0539    0.1684    0.2305];
Al_t = [-0.1363   -0.0989   -0.0282   -0.2887   0.0446    0.1967];

% Calculate initial Cl and Cm distributions

% Initialise with random distribution, not used by loads
Cl = [0.690900 0.719400 0.739100 0.747300 0.740300 0.710300 0.705700 0.700200 0.689900 0.672900 0.646800 0.607700 0.547500 0.443000];
Cm = [-0.336300 -0.339500 -0.338300 -0.331700 -0.317900 -0.278400 -0.255300 -0.241000 -0.230700 -0.221600 -0.211800 -0.200200 -0.184900 -0.161000];

% Design vector
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 9102.43, 44559];

% Run loads to obtain actual Cl and Cm distribution for original aircraft
tic
[Cl, Cm] = loads(x0/x0);
toc

% Update x0 with these distributions
x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 9102.43, 44559];

tic
ww = structures(x0/x0);
toc

fprintf('Wing weight %f \n', ww)

tic
LD = aerodynamics(x0/x0);
toc

fprintf('LD ratio %f \n', LD)

[S, ~, ~] = wing_area(x0/x0);

fprintf('Area %f \n', S)

% fprintf('Tip chord %f \n', x0(1)*x0(2)*x0(3))

% chords = chord(data.b1 + 14.16, x0);
% 
% fprintf('Chord %f \n', chords)
