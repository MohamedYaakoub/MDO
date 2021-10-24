% Main file to run optimisation
import caller_fun.*
import constraints.*

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

% ---------- Initial guess ----------

% Airfoil coeffs [UPDATE FROM FITTING OF SCALED WHITCOMB]
Au_r = [1 1 1 1 1 1];
Al_r = [1 1 1 1 1 1];
Au_t = [1 1 1 1 1 1];
Al_t = [1 1 1 1 1 1];

% [ADD] Cl and Cm distributions
Cl = [];
Cm = [];

% Full vector
x0 = [8.57, 0.4, 0.4, 15, 14, 0, 0, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 11535157/3, 50825.664];

%  ---------- Upper and lower bounds ----------
Cl_ub = ones(size(Cl)) * 6;
Cm_ub = ones(size(Cm)) * 6;
ub = [26.5, 1, 1, 50, 17.87, 8.15, 8.15, [], [], [], [], Cl_ub, Cm_ub, 40, 1535157, 1535157];

Cl_lb = ones(size(Cl)) * -6;
Cm_lb = ones(size(Cm)) * -6;
lb = [2, 0.05, 0.05, 0, 0, -10, -10, [], [], [], [], Cl_lb, Cm_lb, 5, 42739, 10000];

% [UPDATE] Run optimisation with SQP algorithm
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

% Run optimisation
tic
[x, fmin] = fmincon(@caller_fun, x0, [], [], [], [], lb, ub, @constraints, options);
toc 

% [UPDATE] Print results
disp(x)

disp(fmin)
