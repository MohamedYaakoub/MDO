function f = objective(x1, z2, y1, y2)
%matlab function for objective of the Sellar problem (Sellar
%et al. 1996)
%shared design variables: z2
%local design variable: x1
%coupling/response variable computed by disciplines 1 & 2: y1,y2

f = x1^2 + z2 + y1 + exp(-1*y2);

end

