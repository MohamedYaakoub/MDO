% Au_r = des_vec(8);
% Al_r = des_vec(9);
% Au_t = des_vec(10);
% Al_t = des_vec(11);
close all;
clc;
clear all;


Aupp_vect_1 = [0.2173, 0.3450, 0.2974, 0.2686, 0.2894];
Alow_vect_1 = [-0.1296, -0.2392, -0.1631, -0.0480, 0.0801];

front_spar = 0.15;
back_spar = 0.85;
C_r = 8.6; % all in meters
C_mid = 8.6 * 0.5;
C_t  = 8.6 * 0.5 * 0.4;
b_1 = 8;
b_2 = 13;
X_vect = linspace(0,1,99)';

[Xtu_1,Xtl_1,C_1,Thu_1,Thl_1,Cm_1] = D_airfoil2(Aupp_vect_1,Alow_vect_1,X_vect);
y_u_root = Xtu_1(:,2);        %all in actual y x
x_u_root = Xtu_1(:,1);
y_l_root = Xtl_1(:,2);
x_l_root = Xtl_1(:,1);


Aupp_vect = [0.5, 0.3, 0.2, 0.1, 0.2];
Alow_vect = [-0.5, -0.1, -0.4, -0.7, 0.8];


[Xtu,Xtl,C,Thu,Thl,Cm] = D_airfoil2(Aupp_vect,Alow_vect,X_vect);
y_u_tip = Xtu(:,2);
x_u_tip = Xtu(:,1);
y_l_tip = Xtl(:,2);
x_l_tip = Xtl(:,1);



% hold on
% plot(Xtu(:,1),Xtu(:,2),'b');    %plot upper surface coords
% plot(Xtl(:,1),Xtl(:,2),'b');    %plot lower surface coords
% % plot(X_vect,C,'r');                  %plot class function
% axis([0,1,-1.5,1.5]);

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
    for j = 1:length(y_l_vec(1,:))
        if (front_spar * chord_vec(i) < x_u_vec(i,j)) && (x_u_vec(i,j)< back_spar * chord_vec(i))
           volume_rect(j) = (y_u_vec(i,j) - y_l_vec(i,j) ) * chord_vec(i)/length(x_u_vec(i,:));
volume_airfoil(i) = sum(volume_rect) * (b_1 + b_2) / length(x_u_vec(:,1));

        end
    
    end
end
sum(volume_airfoil)
% Y_ = interp1(x,v,xq,'spline');

% 
% hold on
% plot(x_u_vec(5,:), y_u_vec(5,:),'b');    %plot upper surface coords
% plot(x_l_vec(5,:), y_l_vec(5,:),'b');    %plot lower surface coords
% axis([0,1,-1.5,1.5]);
