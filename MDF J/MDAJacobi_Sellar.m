function [y1,y2,counter, y2_c, y1_c] = MDAJacobi_Sellar(x1,z1,z2,y2_c,y1_c,error)
%MDA coordinator (convergence loop) for the Sellar problem
%returns the values for y1 and y2 computed by the disciplinary analyses
%additionally returns the value of the counter and the value of the copy of
%y2
%once the convergence is within the specified tolerance (optional)

%Convergence loop
if nargin < 6
    error = 1e-6;
end

%for initiation of loop condition:
y2 = 1e9;
y1 = 1e9;
counter = 0;

while abs(y2-y2_c)/y2 || abs(y1-y1_c)/y1 > error
    %loop counter
    if (counter > 0)
        y2_c = y2;
        y1_c = y1;
    end
    y1 = Sellar_disc1(x1,z1,z2,y2_c);
    y2 = Sellar_disc2(z1,z2,y1_c);
    counter = counter +1;    
end



end

