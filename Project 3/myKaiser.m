function [f, order, numMultiplies] = myKaiser(wp, ws, rp, rs, gainMaxPB, fs)
    [n, ~,~,~] = kaiserord([wp * fs / 2 ws * fs / 2], [1 0], [(10^(rp/2 * 20)-1)/(10^(rp/2 * 20)+1)  10^(-rs/20)], fs);
    order = n;
    numMultiplies = 2 * n + 1;
    f = designfilt('lowpassfir','PassbandFrequency',wp, ...
         'StopbandFrequency',ws,'PassbandRipple',rp, ...
         'StopbandAttenuation',rs,'DesignMethod','kaiserwin');
end