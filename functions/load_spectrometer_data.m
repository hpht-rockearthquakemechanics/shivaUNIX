function new_handles = load_spectrometer_data(handles, params_struct)

disp('--- Inizio caricamento dati SPECTROMETER...');
new_handles = handles;
new_handles.log = append_action_to_log(new_handles.log, 'load_spectrometer_data', params_struct);

% =========================================================================
% --- PULIZIA DATI PRECEDENTI (Usa la memoria dell'ultimo caricamento) ---
% =========================================================================
if isfield(new_handles, 'last_spectrometer_vars')
    vecchie_variabili = new_handles.last_spectrometer_vars;
    
    % Rimuove le vecchie variabili dalla lista 'column'
    if isfield(new_handles, 'column')
        new_handles.column = new_handles.column(~ismember(new_handles.column, vecchie_variabili));
    end
    
    % Rimuove fisicamente i campi da handles
    for i = 1:length(vecchie_variabili)
        if isfield(new_handles, vecchie_variabili{i})
            new_handles = rmfield(new_handles, vecchie_variabili{i});
        end
    end
    disp('Pulizia vecchi dati completata con successo.');
end

spectrometer_file_path = params_struct.spectrometer_file_path; % Ora è un cell array

% --- 1. LEGGI L'HEADER E CREA IL DIZIONARIO DINAMICO ---
fid = fopen(spectrometer_file_path{1}, 'r');
mappa_nomi = containers.Map(); % Il nostro dizionario
tipo_misura = '';
unita = '';
riga_header_colonne = '';
num_header_lines = 0;

while ~feof(fid)
    linea = fgetl(fid);
    num_header_lines = num_header_lines + 1;
    linea_trim = strtrim(linea);

    if isempty(linea_trim)
        continue; % Salta righe vuote
    end

    % A. Trova un Datablock e capisce che tipo di dati stiamo per leggere
    if contains(linea, 'Datablock')
        parti = strsplit(linea, '\t');
        if length(parti) >= 3
            if contains(parti{2}, 'Ion Current')
                tipo_misura = 'IonCurrent_Mass';
                unita = regexprep(parti{3}, '[\[\]\W]', '');
            elseif contains(parti{2}, 'PKR')
                tipo_misura = 'Pressure';
                unita = regexprep(parti{3}, '[\[\]\W]', '');
            elseif contains(parti{2}, 'Concentr.')
                tipo_misura = 'Concentration';
                unita = 'percent';
            else
                % Se in futuro aggiungi un altro sensore, prende il nome grezzo
                tipo_misura = regexprep(parti{2}, '\W', '');
                if length(parti) >= 3
                    unita = regexprep(parti{3}, '[\[\]\W]', '');
                else
                    unita = ''; % Nessuna unità trovata
                end
            end
        end

        % B. Trova la definizione di una massa/variabile (es: '0/0'   14.00)
    elseif startsWith(linea_trim, '''')
        parti = strsplit(linea_trim, '\t');
        if length(parti) >= 2
            chiave_originale = parti{1}; % Mantiene gli apici: "'0/0'"
            valore_grezzo = strtrim(parti{2}); % Es: "14.00" o "PKR"

            % --- LOGICA DI ARROTONDAMENTO ---
            valore_numerico = str2double(valore_grezzo);

            if ~isnan(valore_numerico)
                valore = sprintf('%d', round(valore_numerico));
            else
                valore = regexprep(valore_grezzo, '\W', '');
            end
            % --------------------------------

            nuovo_nome = sprintf('%s_%s_%s', tipo_misura, valore, unita);
            nuovo_nome = regexprep(nuovo_nome, '_$', '');
            mappa_nomi(chiave_originale) = nuovo_nome;
        end

        % C. Trova la VERA riga di intestazione delle colonne
    elseif startsWith(linea, 'Cycle')
        riga_header_colonne = linea;
        break; 
    end
end
fclose(fid);

% --- 2. COSTRUISCI L'ORDINE ESATTO DELLE VARIABILI ---
nomi_originali = strsplit(strtrim(riga_header_colonne), '\t');
nomi_finali = cell(1, length(nomi_originali));

for i = 1:length(nomi_originali)
    nome_orig = strtrim(nomi_originali{i});

    if isKey(mappa_nomi, nome_orig)
        nomi_finali{i} = mappa_nomi(nome_orig);
    else
        nome_pulito = regexprep(nome_orig, '[\[\]\W]', '_');
        nome_pulito = regexprep(nome_pulito, '_$', ''); 
        nomi_finali{i} = nome_pulito;
    end
end

%% --- 3. IMPORTA I DATI E FORZA I NOMI ---
opts = detectImportOptions(spectrometer_file_path{1}, ...
    'FileType', 'text', ...
    'Delimiter', '\t', ...
    'NumHeaderLines', num_header_lines);

opts = setvartype(opts, {'Var2', 'Var3'}, 'string');
tabella_dati = readtable(spectrometer_file_path{1}, opts);

dataOraStringa = tabella_dati.Var2 + " " + tabella_dati.Var3;

try
    Timestamp = datetime(dataOraStringa, 'InputFormat', 'dd/MM/yyyy HH:mm:ss:SS');
catch
    Timestamp = datetime(dataOraStringa, 'InputFormat', 'M/d/yyyy hh:mm:ss:SS a');
end
Timestamp.TimeZone='Europe/Rome';

if size(tabella_dati, 2) == length(nomi_finali)
    tabella_dati.Properties.VariableNames = nomi_finali;
else
    warning('Il numero di colonne nei dati non combacia con i nomi letti dall''header.');
end

disp(head(tabella_dati));

%% --- COSTRUZIONE ASSI TEMPORALI ASSOLUTI (SYNCHRONIZATION) ---
colonna_tempo = 'RelTime_s';
ascii_lastwrite_datetime = handles.ascii_lastwrite_datetime;

% 1. Ricostruzione dell'asse temporale assoluto dell'ASCII
tempi_trascorsi = milliseconds(handles.Time);
tempo_finale = tempi_trascorsi(end);
offset_dal_termine = tempo_finale - tempi_trascorsi;
ascii_Timestamp = ascii_lastwrite_datetime - offset_dal_termine;

% 2. Calcolo opzionale per allineare il cronometro RelTime_s dello spettrometro
%    Sincronizziamo il tempo relativo e applichiamo l'offset iniziale
ritardo_assoluto = Timestamp(1) - ascii_Timestamp(1);
offset_s = seconds(ritardo_assoluto);
reltime_interp = interp1(Timestamp, tabella_dati.RelTime_s, ascii_Timestamp, 'linear', 0);

% Salviamo il cronometro dello spettrometro allineato e convertito in millisecondi
new_handles.RelTime_s_ms = 1000 * (reltime_interp + offset_s);

if ~isfield(new_handles, 'column')
    new_handles.column = {};
end

if 0
    figure(888)
    yyaxis left;
    plot(Timestamp,tabella_dati.IonCurrent_Mass_44_A)
    yyaxis right;
    plot(ascii_Timestamp,handles.TorqueLG)
end

%% --- 4. ESPORTAZIONE DATI GREZZI E TRASFORMAZIONI IN HANDLES ---

% =========================================================================
% FASE A: SALVATAGGIO DI TUTTE LE COLONNE ORIGINALI
% =========================================================================
nomi_colonne = tabella_dati.Properties.VariableNames; % Corretto da tabella_finale a tabella_dati

for c = 1:length(nomi_colonne)
    nome = nomi_colonne{c};
    dati_colonna = tabella_dati.(nome);

    if isnumeric(dati_colonna) && ~strcmp(nome, colonna_tempo) && ~strcmp(nome, 'Cycle')
        % Sincronizzazione: Interpoliamo dai tempi assoluti dello Spettrometro (Timestamp)
        % ai tempi assoluti target (ascii_Timestamp), imponendo 0 per le code.
        sync_raw = interp1(Timestamp, dati_colonna, ascii_Timestamp, 'linear', 0);

        % Poiché ascii_Timestamp è calcolato partendo da handles.Time,
        % sync_raw è ora perfettamente mappato 1:1 su handles.Time!
        new_handles.(nome) = sync_raw;

        if ~ismember(nome, new_handles.column)
            new_handles.column{end+1} = nome;
        end
    end
end
disp('Tutte le colonne numeriche originali sono state sincronizzate in handles.');

% =========================================================================
% FASE B: RICETTE PER I PASSAGGI INTERMEDI E FINALI
% =========================================================================
recipes = [
    struct('Target', 'CO2',       'Source', 'IonCurrent_Mass_44_A', 'Scale', 3.5e7, 'Offset', 0.00024, 'DoNorm', false, 'Slope', 0,       'Power', 1),
    struct('Target', 'CO2mass',   'Source', 'IonCurrent_Mass_44_A', 'Scale', 1,     'Offset', 0,       'DoNorm', true,  'Slope', 0.00024, 'Power', 1/2),
    struct('Target', 'O2mass',    'Source', 'IonCurrent_Mass_32_A', 'Scale', 1,     'Offset', 0,       'DoNorm', true,  'Slope', 0.00013, 'Power', 1/2),
    struct('Target', 'H2Omass',   'Source', 'IonCurrent_Mass_18_A', 'Scale', 1,     'Offset', 0,       'DoNorm', true,  'Slope', 0.00013, 'Power', 1),
    struct('Target', 'CO2mass_2', 'Source', 'IonCurrent_Mass_44_A', 'Scale', 1,     'Offset', 0,       'DoNorm', true,  'Slope', 0.00024, 'Power', 1/8),
    struct('Target', 'O2mass_2',  'Source', 'IonCurrent_Mass_32_A', 'Scale', 1,     'Offset', 0,       'DoNorm', true,  'Slope', 0.00013, 'Power', 1/8),
    struct('Target', 'H2Omass_2', 'Source', 'IonCurrent_Mass_18_A', 'Scale', 1,     'Offset', 0,       'DoNorm', true,  'Slope', 0.00013, 'Power', 1/4)
];

% --- MOTORE DI CALCOLO ---
for i = 1:length(recipes)
    r = recipes(i);

    if ismember(r.Source, tabella_dati.Properties.VariableNames)
        raw_sig = tabella_dati.(r.Source);

        % Step 1: Scalatura e Offset
        sig_calib = (raw_sig .* r.Scale) + r.Offset;

        % Step 2: Normalizzazione
        if r.DoNorm
            norm_factor = sig_calib(1);
        else
            norm_factor = 1;
        end
        sig_norm = sig_calib ./ norm_factor;

        % Step 3: Detrending lineare (eseguito sui dati grezzi con il tempo non ancora interpolato)
        sig_detrend = sig_norm + (r.Slope .* tabella_dati.(colonna_tempo));

        % Step 4: Potenza
        sig_final = sig_detrend .^ r.Power;

        % Step 5: Sincronizzazione FINALE del segnale processato
        % Anche qui utilizziamo i tempi assoluti e impostiamo a 0 i valori fuori range
        sync_sig = interp1(Timestamp, sig_final, ascii_Timestamp, 'linear', 0);

        % Assegnazione in handles
        new_handles.(r.Target) = sync_sig;
        
        if ~ismember(r.Target, new_handles.column)
            new_handles.column{end+1} = r.Target;
        end

        disp(['Variabile trasformata sincronizzata: ', r.Target]);
    else
        warning('Sorgente %s non trovata per calcolare %s', r.Source, r.Target);
    end
end

nomi_importati = {};
for c = 1:length(nomi_colonne)
    nome = nomi_colonne{c};
    if isnumeric(tabella_dati.(nome)) && ~strcmp(nome, colonna_tempo) && ~strcmp(nome, 'Cycle')
        nomi_importati{end+1} = nome;
    end
end

% 2. Raccogliamo i nomi generati dalle ricette (FASE B)
nomi_ricette = {recipes.Target};

% 3. Uniamo le due liste e le salviamo in handles
new_handles.last_spectrometer_vars = [nomi_importati, nomi_ricette];

disp('Caricamento SPECTROMETER terminato. Variabili memorizzate per future pulizie.');

end