function [V_tank] = tank_volume(des_vec)
% Calculate the tank volume

import chord.*

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel


% Extract required variables
C_r = des_vec(1);
C_mid = C_r * des_vec(2);
C_t = C_mid * des_vec(3);

b_2 = des_vec(5);

Au_r = des_vec(8:13);
Al_r = des_vec(14:19);
Au_t = des_vec(20:25);
Al_t = des_vec(26:31);


global data;

front_spar = data.x_spar_f;
back_spar = data.x_spar_r;

b_1 = data.b1;


X_vect = linspace(0,1,99)';

% Root airfoil
[Xtu_1, Xtl_1, ~] = D_airfoil2(Au_r, Al_r, X_vect);
y_u_root = Xtu_1(:,2);        %all in actual y x
x_u_root = Xtu_1(:,1);
y_l_root = Xtl_1(:,2);
x_l_root = Xtl_1(:,1);

% Tip airfoil
[Xtu, Xtl, ~] = D_airfoil2(Au_t, Al_t, X_vect);
y_u_tip = Xtu(:,2);
x_u_tip = Xtu(:,1);
y_l_tip = Xtl(:,2);
x_l_tip = Xtl(:,1);



resolution = 100;

b_1_nodes = round(b_1/(b_2 + b_1) * resolution);
b_2_nodes = resolution - round(b_1/(b_2 + b_1) * resolution);
chord_vec = [linspace(C_r, C_mid, b_1_nodes) linspace(C_mid, C_t, b_2_nodes)];


for i = 1:length(y_u_tip)
y_u_vec(:,i) = linspace(y_u_root(i), y_u_tip(i), resolution).* chord_vec;
x_u_vec(:,i) = linspace(x_u_root(i), x_u_tip(i), resolution).* chord_vec;

y_l_vec(:,i) = linspace(y_l_root(i), y_l_tip(i), resolution).* chord_vec;
x_l_vec(:,i) = linspace(x_l_root(i), x_l_tip(i), resolution).* chord_vec;

end


for i = 1:length(y_l_vec(1,:))
y_l_vec(i,:) = interp1(x_l_vec(i,:), y_l_vec(i,:), x_u_vec(i,:), 'spline');
x_l_vec(i,:) = x_u_vec(i,:);
end

for i = 1:length(y_l_vec(:, 1)) * 0.85
    for j = 1:length(y_l_vec(1,:)) - 1
        if (front_spar * chord_vec(i) < x_u_vec(i,j)) && (x_u_vec(i,j)< back_spar * chord_vec(i))
%       volume_rect(j) = (y_u_vec(i,j) - y_l_vec(i,j) ) * chord_vec(i)/length(x_u_vec(i,:));
        volume_rect(j) = (y_u_vec(i,j) - y_l_vec(i,j)) * (x_u_vec(i,j+1) - x_u_vec(i,j));


        end
    
    end
volume_airfoil(i) = sum(volume_rect) * (b_1 + b_2) / length(x_u_vec(:,1));
end

V_tank = sum(volume_airfoil);

end