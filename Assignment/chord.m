function [chord] = chord(ys, des_vec)
% Calculate the chord length at a given span position

global data;

% ---------- Design vector format ----------
% [Cr, taper1, taper2, sweep_LE_2, b2, twist_mid, twist_tip, [Au_r], [Al_r],
% [Au_t], [Al_t], [Cl], [Cm], LD_Ratio, W_wing, W_fuel


% DO NOT DENORMALISE IN THIS FUNCTION (pre-denormalised vector passed)
% des_vec = des_vec .* data.x0;

% Extract required variables
C_r = des_vec(1);
C_mid = C_r * des_vec(2);
C_tip = C_mid * des_vec(3);

b2 = des_vec(5);

chord = ones(size(ys));

for i=1:length(ys)

    y = ys(i);
    
    if y < data.b1
        chord(i) = y/data.b1 * (C_mid - C_r) + C_r;

    else
        chord(i) = (y - data.b1)/b2 * (C_tip - C_mid) + C_mid;

    end

end

end
