function y=nonlinear(x,Fs, gn, gp, mix)   
    gpre=20;
    gbias=1;
    gpost=1;
    gdry=0;
    gwet=1;
    fc= 5;
    kn=2;
    kp=2;

    after_pre = x *  gpre;
    y = after_pre - lpf(abs(after_pre) ,Fs,fc) * gbias;
    y = m(y,kp,gp,kn,gn);
    y *= gwet;
    y += after_pre * gdry;
    y *= gpost;

    y = x + y * mix;
end

