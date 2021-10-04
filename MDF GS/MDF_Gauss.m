%Matlab MDF Gauss Seidel implementation of the Sellar problem (Sellar et
%al. 1996)

%Initial values:
x1 = 1;
z1 = 5;
z2 = 2;

%bounds
lb = [0,-10,0];
ub = [10,10,10];

x0 = [x1,z1,z2];
    
% Options for the optimization
options.Display         = 'iter-detailed';
options.Algorithm       = 'sqp';
options.FunValCheck     = 'off';
options.DiffMinChange   = 1e-6;         % Minimum change while gradient searching
options.DiffMaxChange   = 5e-2;         % Maximum change while gradient searching
options.TolCon          = 1e-6;         % Maximum difference between two subsequent constraint vectors [c and ceq]
options.TolFun          = 1e-6;         % Maximum difference between two subsequent objective value
options.TolX            = 1e-6;         % Maximum difference between two subsequent design vectors

options.MaxIter         = 30;           % Maximum iterations

tic;
[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x) Optim_MDFGauss(x),x0,[],[],[],[],lb,ub,@(x) constraints(x),options);
toc;
%[f,vararg] = Optim_MDFGauss(x);
