function new_handles = apply_smoothing(handles, params_struct)
% APPLY_SMOOTHING - Applica un filtro di media mobile a una colonna di dati.
%
% SINTASSI:
%   new_handles = apply_smoothing(handles, params_struct)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   params_struct: (struct) con i campi .column_index e .window_size.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata con la nuova
%                colonna smussata e il backup dell'originale.
%--------------------------------------------------------------------------

disp('Applying smoothing...');
new_handles = handles;

column_index = params_struct.column_index;
window_size = params_struct.window_size;
new_handles.log = append_action_to_log(new_handles.log, 'apply_smoothing', params_struct);

col_name = new_handles.column{column_index};
new_col_name = [col_name, '_smooth'];

% --- Validazione e preparazione dei dati per smooth ---
data_to_smooth = new_handles.(col_name);

% 1. Assicurati che i dati siano un vettore colonna
if isrow(data_to_smooth)
    data_to_smooth = data_to_smooth';
end

data_length = length(data_to_smooth);

% 2. Gestisci casi in cui lo smoothing non è applicabile o window_size è invalida
if data_length <= 1
    warning('apply_smoothing:DataTooShort', 'La lunghezza dei dati per la colonna ''%s'' è %d. Lo smoothing non è applicabile.', col_name, data_length);
    new_handles.(new_col_name) = data_to_smooth; % Copia i dati originali
    % Aggiunge la nuova colonna alla lista se non esiste già
    if ~any(strcmp(new_handles.column, new_col_name))
        new_handles.column{end+1} = new_col_name;
    end
    disp([' -> Data length for ''', col_name, ''' is too short for smoothing. Data copied directly.']);
    return; % Esci dalla funzione
end

% 3. Valida window_size: deve essere un intero positivo e minore della lunghezza dei dati
if ~isnumeric(window_size) || ~isscalar(window_size) || window_size <= 0 || mod(window_size, 1) ~= 0
    warning('apply_smoothing:InvalidWindowSize', 'La dimensione della finestra (%s) non è un intero positivo. Verrà usata una dimensione predefinita di 500.', mat2str(window_size));
    window_size = 500; % Valore di default robusto
end

% Assicurati che window_size non sia maggiore o uguale alla lunghezza dei dati
window_size = min(window_size, data_length - 1); % Imposta la finestra massima possibile
window_size = max(1, window_size); % Assicurati che sia almeno 1
if mod(window_size, 2) == 0 % smooth preferisce finestre dispari, se pari la riduce di 1
    window_size = window_size - 1;
    if window_size == 0 % Se diventa 0, imposta a 1
        window_size = 1;
    end
end

if window_size < params_struct.window_size % Avvisa se la finestra è stata ridotta
    warning('apply_smoothing:WindowAdjusted', 'La dimensione della finestra (%d) è stata regolata a %d per la colonna ''%s'' per essere compatibile con la lunghezza dei dati.', params_struct.window_size, window_size, col_name);
end

% --- Applica lo smoothing ---
% smooth può gestire NaN/Inf, ma a volte è meglio pre-processarli.
% Per evitare blocchi, interpoliamo i valori non finiti prima di smussare.
if any(~isfinite(data_to_smooth))
    warning('apply_smoothing:NonFiniteData', 'La colonna ''%s'' contiene valori NaN/Inf. Verranno interpolati linearmente prima dello smoothing.', col_name);
    data_to_smooth = fillmissing(data_to_smooth, 'linear', 'EndValues', 'nearest');
end

new_handles.(new_col_name) = smooth(data_to_smooth, window_size);

% Aggiunge la nuova colonna alla lista se non esiste già
if ~any(strcmp(new_handles.column, new_col_name))
    new_handles.column{end+1} = new_col_name;
end

disp([' -> Smoothing applied. New column ''', new_col_name, ''' created.']);

end