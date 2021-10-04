function [f] = Optim_IDF(x)
    x1 = x(1);
    z1 = x(2);
    z2 = x(3);
    %Initial guess for output of discipline 2
    y1_c = x(4);
    y2_c = x(5);
        
    y1 = Sellar_disc1(x1,z1,z2,y2_c);
    y2 = Sellar_disc2(z1,z2,y1_c);

    f = objective(x1,z2,y1,y2);
    
      
    global couplings;
    
%     vararg = {y1,y2,y2_c,y1_c};
    couplings.y1 = y1;
    couplings.y2 = y2;
    
end