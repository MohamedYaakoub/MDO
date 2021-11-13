% Main file to run optimisation
import caller_fun.*
import constraints.*
import outfun.*
import plot_results.*
import wing_area.*

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
Cl = [1.458000 1.550000 1.640400 1.725100 1.803200 1.823100 1.844200 1.868100 1.888100 1.901200 1.902500 1.881800 1.807200 1.541000];
Cm = [-0.380600 -0.371700 -0.363200 -0.353700 -0.342900 -0.297600 -0.265800 -0.247300 -0.234900 -0.224400 -0.213000 -0.198300 -0.173600 -0.118700];

% Full vector
x0_init = [8.57, 0.455, 0.455, 35, 14.16, 2.5, 0.5, Au_r, Al_r, Au_t, Al_t, Cl, Cm, 16, 24247.7, 45025.516486];

% Design payload: 24795 kg

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

options = optimoptions(@fmincon);
options.Display = 'iter-detailed';
options.Algorithm = 'sqp';
options.DiffMaxChange = 0.01;
options.DiffMinChange = 0.0001;
options.TolCon = 1e-3;
options.TolFun = 1e-3;
options.StepTolerance = 1e-6;
% options.UseParallel = true;
options.OutputFcn = @outfun;

% Run optimisation

% Save initial calculated WS (reference) to use in constraint
[S, ~, ~] = wing_area(x0/x0);

data.WS_orig = data.MTOM_ref/S;

% NOTE: RUN constants.m BEFORE RUNNING MAIN TO INITIALISE VARIABLES
tic
[x, fmin] = fmincon(@caller_fun, x0, [], [], [], [], lb, ub, @constraints, options);
toc

% Denormalise final results
x = x .* x0_init;

% [UPDATE] Print results
fprintf('%f %f %f %f %f %f %f %f %f %f \n', x)

fprintf('MTOM %f \n', fmin * data.MTOM_ref)

% Plot results

plot_results(x);

