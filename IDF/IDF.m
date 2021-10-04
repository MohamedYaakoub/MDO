%Matlab IDF implementation of the Sellar problem (Sellar et
%al. 1996)

%Initial values:
x1 = 1;
z1 = 5;
z2 = 2;
y1_c = 3.16;
y2_c = 0;

%bounds
lb = [0,-10,0,-100,-100];
ub = [10,10,10,100,100];

x0 = [x1,z1,z2,y1_c,y2_c];


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
[x,FVAL,EXITFLAG,OUTPUT] = fmincon(@(x) Optim_IDF(x),x0,[],[],[],[],lb,ub,@(x) constraints_IDF(x),options);
toc;
x
FVAL

%optionally, call the objective again with the optimum values for x
%[f,vararg] = Optim_IDF(x);
