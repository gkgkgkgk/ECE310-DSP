clear all; 
clc;
set(0, 'defaultFigureUnits', 'centimeters', 'defaultFigurePosition', [0 0 20 20]);

load projIB;

wp = 2500 * 2 / fs;
ws = 4000 * 2 / fs;

rp = 3;
rs = 95;
maxGainPB = 10^(40/20);

[fButt, orderButt, nmButt] = myButter(wp, ws, rp, rs, maxGainPB);
[fCheb1, orderCheb1, nmCheby1] = myCheby1(wp, ws, rp, rs, maxGainPB);
[fCheb2, orderCheb2, nmCheby2] = myCheby2(wp, ws, rp, rs, maxGainPB);
[fElliptic, orderElliptic, nmElliptic] = myElliptic(wp, ws, rp, rs, maxGainPB);
[fPM, orderPM, nmPM] = myParksMc(wp, ws, rp, rs, maxGainPB, fs);
[fKaiser, orderKaiser, nmKaiser] = myKaiser(wp, ws, rp, rs, maxGainPB, fs);

displayFilter(fButt, orderButt, nmButt, "Butterworth", 0, noisy, fs);
displayFilter(fCheb1, orderCheb1, nmCheby1, "Chebyshev I", 0, noisy, fs);
displayFilter(fCheb2, orderCheb2, nmCheby2, "Chebyshev II", 0, noisy, fs);
displayFilter(fElliptic, orderElliptic, nmElliptic, "Elliptic", 0, noisy, fs);
displayFilter(fPM, orderPM, nmPM, "Parks-McClellan", 0, noisy, fs);
displayFilter(fKaiser, orderKaiser, nmKaiser, "Kaiser", 0, noisy, fs);

function displayFilter(f, order, numMultiplies, t, playSound, noisy, fs)
    figure('Name', sprintf('%s: Order = %d, number of multiplications = %d', t, order, numMultiplies));
    subplot(6, 1, 1);
    
    [h, w] = freqz(f);
    plot(w, 20 * log10(abs(h)));
    xticks([0 pi/4 pi/2 3*pi/4 pi]);
    xticklabels({'0', '\pi/4', '\pi/2', '3\pi/4', '\pi'});
    xlabel('Frequency')
    ylabel('Magnitude (dB)')
    title(['Frequency Response of ', t])
    
    subplot(6, 1, 2);
    
    [h, w] = freqz(f);
    plot(w,(abs(h)));
    xticks([0 pi/4 pi/2 3*pi/4 pi]);
    xticklabels({'0', '\pi/4', '\pi/2', '3\pi/4', '\pi'});
    xlabel('Frequency')
    ylabel('Magnitude')
    title(['Frequency Response of ', t, ' (linear scale)'])
    
    subplot(6, 1, 3);
    
    [g, w] = grpdelay(f);
    plot(w, g);
    xticks([0 pi/4 pi/2 3*pi/4 pi]);
    xticklabels({'0', '\pi/4', '\pi/2', '3\pi/4', '\pi'});
    xlabel('Frequency')
    ylabel('Grou Delay')
    title(['Group Delay of ', t])
    
    subplot(6, 1, 4:5);
    [z,p] = f.zpk;
    zplane(z, p);
    
    subplot(6, 1, 6);
    [h, t] = impz(f);
    stem(t, h);
    xlabel('Samples')
    ylabel('Amplitude')
    title('Impulse Response')
    
    if playSound ~= 0
        soundsc(filter(f, noisy), fs)
    end
end


%% summary

% For this project, six different types of filters were made in order to
% filter out the noise from a audio file. For each filter, the appropriate
% matlab function was used in order to determine the order of the function,
% as well as the filter itself. For example, for butterworth, the buttord
% function returns the order of a filter given a set of specs, and then
% that is used to create a butterworth filter using the butter function.
% Each filter has its own file/function, and can be called using the
% required specs. Finally, a function called displayFilter is called to
% graph the Frequency response, group delay, pole zero plot, and impulse
% response of the filter.