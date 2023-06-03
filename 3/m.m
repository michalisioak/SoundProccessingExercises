function y=m(x,kp,gp,kn,gn)
    y = zeros(size(x));
    
    tanh_kp = tanh(kp);
    tanh_kn = tanh(kn);
    tanh_kp_sq_minus_1 = tanh_kp^2 - 1;
    tanh_kn_sq_minus_1 = tanh_kn^2 - 1;

    idx_kp = x > kp;
    idx_kn = x < -kn;

    y(idx_kp) = tanh_kp - (tanh_kp_sq_minus_1 / gp) * tanh(gp * x(idx_kp) - kp);
    y(idx_kn) = -tanh_kn - (tanh_kn_sq_minus_1 / gn) * tanh(gn * x(idx_kn) + kn);
    y(~(idx_kp | idx_kn)) = tanh(x(~(idx_kp | idx_kn)));
end