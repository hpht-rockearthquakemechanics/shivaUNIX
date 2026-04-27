function new_handles = load_isco_data(handles, params_struct)
% LOAD_ISCO_DATA - Carica e sincronizza i dati delle pompe ISCO.
%--------------------------------------------------------------------------
disp('--- Inizio caricamento dati ISCO...');
new_handles = handles;
new_handles.log = append_action_to_log(new_handles.log, 'load_isco_data', params_struct);

isco_file_paths = params_struct.isco_file_paths; % Ora è un cell array

% --- 1. Pulizia dati ISCO precedenti ---
% Definisci qui i nomi delle colonne che questa funzione aggiunge
isco_fields = {'timeISCO', 'PressureA', 'PressureB', 'FlowRateA', 'FlowRateB', 'VolumeA', 'VolumeB'};
if isfield(new_handles, 'column')
    new_handles.column = new_handles.column(~ismember(new_handles.column, isco_fields));
end
for i = 1:length(isco_fields)
    if isfield(new_handles, isco_fields{i})
        new_handles = rmfield(new_handles, isco_fields{i});
    end
end

try
    % --- 2. Caricamento e Concatenazione Dati Grezzi ---
    % Itera su tutti i file trovati e li appende
    source_data = struct();
    for i = 1:length(isco_file_paths)
        current_file_path = isco_file_paths{i};
        disp([' -> Caricamento file: ', current_file_path]);

        [~, name, ext] = fileparts(current_file_path);

        if strcmpi(ext, '.csv') || is_comma_separated(current_file_path)
            % Se ha estensione .csv O se non ha estensione ma contiene virgole,
            % trattalo come un CSV.
            single_file_data = load_isco_csv(current_file_path,handles);
        elseif isempty(ext) % Se non ha estensione e non contiene virgole
            if endsWith(name, 'IP')
                single_file_data = load_isco_no_ext(current_file_path,handles,'IP');
            elseif endsWith(name,'ISCO')
                single_file_data = load_isco_no_ext(current_file_path,handles,'ISCO');
            end
        else
            warning('Estensione file non supportata per dati ISCO: %s. File saltato.', ext);
            continue;
        end

        % Concatena i dati del file corrente a quelli totali
        source_data = append_isco_data(source_data, single_file_data);
    end

    % --- 3. Sincronizzazione Temporale ---
    if isfield(source_data, 'timeISCO') && isfield(new_handles, 'Time')
        time_source_aligned = synchronize_isco_signals(new_handles, source_data);
        if isempty(time_source_aligned)
            disp('Sincronizzazione fallita o non necessaria. Si procede senza allineamento temporale.');
            time_source_aligned = source_data.timeISCO; % Usa il tempo originale
        end
    else
        warning('Dati sorgente o di riferimento mancanti per la sincronizzazione.');
        disp('--- Caricamento ISCO completato con errori. ---');
        return;
    end

    % --- 4. Interpolazione e Integrazione in 'handles' ---
    disp(' -> Interpolazione dei dati ISCO sull''asse temporale principale...');
    source_fields = fieldnames(source_data);
    for i = 1:length(source_fields)
        field = source_fields{i};
        new_handles.(field) = interp1(time_source_aligned, source_data.(field), new_handles.Time, 'linear', 0);

        if ~any(strcmp(new_handles.column, field))
            new_handles.column{end+1} = field;
        end
    end

    disp('--- Caricamento dati ISCO completato con successo ---');
catch ME
    warning('Errore durante il caricamento dei dati ISCO: %s', ME.message);
    disp('--- Caricamento dati ISCO completato con errori. ---');
end
end

% =========================================================================
% SOTTO-FUNZIONI
% =========================================================================

function data_out = load_isco_csv(fpath,handles)
% Esempio di funzione per caricare un file CSV da una pompa ISCO
% Esempio: Legge un CSV con header
opts = detectImportOptions(fpath);
opts.SelectedVariableNames = {'Var2','Var3','Var4','Var5','Var6','Var7','Var8'};

T = readtable(fpath,opts);
T.Properties.VariableNames = {'timeISCO','PressurePumpA','FlowPumpA','VolumePumpA','PressurePumpB','FlowPumpB','VolumePumpB'};

% Mappa le colonne della tabella in una struct con nomi standard
data_out = struct();

data_out.timeISCO = (T.timeISCO-T.timeISCO(1))*24*3600*1000; %days from 1 Jan 1900 to relative milliseconds from start
data_out.PressurePumpA = T.PressurePumpA * 1e-3; %kPa to MPa
data_out.FlowPumpA = T.FlowPumpA; %mL/min
data_out.VolumePumpA = T.VolumePumpA; %mL
data_out.PressurePumpB = T.PressurePumpB * 1e-3; %kPa to MPa
data_out.FlowPumpB = T.FlowPumpB; %mL/min
data_out.VolumePumpB = T.VolumePumpB; %mL
end

function time_aligned = synchronize_isco_signals(handles, source_data)
% Sincronizza i segnali ISCO usando la cross-correlazione
time_aligned = [];

% ADATTA QUESTA LOGICA: Scegli due segnali che dovrebbero correlare. Questo
% ci obbliga ad aver eseguito calibration come prima operazione, oppure no?
if isfield(handles, 'AI16') && isfield(source_data, 'PressurePumpB')
    disp(' -> Utilizzo di AI16 e PressurePumpB per la correlazione.');
    opts.rescale=[0,1];
    opts.soglia_Z=2;
    time_aligned = correct_time_using_xcorr(handles.Time, handles.AI16, source_data.timeISCO, source_data.PressurePumpB, opts);

    if ~isempty(time_aligned)
        disp(' -> Correlazione ISCO conclusa con successo!');
    else
        warning('Correlazione ISCO fallita.');
    end

elseif isfield(handles, 'FluidPressure') && isfield(source_data, 'PressurePumpA')
    disp(' -> Utilizzo di FluidPressure e PressurePumpA per la correlazione.');
    opts.rescale=[0,1];
    opts.soglia_Z=2;
    time_aligned = correct_time_using_xcorr(handles.Time, handles.FluidPressure, source_data.timeISCO, source_data.PressurePumpA, opts);

    if ~isempty(time_aligned)
        disp(' -> Correlazione ISCO conclusa con successo!');
    else
        warning('Correlazione ISCO fallita.');
    end
end

% if isfield(handles, 'GefranPressure') && isfield(source_data, 'PressurePumpA')
%     disp(' -> Utilizzo di GefranPressure e PressurePumpA per la correlazione.');
%     opts.rescale=[0,1];
%     opts.soglia_Z=2;
%     time_aligned = correct_time_using_xcorr(handles.Time, handles.GefranPressure, source_data.timeISCO, source_data.PressurePumpA, opts);
% 
%     if ~isempty(time_aligned)
%         disp(' -> Correlazione ISCO conclusa con successo!');
%     else
%         warning('Correlazione ISCO fallita.');
%     end
% end
end

function result = is_comma_separated(fpath)
% Controlla se la prima riga di un file di testo contiene una virgola.
result = false;
fid = fopen(fpath, 'r');
if fid == -1
    warning('is_comma_separated:FileOpenError', 'Impossibile aprire il file: %s', fpath);
    return;
end
% Leggi solo la prima riga
first_line = fgetl(fid);
fclose(fid);

% Se la riga è valida e contiene una virgola, è un CSV.
if ischar(first_line) && contains(first_line, ',')
    result = true;
end
end

function data_out = load_isco_no_ext(fpath,handles,suffix)
% Funzione per caricare file ISCO senza estensione (es. sXXXXIP e sXXXXISCO)
try
    switch suffix
        case 'ISCO'
            opts = detectImportOptions(fpath);
            T = readtable(fpath,opts);
            T.Properties.VariableNames = {'dtISCO','PressurePumpA','FlowPumpA','VolumePumpA','PressurePumpB','FlowPumpB','VolumePumpB'};

            % Mappa le colonne della tabella in una struct con nomi standard
            data_out = struct();

            data_out.timeISCO = cumsum(T.dtISCO)*1000; %days from 1 Jan 1900 to relative milliseconds from start
            data_out.timeISCO = data_out.timeISCO - data_out.timeISCO(1);
            data_out.PressurePumpA = T.PressurePumpA; %MPa
            data_out.FlowPumpA = T.FlowPumpA; %mL/min
            data_out.VolumePumpA = T.VolumePumpA; %mL
            data_out.PressurePumpB = T.PressurePumpB; %MPa
            data_out.FlowPumpB = T.FlowPumpB; %mL/min
            data_out.VolumePumpB = T.VolumePumpB; %mL
        case 'IP'
            opts = detectImportOptions(fpath);
            T = readtable(fpath,opts);
            T.Properties.VariableNames = {'PressurePumpA','FlowPumpA','VolumePumpA','PressurePumpB','FlowPumpB','VolumePumpB','dtISCO'};

            % Mappa le colonne della tabella in una struct con nomi standard
            data_out = struct();

            data_out.timeISCO = cumsum(T.dtISCO); %milliseconds from start
            data_out.timeISCO = data_out.timeISCO - data_out.timeISCO(1);
            data_out.PressurePumpA = T.PressurePumpA * 1e-3; %kPa to MPa
            data_out.FlowPumpA = T.FlowPumpA; %mL/min
            data_out.VolumePumpA = T.VolumePumpA; %mL
            data_out.PressurePumpB = T.PressurePumpB * 1e-3; %MPa
            data_out.FlowPumpB = T.FlowPumpB; %mL/min
            data_out.VolumePumpB = T.VolumePumpB; %mL
    end
catch ME
    error('load_isco_no_ext:ReadError', 'Impossibile leggere il file ISCO senza estensione: %s. Errore: %s', fpath, ME.message);

end
end

function all_data = append_isco_data(all_data, new_data)
% Concatena i dati da un nuovo file a quelli già caricati.
if isempty(fieldnames(all_data))
    all_data = new_data;
    return;
end

% Calcola l'offset temporale per garantire la continuità
last_time = all_data.timeISCO(end);
dt = new_data.timeISCO(2) - new_data.timeISCO(1); % Assumi dt costante
time_offset = last_time + dt;

% Applica l'offset e concatena
all_fields = fieldnames(new_data);
for i = 1:length(all_fields)
    field = all_fields{i};
    if strcmp(field, 'timeISCO')
        all_data.timeISCO = [all_data.timeISCO; new_data.timeISCO + time_offset];
    elseif isfield(all_data, field)
        all_data.(field) = [all_data.(field); new_data.(field)];
    end
end
end