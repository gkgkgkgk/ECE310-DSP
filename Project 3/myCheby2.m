function [f, order, numMultiplies] = myCheby2(wp, ws, rp, rs, gainMaxPB)
    [n, ~] = cheb2ord(wp, ws, rp, rs);
    order = n;
    numMultiplies = 2 * n + 1;
    [z, p, k] = cheby2(n, rs, ws);
    [sos, g] = zp2sos(z, p, k);
    h = dfilt.df2sos(sos, g);
    
    f = cascade(dfilt.scalar(gainMaxPB), h);
end