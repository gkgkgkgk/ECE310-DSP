function [f, order, numMultiplies] = myElliptic(wp, ws, rp, rs, gainMaxPB)
    [n, Wn] = ellipord(wp, ws, rp, rs);
    order = n;
    numMultiplies = 2 * n + 1;
    [z, p, k] = ellip(n, rp, rs, wp);
    [sos, g] = zp2sos(z, p, k);
    h = dfilt.df2sos(sos, g);
    
    f = cascade(dfilt.scalar(gainMaxPB), h);
end