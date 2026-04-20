function final_handles = run_pipeline_from_log(log_filepath)
% RUN_PIPELINE_FROM_LOG - Esegue una pipeline di elaborazione dati da un file di log JSON.
%
% SINTASSI:
%   final_handles = run_pipeline_from_log(log_filepath)
%
% INPUT:
%   log_filepath: (string) Il percorso del file .json che contiene il log della pipeline.
%
% OUTPUT:
%   final_handles: (struct) La struttura 'handles' risultante dopo aver eseguito tutte le azioni nel log.
%
% ESEMPIO DI UTILIZZO (dalla Command Window di MATLAB):
%   final_data = run_pipeline_from_log('C:\data\s1234RED.mat.json');
%
%--------------------------------------------------------------------------

% --- 1. Carica e normalizza il log ---
if ~exist(log_filepath, 'file')
    error('File di log non trovato: %s', log_filepath);
end

% Usa la funzione esistente per caricare e gestire la conversione da struct a cell
log_actions = load_log_from_json(log_filepath);

if isempty(log_actions)
    error('Il file di log è vuoto o non è stato possibile leggerlo.');
end

% --- 2. Gestione della dipendenza iniziale (dati grezzi) ---
handles = struct(); % Inizia con una struct vuota
handles.log = {};   % Inizializza un log vuoto per la nuova esecuzione

% Controlla se la prima azione è l'apertura di un file ASCII
first_action = log_actions{1};
if strcmp(first_action.function_name, 'open_ascii_data')
    disp('Trovata azione di apertura dati iniziale. Caricamento dei dati grezzi...');
    try
        % Esegui l'apertura del file per prima cosa
        handles = open_ascii_data(handles, first_action.params); % La funzione ora accetta la struct
        % Rimuovi l'azione dalla lista per non eseguirla di nuovo
        log_actions(1) = [];
        disp(['Dati grezzi caricati da: ', first_action.params.FileName]);
    catch ME
        error('Impossibile caricare il file di dati grezzi iniziale specificato nel log: %s\n%s', first_action.params.FileName, ME.getReport);
    end
end


% --- 3. Controlla se l'ultima azione è un salvataggio e inizializza ---
% Controlla se ci sono ancora azioni dopo l'eventuale apertura
if isempty(log_actions)
    final_handles = handles;
    return;
end
last_action = log_actions{end};
is_final_save = false;
num_actions_to_run = numel(log_actions);

if strcmp(last_action.function_name, 'save_mat_data')
    is_final_save = true;
    final_save_params = last_action.params;
    num_actions_to_run = num_actions_to_run - 1; % L'azione di salvataggio verrà eseguita alla fine
    disp('L''ultima azione è un salvataggio. I dati verranno salvati alla fine della pipeline.');
end

disp(['Esecuzione della pipeline dal log: ', log_filepath]);
disp(['Trovate ', num2str(numel(log_actions)), ' azioni totali. Ne verranno eseguite ', num2str(num_actions_to_run), '.']);

% --- 4. Itera ed esegui ogni azione nel log ---
for i = 1:num_actions_to_run
    action = log_actions{i};
    func_name = action.function_name;
    params = action.params;
    
    % Salta qualsiasi azione di salvataggio intermedia.
    % L'eventuale salvataggio finale è già stato escluso dal ciclo.
    if strcmp(func_name, 'save_mat_data') || strcmp(func_name, 'write_ascii_data')
        fprintf('\n--- Azione %d/%d: %s (SALTATA) ---\n', i, numel(log_actions), func_name);
        continue;
    end
    
    fprintf('\n--- Esecuzione azione %d/%d: %s ---\n', i, numel(log_actions), func_name);
    
    % Converte il nome della funzione in un function handle
    func_handle = str2func(func_name);
    
    try
        % Chiama la funzione dinamicamente, passando sempre la struct dei parametri.
        handles = feval(func_handle, handles, params);
        
        if ~isstruct(handles)
             error('La funzione %s non ha restituito una struttura handles valida.', func_name);
        end
        
    catch ME
        fprintf('ERRORE durante l''esecuzione di ''%s'':\n', func_name);
        fprintf('%s\n', ME.message);
        error('Esecuzione della pipeline interrotta.');
    end
end

% --- 5. Esegui il salvataggio finale se era l'ultima azione del log ---
if is_final_save
    disp('--- Esecuzione del salvataggio finale ---');
    % Chiama save_mat_data con i parametri originali dell'azione di salvataggio
    [final_mat_path, handles] = save_mat_data(handles, final_save_params);
    
    % Salva il log JSON corrispondente, usando il percorso restituito da save_mat_data
    disp('Salvataggio del file di log JSON finale...');
    save_log_to_json(handles, final_mat_path);
end

final_handles = handles;
disp('--- Esecuzione della pipeline completata con successo. ---');

end