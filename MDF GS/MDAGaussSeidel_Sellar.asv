function [y1,y2,counter, y2_c] = MDAGaussSeidel_Sellar(x1,z1,z2,y2_c,error)
%MDA coordinator (convergence loop) for the Sellar problem
%returns the values for y1 and y2 computed by the disciplinary analyses
%additionally returns the value of the counter and the value of the copy of
%y2
%once the convergence is within the specified tolerance (optional)

%Convergence loop

if nargin < 5
    error = 1e-6;
end

%for initiation of loop condition:
y2 = 1e9;
counter = 0;

while abs(y2-y2_c)/y2 > error
    %loop counter
    if (counter > 0)
        y2_c = y2;
    end
    y1 = Sellar_disc1(x1,z1,z2,y2_c);
    y2 = Sellar_disc2(z1,z2,y1);
    counter = counter +1;    
end



end

