function updated_log = append_action_to_log(current_log, func_name, params_struct)
% APPEND_ACTION_TO_LOG Aggiunge una nuova azione alla ricetta della pipeline.
%
% Input:
%   - current_log: cell array contenente lo storico delle azioni
%   - func_name: stringa con il nome della funzione core da richiamare
%   - params_struct: struttura contenente i parametri usati in quel momento
%
% Output:
%   - updated_log: il cell array aggiornato

    % Se il log arriva vuoto o non inizializzato, lo trasforma in cell array
    if isempty(current_log) || ~iscell(current_log)
        current_log = {};
    end
    
    % Crea il "pacchetto" della singola azione
    new_action = struct();
    new_action.function_name = char(func_name);
    
    % Prova a ottenere il commit hash per il file della funzione
    try
        function_path = which(func_name);
        if ~isempty(function_path) && ~strcmp(function_path, 'built-in')
            [file_dir, ~, ~] = fileparts(function_path);
            
            % 1. Trova la cartella radice del repository Git
            find_root_cmd = sprintf('git -C "%s" rev-parse --show-toplevel', file_dir);
            [status_root, repo_root_path] = system(find_root_cmd);
            
            if status_root == 0 && ~isempty(repo_root_path)
                repo_root_path_clean = strtrim(repo_root_path);
                
                % Salva la directory corrente e spostati temporaneamente nella radice del repo
                original_dir = pwd;
                cd(repo_root_path_clean);
                
                % 2. Esegui il comando git log. Non è più necessario -C perché siamo già nella cartella giusta.
                % Passare gli argomenti come un array di celle a 'system' è più robusto
                % per gestire percorsi con spazi.
                git_command_parts = {'git', 'log', '-1', '--pretty=format:%H', '--', function_path};
                [status_log, cmdout_log] = system(strjoin(git_command_parts, ' '));
                
                % Ripristina immediatamente la directory originale
                cd(original_dir);
                
                if status_log == 0 && ~isempty(cmdout_log)
                    new_action.commit_hash = strtrim(cmdout_log);
                else
                    new_action.commit_hash = 'N/A (git log failed)';
                end
            else
                new_action.commit_hash = 'N/A (file not in git repo or not committed)';
            end
        else
            new_action.commit_hash = 'N/A (function not on path or built-in)';
        end
    catch
        new_action.commit_hash = 'N/A (error getting git hash)';
    end
    
    % Se non ci sono parametri (es. una funzione che fa solo "reset"), 
    % metti una struct vuota per mantenere la coerenza del JSON
    if nargin < 3 || isempty(params_struct)
        new_action.params = struct();
    else
        new_action.params = params_struct;
    end
    
    % Appendi alla fine del log
    current_log{end + 1} = new_action;
    
    % (Opzionale) Stampa a schermo per debug durante lo sviluppo
    fprintf('Aggiunta azione al log: %s\n', new_action.function_name);
    
    % Assegna il log aggiornato alla variabile di output
    updated_log = current_log;
end