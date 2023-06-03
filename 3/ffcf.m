function y = ffcf(x,g,N)
    y = zeros(size(x));
    for n = N+1:size(x,1)
        y(n) = g*x(n) + x(n-N);
    end
end