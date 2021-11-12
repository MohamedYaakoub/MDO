function stop=plot_results(des_vec)
stop = false;

global data;

% Extract required variables
C_r = des_vec(1);
C_mid = C_r * des_vec(2);
C_tip = C_mid * des_vec(3);

sweep_LE_2 = des_vec(4);
b2 = des_vec(5);

twist_mid = des_vec(6);
twist_tip = des_vec(7);

Au_r = des_vec(8:13);
Al_r = des_vec(14:19);
Au_t = des_vec(20:25);
Al_t = des_vec(26:31);

W_wing = des_vec(61);
W_fuel = des_vec(62);

W_TO_max = data.C_AW + W_wing + W_fuel;


% Wing planform geometry

% ----------------------------------------
% -------------- Optimised ---------------
% ----------------------------------------

x2 = C_r - C_mid;

x3 = x2 + b2 * tand(sweep_LE_2);
y3 = data.b1 + b2;
z3 = (data.b1 + b2)*tand(data.dihedral); % REVISE

% Plot wing planform
% Root
[xr_le, yr_le, zr_le] = deal(data.x1, data.y1, data.z1);
[xr_te, yr_te, zr_te] = deal(data.x1 + C_r, data.y1, data.z1);

% Mid
[xm_le, ym_le, zm_le] = deal(x2, data.y2, data.z2);
[xm_te, ym_te, zm_te] = deal(x2 + C_mid, data.y2, data.z2);
 
% Chord
[xt_le, yt_le, zt_le] = deal(x3, y3, z3);
[xt_te, yt_te, zt_te] = deal(x3 + C_tip, y3, z3);

% Plotting

% LE
plot([xr_le, xm_le], [yr_le, ym_le], 'k')
hold on
plot([xm_le, xt_le], [ym_le, yt_le], 'k')
hold on

% Tip
plot([xt_le, xt_te], [yt_le, yt_te], 'k')
hold on

% Root
plot([xr_le, xr_te], [yr_le, yr_te], 'k')
hold on

% TE
plot([xr_te, xm_te], [yr_te, ym_te], 'k')
hold on
plot([xm_te, xt_te], [ym_te, yt_te], 'k')
hold on

% ----------------------------------------
% --------------- Original ---------------
% ----------------------------------------

% Redefine vector (to use the same code as above)
des_vec2 = data.x0;

% Extract required variables
C_r = des_vec2(1);
C_mid = C_r * des_vec2(2);
C_tip = C_mid * des_vec2(3);

sweep_LE_2 = des_vec2(4);
b2 = des_vec2(5);

twist_mid = des_vec2(6);
twist_tip = des_vec2(7);

Au_r_orig = des_vec2(8:13);
Al_r_orig = des_vec2(14:19);
Au_t_orig = des_vec2(20:25);
Al_t_orig = des_vec2(26:31);

Cl = des_vec(32:45);
Cm = des_vec(46:59);

W_wing = des_vec2(61);
W_fuel = des_vec2(62);

W_TO_max = data.C_AW + W_wing + W_fuel;


% Wing planform geometry

x2 = C_r - C_mid;

x3 = x2 + b2 * tand(sweep_LE_2);
y3 = data.b1 + b2;
z3 = (data.b1 + b2)*tand(data.dihedral); % REVISE

% Plot wing planform
% Root
[xr_le, yr_le, zr_le] = deal(data.x1, data.y1, data.z1);
[xr_te, yr_te, zr_te] = deal(data.x1 + C_r, data.y1, data.z1);

% Mid
[xm_le, ym_le, zm_le] = deal(x2, data.y2, data.z2);
[xm_te, ym_te, zm_te] = deal(x2 + C_mid, data.y2, data.z2);
 
% Chord
[xt_le, yt_le, zt_le] = deal(x3, y3, z3);
[xt_te, yt_te, zt_te] = deal(x3 + C_tip, y3, z3);

% Plotting

% LE
plot([xr_le, xm_le], [yr_le, ym_le], 'r')
hold on
plot([xm_le, xt_le], [ym_le, yt_le], 'r')
hold on

% Tip
plot([xt_le, xt_te], [yt_le, yt_te], 'r')
hold on

% Root
plot([xr_le, xr_te], [yr_le, yr_te], 'r')
hold on

% TE
plot([xr_te, xm_te], [yr_te, ym_te], 'r')
hold on
plot([xm_te, xt_te], [ym_te, yt_te], 'r')
view([90 90])
hold off

% Airfoil geometry

% ----------------------------------------
% -------------- Optimised ---------------
% ----------------------------------------
% Plot optimised Bernstein representation of the airfoil
X_plot = linspace(0, 1, 100)'; 

[Xtu_r, Xtl_r, ~] = D_airfoil2(Au_r, Al_r, X_plot);
[Xtu_t, Xtl_t, ~] = D_airfoil2(Au_t, Al_t, X_plot);


% Root airfoil
figure
subplot(1, 2, 1);
plot(Xtu_r(:,1), Xtu_r(:,2),'k');    % Upper surface
hold on
plot(Xtl_r(:,1), Xtl_r(:,2),'k');    % Lower surface
hold on
axis([0,1,-0.5,0.5]);

% Tip airfoil
subplot(1, 2, 2);
plot(Xtu_t(:,1), Xtu_t(:,2),'k');    % Upper surface
hold on
plot(Xtl_t(:,1), Xtl_t(:,2),'k');    % Lower surface
hold on

axis([0,1,-0.5,0.5]);

% ----------------------------------------
% --------------- Original ---------------
% ----------------------------------------
[Xtu_r, Xtl_r, ~] = D_airfoil2(Au_r_orig, Al_r_orig, X_plot);
[Xtu_t, Xtl_t, ~] = D_airfoil2(Au_t_orig, Al_t_orig, X_plot);

% Root airfoil
subplot(1, 2, 1);
plot(Xtu_r(:,1), Xtu_r(:,2),'r');    % Upper surface
hold on
plot(Xtl_r(:,1), Xtl_r(:,2),'r');    % Lower surface
hold on

% Tip airfoil
subplot(1, 2, 2);
plot(Xtu_t(:,1), Xtu_t(:,2),'r');    % Upper surface
hold on
plot(Xtl_t(:,1), Xtl_t(:,2),'r');    % Lower surface

hold off

% Plot isometric view

% Plot loads
positions = linspace(0, 1, length(Cl));
chords = chord(positions * (data.b1 + b2), des_vec);

% Coefficients times chord
Ccl = chords.*Cl;
Ccm = chords.*Cm;

figure
% plot(positions, Ccl);
% hold on
% plot(positions, Ccm);
% hold on
plot(positions, Cl, 'k');
hold on
plot(positions, Cm, 'r');
hold off


end
