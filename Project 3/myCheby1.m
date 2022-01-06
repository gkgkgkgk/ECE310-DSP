function [f, order, numMultiplies] = myCheby1(wp, ws, rp, rs, gainMaxPB)
    [n, ~] = cheb1ord(wp, ws, rp, rs);
    order = n;
    numMultiplies = 2 * n + 1;
    [z, p, k] = cheby1(n, rp, wp);
    [sos, g] = zp2sos(z, p, k);
    h = dfilt.df2sos(sos, g);
    
    f = cascade(dfilt.scalar(gainMaxPB), h);
end