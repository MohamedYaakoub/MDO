function [y2] = Sellar_disc2(z1,z2,y1)
%matlab function for disciplinary analysis 1 of the Sellar problem (Sellar
%et al. 1996)
%shared design variables: z1, z2
%coupling/response variable computed by discipline 1: y1

y2 = z1 + z2 +sqrt(y1);

end
