function [f, order, numMultiplies] = myParksMc(wp, ws, rp, rs, gainMaxPB, fs)
    [n,fo,ao,w] = firpmord([wp * fs / 2 ws * fs / 2], [1 0], [(10^(rp/2 * 20)-1)/(10^(rp/2 * 20)+1)  10^(-rs/20)], fs);
    order = n;
    numMultiplies = 2 * n + 1;
    b = firpm(n,fo,ao,w);
    h = dfilt.df1(b);
    
    f = cascade(dfilt.scalar(gainMaxPB), h);
end