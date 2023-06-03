function [y_l,y_r]=rotary(x, M1, M2, depth1, depth2, f1, f2, fs)   
    % y_l = zeros(size(x));
    % y_r = zeros(size(x));
    % for n = M1:size(x,1)
    %     t1 = round(sin(2*pi*f1*n/fs));
    %     t2 = round(sin(2*pi*f2*n/fs));
    %     y_l(n) = x(round(M1+depth1*t1)) * (1-t1) + 0.7 * x(round(M2+depth2*t2)) * (1-t2);
    %     y_r(n) = x(round(M2+depth2*t2)) * (1-t2) + 0.7 * x(round(M1+depth1*t1)) * (1-t1);
    % end


    y = zeros(size(x));
    for n = M1+depth1:size(x,1)
        sin0 = n/fs;
        sin1 = sin(2*pi*f1*sin0);
        sin2 = sin(2*pi*f2*sin0);
        y_l(n) = x(round(M1+depth1*sin1)) * (1-sin1) + 0.7 * x(round(M2+depth2+sin2)) * (1-sin2);
        y_r(n) = x(round(M2+depth2*sin2)) * (1-sin2) + 0.7 * x(round(M1+depth1+sin1)) * (1-sin1);
    end
    
end

