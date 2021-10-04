function [c,ceq] = constraints(x)
%function computing constraints of the sellar problem
%NB constraints for MDF are directly computed from the values of the
%coupling variables. To pass those on, use a global variable. Otherwise,
%matlab will need to re-run the MDA and disciplinary analyses.
global couplings;
y1 = couplings.y1;
y2 = couplings.y2;

c1 = 3.16 - y1;
c2 = y2 - 24;
c = [c1,c2];
ceq = [];
end