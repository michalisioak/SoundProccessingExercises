function y = ap(x,g,N)
    y = zeros(size(x));
    for n = N+1:size(x,1)
        y(n) = g*x(n) - g*y(n-N) + x(n-N);
    end
end