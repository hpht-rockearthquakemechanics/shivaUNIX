function new_handles = load_gefran_data(handles, params_struct)
% LOAD_GEFRAN_DATA - Carica tutto e mappa le variabili standard
%--------------------------------------------------------------------------
disp('Inizio caricamento dati GEFRAN...');
new_handles = handles;
new_handles.log = append_action_to_log(new_handles.log, 'load_gefran_data', params_struct);

gefran_file_path = params_struct.gefran_file_path;

% --- 1. Pulizia dati precedenti (Vecchia Logica) ---
gefran_fields = {'SpeedGEF', 'timeGEF', 'TorqueGEF', 'VGEF', 'TqGEF'};
if isfield(new_handles, 'column')
    % Rimuoviamo da .column sia i nomi standard che quelli dinamici caricati in precedenza
    % (Opzionale: potresti voler resettare handles.column se contiene solo dati Gefran)
    new_handles.column = new_handles.column(~ismember(new_handles.column, gefran_fields));
end

for i = 1:length(gefran_fields)
    if isfield(new_handles, gefran_fields{i})
        new_handles = rmfield(new_handles, gefran_fields{i});
    end
end

% --- 2. Smistamento in base all'estensione ---
[~, ~, ext] = fileparts(gefran_file_path);

try
    if strcmpi(ext, '.osc')
        gefran_handles = load_dynamic_osc(new_handles, gefran_file_path);
    elseif strcmpi(ext, '.txt')
        gefran_handles = load_dynamic_txt(new_handles, gefran_file_path);
        gefran_handles.timeGEF=gefran_handles.timeGEF/1e7*1e3/handles.tconv;
    end

    % --- 3. Sincronizzazione Temporale ---
    % Controlla se abbiamo un file ASCII di riferimento e un vettore 'timeGEF'
    if isfield(gefran_handles, 'timeGEF')
                
        % Prova a usare lo stress/coppia (Shear_stress vs TqGEF)
        if isfield(new_handles, 'TorqueLG') && isfield(gefran_handles, 'TqGEF')
            disp(' -> Utilizzo di TorqueLG e TqGEF per la correlazione.');
            timeGEF_shifted=correct_time_using_xcorr(new_handles.Time, new_handles.TorqueLG, gefran_handles.timeGEF, gefran_handles.TqGEF * -1);
            if ~isempty(timeGEF_shifted)
                disp(' -> Correlazione conclusa con successo!')
            else
                disp(' -> Correlazione non possibile!')
                return
            end
        end
        % figure; hold on; yyaxis left; plot(new_handles.Time, new_handles.TorqueLG); yyaxis right; plot(timeGEF_shifted,new_handles.TqGEF);

        % Trova tutti i campi che NON sono 'timeGEF' ma sono stati caricati
        gefran_data_fields = gefran_fields(~strcmp(gefran_fields, 'timeGEF'));
        
        for i = 1:length(gefran_data_fields)
            field_name = gefran_data_fields{i};
            if isfield(gefran_handles, field_name)
                % Interpola il segnale sul vettore temporale principale.
                % 'extrap' riempirà con NaN i valori fuori range.
                new_handles.(field_name) = interp1(timeGEF_shifted, gefran_handles.(field_name), new_handles.Time, 'linear', 0);
                new_handles.column{end+1} = field_name;
            end
        end
        % Ora anche timeGEF può essere allineato per coerenza
        new_handles.timeGEF = interp1(timeGEF_shifted, timeGEF_shifted, new_handles.Time, 'linear', 0);

        % figure; hold on; yyaxis left; plot(new_handles.Time, new_handles.TorqueLG); yyaxis right; plot(new_handles.timeGEF,new_handles.TqGEF);
    end
    disp('Caricamento completato.');
catch ME
    warning('Errore: %s', ME.message);
end
end

% =========================================================================
% SOTTO-FUNZIONI
% =========================================================================

function h = load_dynamic_osc(h, fpath)
    data_struct = importdata(fpath, '\t', 1);
    headers = strrep(data_struct.textdata(1,:), '"', ''); 
    headers(strcmp(headers, 'Time')) = {'time'};
    h = map_and_alias(h, headers, data_struct.data);
end

function h = load_dynamic_txt(h, fpath)
    fid = fopen(fpath, 'r');
    fgetl(fid); % AL_OSC
    var_names = {};
    line = fgetl(fid);
    while ischar(line) && ~isempty(line) && ~is_numeric_row(line)
        tokens = strsplit(strtrim(line), '\t');
        var_names{end+1} = tokens{1}; 
        line = fgetl(fid);
    end
    fclose(fid);
    data_matrix = readmatrix(fpath, 'FileType', 'text', 'NumHeaderLines', length(var_names) + 1, 'Delimiter', '\t');
    h = map_and_alias(h, var_names, data_matrix);
end

function h = map_and_alias(h, names, data)
    % Questa funzione fa due cose:
    % 1. Carica la colonna col suo nome originale (pulito)
    % 2. Crea un alias se riconosce Tempo, Velocità o Coppia
    
    for i = 1:length(names)
        orig_name = matlab.lang.makeValidName(strrep(names{i}, ' ', '_'));
        h.(orig_name) = data(:, i);
        
        % Aggiungi il nome originale alla lista colonne per la pulizia futura
        if ~isfield(h, 'column'), h.column = {}; end
        h.column{end+1} = orig_name;

        % --- LOGICA DI ALIASING (Mappatura sui tuoi gefran_fields) ---
        low_n = lower(orig_name);
        
        % Tempo -> timeGEF
        if strcmpi(low_n, 'time')
            h.timeGEF = data(:, i);
            h.column{end+1} = 'timeGEF';
        % Velocità -> VGEF
        elseif contains(low_n, 'speed') || contains(low_n, 'vgef')
            h.VGEF = data(:, i);
            h.column{end+1} = 'VGEF';
        % Coppia -> TqGEF
        elseif contains(low_n, 'torque') || contains(low_n, 'tqgef')
            h.TqGEF = data(:, i);
            h.column{end+1} = 'TqGEF';
        end
    end
    
    % Se dopo il ciclo TqGEF manca (caso del .txt), lo creiamo vuoto/zero
    if ~isfield(h, 'TqGEF') && isfield(h, 'timeGEF')
        h.TqGEF = zeros(size(h.timeGEF));
        h.column{end+1} = 'TqGEF';
    end
    
    % Rimuovi duplicati da h.column
    h.column = unique(h.column, 'stable');
end

function check = is_numeric_row(str)
    val = str2double(strsplit(strtrim(str), '\t'));
    check = ~isempty(val) && ~isnan(val(1));
end