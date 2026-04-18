function loaded_log = load_log_from_json(mat_file_path)
% LOAD_LOG_FROM_JSON - Carica un log da un file .json associato a un file .mat.
%
% SINTASSI:
%   loaded_log = load_log_from_json(mat_file_path)
%
% INPUT:
%   mat_file_path: (string) Il percorso completo del file .mat della sessione.
%
% OUTPUT:
%   loaded_log: (cell array) Il log caricato, o una cella vuota se non trovato o in caso di errore.
%
%--------------------------------------------------------------------------

[path, name, ~] = fileparts(mat_file_path);
log_filename = fullfile(path, [name, '.json']);

if exist(log_filename, 'file')
    try
        json_string = fileread(log_filename);
        decoded_data = jsondecode(json_string);
        
        % Se jsondecode restituisce un array di struct, lo converte in un cell array
        if isstruct(decoded_data) && numel(decoded_data) > 1
            % Converte esplicitamente l'array di struct in un cell array di struct
            loaded_log = cell(size(decoded_data));
            for i = 1:numel(decoded_data)
                loaded_log{i} = decoded_data(i);
            end
        else
            loaded_log = decoded_data;
        end
        disp(['Log precedente caricato con successo da: ', log_filename]);
    catch ME
        warning('Errore durante la lettura o la decodifica del file di log JSON: %s', ME.message);
        loaded_log = {}; % Restituisce un log vuoto in caso di errore
    end
else
    disp('Nessun file di log .json trovato. Inizializzazione di un nuovo log.');
    loaded_log = {};
end

end