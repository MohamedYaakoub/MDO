function [f,vararg] = Optim_MDFJacobi(x)
    x1 = x(1);
    z1 = x(2);
    z2 = x(3);
    %Initial guess for output of discipline 2
    y2_i = 0;
    y1_i = 3.16;
    %call MDA coordinator
    [y1,y2,counter,y2_c,y1_c] = MDAJacobi_Sellar(x1,z1,z2,y2_i,y1_i);

    f = objective(x1,z2,y1,y2);
   

    global couplings;
    
    vararg = {y1,y2,counter,y2_c,y1_c};
    couplings.y1 = y1;
    couplings.y2 = y2;
    
end