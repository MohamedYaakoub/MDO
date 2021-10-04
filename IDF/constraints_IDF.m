function [c,ceq] = constraints_IDF(x)
%function computing constraints of the sellar problem
global couplings;
y1 = couplings.y1;
y2 = couplings.y2;

% y1_c = x(4);
% y2_c = x(5);

cc1 = abs(y1-x(4));
cc2 = abs(y2-x(5));

c1 = 3.16 - y1;
c2 = y2 - 24;
c = [c1,c2];
ceq = [cc1,cc2];
end