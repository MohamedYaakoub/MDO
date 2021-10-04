function [y1] = Sellar_disc1(x1,z1,z2,y2)
%matlab function for disciplinary analysis 1 of the Sellar problem (Sellar
%et al. 1996)
%shared design variables: z1, z2
%local design variable: x1
%coupling/response variable computed by discipline 2: y2

y1 = z1^2 + x1 + z2 -0.2*y2;

end

