% Run structures once to calculate C_AW

import loads.*
import structures.*
import chord.*
import plot_results.*
import wing_area.*
import performance.*

global data;

Cl = [1.458000 1.550000 1.640400 1.725100 1.803200 1.823100 1.844200 1.868100 1.888100 1.901200 1.902500 1.881800 1.807200 1.541000];
Cm = [-0.380600 -0.371700 -0.363200 -0.353700 -0.342900 -0.297600 -0.265800 -0.247300 -0.234900 -0.224400 -0.213000 -0.198300 -0.173600 -0.118700];

x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2, 1, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 25757.200000, 45026.372978];
data.x0 = x0;

% plot_results(x0*1.1)

ww =  25757.3;
W_fuel = 45026.748368;

for i=1:10
    
tic
% Cl = [1.457100 1.549100 1.639400 1.724000 1.801900 1.821800 1.842900 1.866700 1.886700 1.899700 1.901000 1.880300 1.805700 1.539700];
% Cm = [-0.380500 -0.371700 -0.363200 -0.353700 -0.342900 -0.297600 -0.265800 -0.247300 -0.234900 -0.224400 -0.213100 -0.198300 -0.173700 -0.118800];
% 
% x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 24244, 44559];
% data.x0 = x0;

% x1 = [8.57, 1, 1, 0, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 24244, 44559];
% plot_results(x1 * 0.95);

% Airfoil coeffs
Au_r = [0.2473    0.0841    0.2841    0.0935    0.2953    0.4031];
Al_r = [-0.2385   -0.1729   -0.0498   -0.5047   0.0777    0.3444];
Au_t = [0.1413    0.0482    0.1620    0.0539    0.1684    0.2305];
Al_t = [-0.1363   -0.0989   -0.0282   -0.2887   0.0446    0.1967];

% Calculate initial Cl and Cm distributions

% Initialise with random distribution, not used by loads
% Cl = [1.457100 1.549100 1.639400 1.724000 1.801900 1.821800 1.842900 1.866700 1.886700 1.899700 1.901000 1.880300 1.805700 1.539700];
% Cm = [-0.380500 -0.371700 -0.363200 -0.353700 -0.342900 -0.297600 -0.265800 -0.247300 -0.234900 -0.224400 -0.213100 -0.198300 -0.173700 -0.118800];

% Design vector
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2, 1, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, ww, W_fuel];
data.x0 = x0;

% Run loads to obtain actual Cl and Cm distribution for original aircraft
% tic
[Cl, Cm] = loads(x0/x0);
% toc

% Update x0 with these distributions
x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2, 1, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, ww, W_fuel];

% tic
ww = structures(x0/x0);
% toc

x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2, 1, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, ww, W_fuel];
data.x0 = x0;

% fprintf('Wing weight %f \n', ww)

% tic
LD = aerodynamics(x0/x0);
% toc

% fprintf('LD ratio %f \n', LD)

[S, ~, ~] = wing_area(x0/x0);

% fprintf('Area %f \n', S)

% fprintf('Tip chord %f \n', x0(1)*x0(2)*x0(3))

% chords = chord(data.b1 + 14.16, x0);
% 
% fprintf('Chord %f \n', chords)

W_fuel = performance(x0/x0);

x0 = [8.57, 0.55, 0.37636363, 35, 14.16, 2, 1, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, ww, W_fuel];

data.x0 = x0;

% Update constants at initial point
data.C_AW = data.MTOM_ref - ww - W_fuel;

toc
end

fprintf('AW weight %f \n', data.C_AW)

fprintf('AW CD %f \n', data.CD_AW)

fprintf('Wing weight %f \n', ww)

fprintf('Fuel weight %f \n', W_fuel)

fprintf('LD ratio %f \n', LD)

fprintf('Area %f \n', S)
