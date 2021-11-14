% Main file to run optimisation
import caller_fun.*
import constraints.*
import outfun.*
import plot_results.*
import wing_area.*
import constraint_plotter.*

global data;

% Reinitialise plotting arrays from constraints before running iteration
data.c_fuel_plot = [];
data.c_WS_plot = [];
data.ceq_cl_plot = [];
data.ceq_cm_plot = [];
data.ceq_LD_plot = [];
data.ceq_Ww_plot = [];
data.ceq_Wf_plot = [];


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
Cl = [1.332800 1.431800 1.540000 1.654600 1.774700 1.835900 1.888400 1.938900 1.983600 2.020400 2.045600 2.048800 1.994900 1.7253];
Cm = [-0.375100 -0.368400 -0.361300 -0.352600 -0.341700 -0.294400 -0.263100 -0.244900 -0.232700 -0.222300 -0.211000 -0.195900 -0.169700 -0.109];

% Full vector
x0_init = [8.57, 0.55, 0.37636363, 35, 14.16, 2, 1, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 25757.3, 45026.748368];

% Design payload: 24795 kg

% Save initial design vector to denormalise it in the disciplines,
% functions, etc.
data.x0 = abs(x0_init);

% Normalise design vector
x0 = x0_init./abs(x0_init);

%  ---------- Upper and lower bounds ----------
Au_r_ub = Au_r * 1.2;

Al_r_ub = Al_r;
Al_r_ub(sign(Al_r) == 1) = Al_r_ub(sign(Al_r) == 1) * 1.2;
Al_r_ub(sign(Al_r) == -1) = Al_r_ub(sign(Al_r) == -1) * 0.8;

Au_t_ub = Au_t * 1.2;
% Al_t_ub = Al_t / 2;

Al_t_ub = Al_t;
Al_t_ub(sign(Al_t) == 1) = Al_t_ub(sign(Al_t) == 1) * 1.2;
Al_t_ub(sign(Al_t) == -1) = Al_t_ub(sign(Al_t) == -1) * 0.8;

% Lower
Au_r_lb = Au_r * 0.8;
% Al_r_lb = Al_r * 2;
Al_r_lb = Al_r;
Al_r_lb(sign(Al_r) == 1) = Al_r_lb(sign(Al_r) == 1) * 0.8;
Al_r_lb(sign(Al_r) == -1) = Al_r_lb(sign(Al_r) == -1) * 1.2;

Au_t_lb = Au_t * 0.8;
% Al_t_lb = Al_t * 2;

Al_t_lb = Al_t;
Al_t_lb(sign(Al_t) == 1) = Al_t_lb(sign(Al_t) == 1) * 0.8;
Al_t_lb(sign(Al_t) == -1) = Al_t_lb(sign(Al_t) == -1) * 1.2;

% Airfoil coefficients
Cl_ub = ones(size(Cl)) * 6;
Cm_ub = ones(size(Cm)) * 6;
% ub = [26.5, 1, 1, 50, 17.87, 8.15, 8.15, Au_r_ub, Al_r_ub, Au_t_ub, Al_t_ub, Cl_ub, Cm_ub, 40, 156489, 156489];
ub = [26.5, 1, 1, 50, 17.87, 4, 4, Au_r_ub, Al_r_ub, Au_t_ub, Al_t_ub, Cl_ub, Cm_ub, 40, 156489, 156489];

Cl_lb = ones(size(Cl)) * -6;
Cm_lb = ones(size(Cm)) * -6;
% lb = [2, 0.05, 0.05, 0.5, 1, -10, -10, Au_r_lb, Al_r_lb, Au_t_lb, Al_t_lb, Cl_lb, Cm_lb, 5, 4358, 1000];
lb = [3, 0.1, 0.1, 1, 1, -5, -5, Au_r_lb, Al_r_lb, Au_t_lb, Al_t_lb, Cl_lb, Cm_lb, 5, 4358, 1000];

% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],[Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel]


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

% options = optimoptions(@fmincon);
% options.Display = 'iter-detailed';
% options.Algorithm = 'sqp';
% options.DiffMaxChange = 0.01;
% options.DiffMinChange = 0.0001;
% options.TolCon = 1e-3;
% options.TolFun = 1e-3;
% options.StepTolerance = 1e-6;
% % options.UseParallel = true;
% options.OutputFcn = @outfun;

options = optimoptions(@fmincon);
options.Display = 'iter-detailed';
options.Algorithm = 'sqp';
options.DiffMaxChange = 1;
options.DiffMinChange = 0.05;
options.TolCon = 1e-3;
options.TolFun = 1e-3;
options.StepTolerance = 1e-12;
% options.UseParallel = true;
% options.OutputFcn = @outfun;
options.FinDiffType = 'central';
options.PlotFcns = {@optimplotfval, @optimplotx, @optimplotfirstorderopt, @optimplotconstrviolation, @optimplotfunccount, @optimplotstepsize};

% Run optimisation

% Save initial calculated WS (reference) to use in constraint
[S, ~, ~] = wing_area(x0);

data.WS_orig = data.MTOM_ref/S;

% NOTE: RUN constants.m BEFORE RUNNING MAIN TO INITIALISE VARIABLES
tic
[x, fmin] = fmincon(@caller_fun, x0, [], [], [], [], lb, ub, @constraints, options);
toc

% Denormalise final results
x = x .* abs(x0_init);

% [UPDATE] Print results on screen ------------------------------------

% Design variables - Wing geometry
line = [x(1), x(2), x(3), x(4), x(5), x(6), x(7)];
fprintf('C_root: %f Taper_1: %f Taper_2: %f Sweep_LE_2: %f b2: %f Twist_mid: %f Twist_tip: %f \n', line)

% Design variables - Airfoil coefficients
line = [x(8), x(9), x(10), x(11), x(12), x(13)];
fprintf('Au_r: %f %f %f %f %f %f \n', line)
line = [x(14), x(15), x(16), x(17), x(18), x(19)];
fprintf('Al_r: %f %f %f %f %f %f \n', line)
line = [x(20), x(21), x(22), x(23), x(24), x(25)];
fprintf('Au_t: %f %f %f %f %f %f \n', line)
line = [x(26), x(27), x(28), x(29), x(30), x(31)];
fprintf('Al_t: %f %f %f %f %f %f \n', line)

% Copy variables
line = x(32:45);
fprintf('Cl_hat: %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', line)
line = x(46:59);
fprintf('Cm_hat: %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', line)
line = [x(60), x(61), x(62)];
fprintf('LD_ratio: %f W_wing_hat: %f W_fuel_hat: %f \n', line)


% Objective function
fprintf('MTOM: %f Normalised objective function: \n', [fmin * data.MTOM_ref, fmin])

% [UPDATE] Print results on file ------------------------------------

res_file = fopen('results_optimisation.dat','w');

% Design variables - Wing geometry
line = [x(1), x(2), x(3), x(4), x(5), x(6), x(7)];
fprintf(res_file, 'C_root: %f Taper_1: %f Taper_2: %f Sweep_LE_2: %f b2: %f Twist_mid: %f Twist_tip: %f \n', line);

% Design variables - Airfoil coefficients
line = [x(8), x(9), x(10), x(11), x(12), x(13)];
fprintf(res_file, 'Au_r: %f %f %f %f %f %f \n', line);
line = [x(14), x(15), x(16), x(17), x(18), x(19)];
fprintf(res_file, 'Al_r: %f %f %f %f %f %f \n', line);
line = [x(20), x(21), x(22), x(23), x(24), x(25)];
fprintf(res_file, 'Au_t: %f %f %f %f %f %f \n', line);
line = [x(26), x(27), x(28), x(29), x(30), x(31)];
fprintf(res_file, 'Al_t: %f %f %f %f %f %f \n', line);

% Copy variables
line = x(32:45);
fprintf(res_file, 'Cl_hat: %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', line);
line = x(46:59);
fprintf(res_file, 'Cm_hat: %f %f %f %f %f %f %f %f %f %f %f %f %f %f \n', line);
line = [x(60), x(61), x(62)];
fprintf(res_file, 'LD_ratio: %f W_wing_hat: %f W_fuel_hat: %f \n', line);


% Objective function
fprintf(res_file, 'MTOM: %f Normalised objective function: %f \n', [fmin * data.MTOM_ref, fmin]);

fclose(res_file);

% Plot results -------------------------------------
plot_results(x);


% Plot constraints -------------------------------------
constraint_plotter();

