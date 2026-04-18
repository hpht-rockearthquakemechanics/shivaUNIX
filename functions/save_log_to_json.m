function save_log_to_json(handles, output_file_path)
% SAVE_LOG_TO_JSON - Salva il log della sessione in un file JSON.
%
% SINTASSI:
%   save_log_to_json(handles, output_file_path)
%
% INPUT:
%   handles: (struct) La struttura dati principale che contiene il campo 'log'.
%   output_file_path: (string) Il percorso completo del file di dati principale
%                     (es. 'C:\data\s1234.mat'). Il file di log verrà salvato
%                     accanto a questo con estensione .log.json.
%
%--------------------------------------------------------------------------

if ~isfield(handles, 'log') || isempty(handles.log) || (iscell(handles.log) && numel(handles.log) < 2)
    disp('Nessun log significativo da salvare.');
    return;
end

[path, name, ~] = fileparts(output_file_path);
log_filename = fullfile(path, [name, '.json']);

try
    json_string = jsonencode(handles.log, 'PrettyPrint', true);
    fid = fopen(log_filename, 'w');
    if fid == -1, error('Impossibile aprire il file di log per la scrittura: %s', log_filename); end
    fprintf(fid, '%s', json_string);
    fclose(fid);
    disp(['Log salvato con successo in: ', log_filename]);
catch ME
    warning('Errore durante la codifica o il salvataggio del file JSON: %s', ME.message);
end

end