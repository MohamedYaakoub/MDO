function stop=constraint_plotter(~)
stop = false;

global data;

% Plot inequality constraints
iters = 1:size(data.c_fuel_plot, 2);

figure
plot(iters, data.c_fuel_plot,'DisplayName','V_t_a_n_k constraint');
hold on
plot(iters, data.c_WS_plot,'DisplayName','W/S constraint');
legend

title('Inequality constraints (V_t_a_n_k, W/S)')
xlabel('Iteration') 
ylabel('Constraint value') 

hold off

% Plot consistency constraints
% data.ceq_LD_plot(end+1) = ceq(29);
% data.ceq_Ww_plot(end+1) = ceq(30);
% data.ceq_Wf_plot(end+1) = ceq(31);

figure
plot(iters, data.ceq_LD_plot,'DisplayName','LD consistency constraint');
hold on
plot(iters, data.ceq_Ww_plot,'DisplayName','W_w_i_n_g consistency constraint');
hold on
plot(iters, data.ceq_Wf_plot,'DisplayName','W_f_u_e_l consistency constraint');

legend
title('Equality constraints (LD, W_w_i_n_g, W_f_u_e_l)')
xlabel('Iteration') 
ylabel('Constraint value') 

hold off

% Plot Cl and Cm in separate plots each, each entry as one plot
xs = 1:size(data.ceq_cl_plot, 1);

% Cl
figure
for i=1:14
    plot(xs, data.ceq_cl_plot(:, i), 'r')
    hold on
end
% legend
title('Equality constraints (C_l)')
xlabel('Iteration') 
ylabel('Constraint value') 

hold off

% Cm
figure
for i=1:14
    plot(xs, data.ceq_cm_plot(:, i), 'r')
    hold on
end
% legend
title('Equality constraints (C_m)')
xlabel('Iteration') 
ylabel('Constraint value') 
hold off

end