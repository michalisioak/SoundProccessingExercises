function y = fbcf(x,g,N)
    y = zeros(size(x));
    for n = N+1:size(x,1)
        y(n) = x(n) - g*y(n-N);
    end
end