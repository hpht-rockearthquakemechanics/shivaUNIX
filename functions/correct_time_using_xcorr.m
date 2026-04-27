function tempo2_corretto=correct_time_using_xcorr(tempo1,misura1,tempo2,misura2, options)

if 0
    figure(1000)
    yyaxis left; plot(tempo1, misura1)
    yyaxis right; plot(tempo2, misura2)
end

% --- 0. GESTIONE OPZIONI E PARAMETRI TUNING ---
if nargin < 5, options = struct(); end

% Valori di default che garantiscono il comportamento attuale
default_opts.despike_window = 3;      % Finestra del medfilt1 (0 per disabilitare)
default_opts.soglia_R = 0.65;         % Soglia coeff. correlazione
default_opts.soglia_PR = 1.05;        % Soglia Peak Ratio
default_opts.soglia_Z = 3.0;          % Soglia Z-Score
default_opts.min_peak_dist = 100;     % Distanza minima tra picchi (campioni)
default_opts.rescale = [-1, 1];

% Unisci i default con le opzioni fornite dall'utente
opts = merge_structs(default_opts, options);

% despiking
if opts.despike_window > 0
    misura1 = medfilt1(misura1, opts.despike_window);
end

% normalizzare le misure riportandole a [-1,1]
% figure;
% plot(tempo2,misura2,'-k',tempo2,rescale(misura2,-1,1),'-b',tempo2,misura2/max(abs(misura2)),'-y')
% hold on;
% plot(tempo1,misura1,'-k',tempo1,rescale(misura1,-1,1),'-b',tempo1,misura1/max(abs(misura1)),'-y')

% misura2 = misura2/max(abs(misura2));
% misura1 = misura1/max(abs(misura1));
misura2 = rescale(misura2, opts.rescale(1), opts.rescale(2));
misura1 = rescale(misura1, opts.rescale(1), opts.rescale(2));

% pulire timestep duplicati
% =========================================================================
% 0. PULIZIA DEI DATI (Rimozione timestamp duplicati)
% =========================================================================
% Mantiene il primo campione, e poi solo quelli dove il dt è > 0
idx_valid1 = [true; diff(tempo1) > 0];
tempo1 = tempo1(idx_valid1);
misura1 = misura1(idx_valid1);

% Facciamolo anche per il secondo segnale (prevenire è meglio che curare)
idx_valid2 = [true; diff(tempo2) > 0];
tempo2 = tempo2(idx_valid2);
misura2 = misura2(idx_valid2);

% 1. CALCOLO DEL MINIMO dt REALE
diff_t1 = diff(tempo1);
diff_t2 = diff(tempo2);
min_dt1 = min(diff_t1(diff_t1 > 0));
min_dt2 = min(diff_t2(diff_t2 > 0));

% siccome se prendo il minimo, sovracampiono per niente l'altro segnale,
% qui sotto decido di prender il massimo tra i due timestep minimi
dt = max([min_dt1, min_dt2]);

% if timestep is larger than a millisecond
if dt>1
    % dt=min([min_dt1, min_dt2]);
    dt=1;
end

disp(['Il dt minimo calcolato per la cross-correlazione è: ', num2str(dt)]);


% 2. CREA UNA GRIGLIA TEMPORALE UNIFORME
t1_unif = (min(tempo1) : dt : max(tempo1))';
t2_unif = (min(tempo2) : dt : max(tempo2))';

% 3. INTERPOLA I SEGNALI SULLA GRIGLIA UNIFORME
m1_unif = interp1(tempo1, misura1, t1_unif, 'linear', 'extrap');
m2_unif = interp1(tempo2, misura2, t2_unif, 'linear', 'extrap');

% 4A. DETREND E DEMEAN (Cruciale per segnali reali)
% Rimuove la media e la deriva lineare
% m1_clean = detrend(m1_unif);
% m2_clean = detrend(m2_unif);
m1_clean = m1_unif - mean(m1_unif);
m2_clean = m2_unif - mean(m2_unif);

%% 4B. CROSS-CORRELAZIONE TIPO 1
[r_norm1, lags1] = xcorr(m1_clean, m2_clean, 'none');
% Calcolo offset specifico per xcorr: trova il lag corrispondente al picco
[~, idx1] = max(r_norm1);
offset1 = lags1(idx1) * dt;

%% CROSS CORRELAZIONE LOCALE
if size(m2_clean,1)<size(m1_clean,1)
    disp('m2 is shorter')
    r_norm2 = normxcorr2(m2_clean, m1_clean);
    % Calcolo offset specifico per normxcorr2
    [~, idx2] = max(r_norm2);
    ritardo_campioni2 = idx2 - length(m2_clean);
    offset2 = ritardo_campioni2 * dt;

else
    disp('m1 is shorter')
    r_norm2 = normxcorr2(m1_clean, m2_clean);
    % Calcolo offset specifico per normxcorr2
    [~, idx2] = max(r_norm2);
    ritardo_campioni2 = idx2 - length(m1_clean);
    offset2 = ritardo_campioni2 * dt * -1;

end

if 0
    figure(9999)
    subplot(1,2,1)
    plot(r_norm1)

    subplot(1,2,2)
    plot(r_norm2)
end

%% VALUTAZIONE QUALITY
% Ora valuta_allineamento riceve l'offset già calcolato e funge solo da quality gate
[is_valid1, Z_score1] = valuta_allineamento(r_norm1, opts);
[is_valid2, Z_score2] = valuta_allineamento(r_norm2, opts);

% 3. LOGICA DI SELEZIONE
if is_valid1 && ~is_valid2
    % Caso A: Solo il Metodo 1 ha superato il quality gate
    offset_finale = offset1;
    fprintf('Scelto Metodo 1 (Unico valido).\n');

elseif ~is_valid1 && is_valid2
    % Caso B: Solo il Metodo 2 ha superato il quality gate
    offset_finale = offset2;
    fprintf('Scelto Metodo 2 (Unico valido).\n');

elseif is_valid1 && is_valid2
    % Caso C: ENTRAMBI sono validi (Spareggio!)
    % Usiamo lo Z-Score per premiare il picco che "spicca" di più
    if Z_score1 >= Z_score2
        offset_finale = offset1;
        fprintf('Entrambi validi. Scelto Metodo 1 (Z-Score %.1f vs %.1f).\n', Z_score1, Z_score2);
    else
        offset_finale = offset2;
        fprintf('Entrambi validi. Scelto Metodo 2 (Z-Score %.1f vs %.1f).\n', Z_score2, Z_score1);
    end

else
    % Caso D: NESSUNO dei due è valido
    warning('Attenzione: Nessun allineamento ha superato i requisiti minimi.');

    % Gestione del fallimento (scegli l'approccio più adatto alla tua pipeline):
    offset_finale = NaN; % Consigliato: segnala esplicitamente un dato mancante/invalido

    % Alternativa: prendere comunque "il meno peggio" basandosi su R_max
    % offset_finale = offset1;
end
if ~isnan(offset_finale)
    % 4. Applichi l'offset finale scelto
    % Per allineare tempo2 a tempo1, sottraiamo l'offset calcolato.
    tempo2_corretto = tempo2 + (min(tempo1) + offset_finale - min(tempo2));
else
    tempo2_corretto = [];
end

%% 5. VISUALIZZAZIONE
if 0

    figure(999)
    yyaxis left;
    plot(tempo1, misura1, '-k', 'DisplayName', 'misura 1');
    ylabel('m1');
    
    if ~isempty(offset1)
        t2a = tempo2 + (min(tempo1) + offset1 - min(tempo2));

        yyaxis right;
        hold on;
        plot(t2a, misura2, '-r', 'DisplayName','first method');
        ylabel('m2');
    end
    if ~isempty(offset2)
        t2b = tempo2 + (min(tempo1) + offset2 - min(tempo2));

        yyaxis right;
        hold on;
        plot(t2b, misura2, '-g', 'DisplayName','second method');
        ylabel('m2');
    end

end
end

function [is_valid, Z_score] = valuta_allineamento(r_norm, opts)
% VALUTA_ALLINEAMENTO Valuta in modo critico l'output di cross-correlazione.
% Cerca ESCLUSIVAMENTE allineamenti in fase (correlazione positiva).

% --- 1. ESTRAZIONE DEL PICCO PRINCIPALE ---
% RIMOSSO abs(): cerchiamo solo la massima correlazione concorde (positiva)
[R_max, loc1] = max(r_norm);

% --- 2. ESTRAZIONE PEAK RATIO (Vettorializzata ad alte prestazioni) ---
% Troviamo tutti i picchi logici (un campione maggiore dei suoi due vicini)
% Lavoriamo direttamente su r_norm originale
is_peak = [false; (r_norm(2:end-1) > r_norm(1:end-2)) & (r_norm(2:end-1) > r_norm(3:end)); false];

locs = find(is_peak);
pks = r_norm(locs);

% Vogliamo confrontare il nostro picco massimo solo con altri picchi POSITIVI.
% Ignoriamo eventuali "picchi" locali che si trovano sotto lo zero.
valid_peaks_idx = pks > 0;
locs = locs(valid_peaks_idx);
pks = pks(valid_peaks_idx);

% Ordiniamo i picchi trovati dal più grande al più piccolo
[pks_sorted, sort_idx] = sort(pks, 'descend');
true_locs = locs(sort_idx);

Peak_Ratio = Inf; % Inizializziamo a Inf

% Cerchiamo il "secondo classificato" che sia sufficientemente distante
for i = 2:length(pks_sorted)
    if abs(true_locs(i) - loc1) > opts.min_peak_dist
        P2 = pks_sorted(i);
        Peak_Ratio = R_max / P2;
        break; 
    end
end

% --- 3. ESTRAZIONE Z-SCORE ---
% Calcoliamo Z-score direttamente sui valori originali di r_norm
mu_bg = mean(r_norm);
sigma_bg = std(r_norm);
Z_score = (R_max - mu_bg) / sigma_bg;

% --- LOGICA DI VALIDAZIONE (Quality Gate) ---
% R_max adesso non può mai mascherare una correlazione negativa. 
% Se l'allineamento migliore è al contrario, R_max sarà basso e is_valid sarà false.
is_valid = (R_max > opts.soglia_R) && (Peak_Ratio > opts.soglia_PR) && (Z_score > opts.soglia_Z);

fprintf('R_max: %.3f | Peak Ratio: %.2f | Z-Score: %.1f -> Valido: %d\n', R_max, Peak_Ratio, Z_score, is_valid);
end

function s_out = merge_structs(s_default, s_user)
% Unisce due struct. I campi in s_user sovrascrivono quelli in s_default.
s_out = s_default;
if ~isstruct(s_user)
    return;
end
user_fields = fieldnames(s_user);
for i = 1:length(user_fields)
    field = user_fields{i};
    s_out.(field) = s_user.(field);
end
end