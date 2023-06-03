function y = reverb_schroeder (x, type, mix)
    switch type
        case 1
            remix = fbcf(x,0.805,901)+fbcf(x,0.827,778)+fbcf(x,0.783,1011)+fbcf(x,0.764,1123);
            y = ap(ap(ap(x,0.7,125),0.7,42),0.7,12);
        case 2
            remix = ap(ap(ap(x,0.7,1051),0.7,337),0.7,113);
            y = fbcf(remix,0.742,4799)+fbcf(remix,0.733,4999)+fbcf(remix,0.715,5399)+fbcf(remix,0.697,5801);
        otherwise
            disp("Invalid type")
    end
    y = x * (1-mix) + y * mix;
end