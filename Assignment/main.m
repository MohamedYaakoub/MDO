% Main file to run optimisation
import caller_fun.*
import constraints.*

global data;

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]

% ---------- Initial guess ----------

% Airfoil coeffs - Root: whitcomb t/c 14 & Tip: whitcomb t/c 08
Au_r = [0.2473    0.0841    0.2841    0.0935    0.2953    0.4031];
Al_r = [-0.2385   -0.1729   -0.0498   -0.5047    0.0777    0.3444];
Au_t = [0.1413    0.0482    0.1620    0.0539    0.1684    0.2305];
Al_t = [-0.1363   -0.0989   -0.0282   -0.2887    0.0446    0.1967];


% [Update] Cl and Cm distributions
Cl = [0.5440    0.5630    0.5789    0.5930    0.6060    0.6180    0.6294    0.6403    0.6510    0.6614    0.6715    0.6808    0.6858    0.6623];
Cm = [-0.1170   -0.1187   -0.1195   -0.1200   -0.1203   -0.1206   -0.1208   -0.1210   -0.1211   -0.1212   -0.1213   -0.1213   -0.1211   -0.1197];

% Full vector
x0_init = [8.57, 0.4, 0.4, 15, 14, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 20000, 50825.664];

% Save initial design vector to denormalise it in the disciplines,
% functions, etc.
data.x0 = abs(x0_init);

% Normalise design vector
x0 = x0_init./abs(x0_init);

%  ---------- Upper and lower bounds ----------
Au_r_ub = Au_r * 2;

Al_r_ub = Al_r;
Al_r_ub(sign(Al_r) == 1) = Al_r_ub(sign(Al_r) == 1) * 2;
Al_r_ub(sign(Al_r) == -1) = Al_r_ub(sign(Al_r) == -1) / 2;

Au_t_ub = Au_t * 2;
% Al_t_ub = Al_t / 2;

Al_t_ub = Al_t;
Al_t_ub(sign(Al_t) == 1) = Al_t_ub(sign(Al_t) == 1) * 2;
Al_t_ub(sign(Al_t) == -1) = Al_t_ub(sign(Al_t) == -1) / 2;

% Lower
Au_r_lb = Au_r / 2;
% Al_r_lb = Al_r * 2;
Al_r_lb = Al_r;
Al_r_lb(sign(Al_r) == 1) = Al_r_lb(sign(Al_r) == 1) / 2;
Al_r_lb(sign(Al_r) == -1) = Al_r_lb(sign(Al_r) == -1) * 2;

Au_t_lb = Au_t / 2;
% Al_t_lb = Al_t * 2;

Al_t_lb = Al_t;
Al_t_lb(sign(Al_t) == 1) = Al_t_lb(sign(Al_t) == 1) / 2;
Al_t_lb(sign(Al_t) == -1) = Al_t_lb(sign(Al_t) == -1) * 2;

% Airfoil coefficients
Cl_ub = ones(size(Cl)) * 6;
Cm_ub = ones(size(Cm)) * 6;
ub = [26.5, 1, 1, 50, 17.87, 8.15, 8.15, Au_r_ub, Al_r_ub, Au_t_ub, Al_t_ub, Cl_ub, Cm_ub, 40, 1535157/9.80665, 1535157/9.80665];

Cl_lb = ones(size(Cl)) * -6;
Cm_lb = ones(size(Cm)) * -6;
lb = [2, 0.05, 0.05, 0, 0, -10, -10, Au_r_lb, Al_r_lb, Au_t_lb, Al_t_lb, Cl_lb, Cm_lb, 5, 42739/9.80665, 10000/9.80665];

% Normalise bounds
ub = ub./abs(x0_init);
lb = lb./abs(x0_init);

% Print for debugging
% disp(lb)
% for i = 1:length(x0)
% %    print = ['lb ', , ', x ', x0(i), ', ub ', ub(i)];
%    disp(i)
%    disp(ub(i))
%    disp(x0(i))
%    disp(lb(i))
%    disp('\n')
% %    disp(x0(i))
% end

% [UPDATE] Run optimisation with SQP algorithm
% options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

options.Display = 'iter-detailed';
options.Algorithm = 'sqp';
options.DiffMaxChange = 0.01;
options.DiffMinChange = 0.001;
options.TolCon = 1e-6;
options.TolFun = 1e-3;
options.TolX = 1e-6;
% options.UseParallel = true;

% Run optimisation

% NOTE: RUN constants.m BEFORE RUNNING MAIN TO INITIALISE VARIABLES
tic
[x, fmin] = fmincon(@caller_fun, x0, [], [], [], [], lb, ub, @constraints, options);
toc

% Denormalise final results
x = x .* x0_init;

% [UPDATE] Print results
disp(x)

disp(fmin)
