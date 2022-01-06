function [f, order, numMultiplies] = myButter(wp, ws, rp, rs, gainMaxPB)
    [n, Wn] = buttord(wp, ws, rp, rs); % determine order and cutoff frequencies
    order = n;
    numMultiplies = 2 * n + 1;
    [z, p, k] = butter(n, Wn); % create butterworth filter
    [sos, g] = zp2sos(z, p, k); % convert to second order sections
    h = dfilt.df2sos(sos, g); % convert it to direct form II
    
    f = cascade(dfilt.scalar(gainMaxPB), h); % cascade the second order sections
end