function apply_fft(handles, column_index, range_indices, target_axes)
% APPLY_FFT - Calcola e visualizza la FFT di un segmento di dati.
%
% SINTASSI:
%   apply_fft(handles, column_index, range_indices, target_axes)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   column_index: (int) Indice della colonna su cui calcolare la FFT.
%   range_indices: (array) Intervallo di indici [start, end] per la FFT.
%   target_axes: (struct) Struct contenente gli assi per il plot (axes4, axes5).
%
%--------------------------------------------------------------------------

disp('Calculating FFT...');

col_name = handles.column{column_index};
I1 = range_indices(1);
I2 = range_indices(2);

% WARNING: The following steps replicate the original destructive behavior of the
% fft_Callback function. This is not standard practice.

% 1. Calculate mean from the start of the dataset.
mmed_torq = mean(smooth(handles.(col_name)(1:min(100, end)), 50));

% 2. Destructively subtract this mean from the *entire* data column.
temp_col = handles.(col_name) - mmed_torq;

% 3. Take only the selected segment, apply a hamming window, and
%    use this segment for the FFT. The original function was also
%    destructive at this step, overwriting the main data vector. We will
%    use a temporary variable to avoid this side effect, but the calculation
%    is the same.
data_for_fft = temp_col(I1:I2) .* hamming(length(I1:I2));

dt = mode(handles.Stamp(I1:I2));
nfft = 4096;
Y = fft(data_for_fft, nfft);
Fs = 1000/dt; % Frequenza di campionamento in Hz
f = Fs * (0:(nfft/2)) / nfft;
Pyy = Y .* conj(Y) / nfft;

% Grafico Frequenza vs Potenza
% Escludiamo f(1)=0 (componente DC) che spesso ha un'ampiezza molto maggiore
plot(f(2:end), Pyy(2:(nfft/2)+1), 'Parent', target_axes.axes4);
set(target_axes.axes4, 'XLim', [0 Fs/2]); % Imposta il limite alla frequenza di Nyquist
set(target_axes.axes4, 'YLimMode', 'auto'); % Lascia che MATLAB scelga il limite Y
set(target_axes.axes4.XLabel, 'String', 'f');
set(target_axes.axes4.YLabel, 'String', 'Pyy');

% Grafico Periodo vs Potenza
% Escludiamo f(1)=0 per evitare Inf in 1/f
plot(1./f(2:end), Pyy(2:(nfft/2)+1), 'Parent', target_axes.axes5);
set(target_axes.axes5, 'XDir', 'reverse'); % Mostra i periodi più lunghi a destra
set(target_axes.axes5, 'YLimMode', 'auto'); % Lascia che MATLAB scelga il limite Y
set(target_axes.axes5.XLabel, 'String', '1/f');
set(target_axes.axes5.YLabel, 'String', 'Pyy');

disp(' -> FFT plot updated.');

end