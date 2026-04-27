function isco_file_paths = find_isco_file(base_filename, root_path)
% FIND_ISCO_FILE - Trova automaticamente i file dati delle pompe ISCO o richiede all'utente.
%
% Questa funzione cerca di localizzare automaticamente i file dati ISCO.
% Cerca file senza estensione con suffisso 'IP' o 'ISCO', e file .csv
% contenenti 'isco' nel nome. Se la ricerca fallisce, apre una finestra
% di dialogo per la selezione manuale.
%
% SINTASSI:
%   isco_file_paths = find_isco_file(base_filename, root_path)
%
% INPUT:
%   base_filename: (string) Il nome del file dell'esperimento principale (es. 's2064.mat').
%   root_path:     (string) La cartella radice dove sono archiviati i dati ISCO.
%
% OUTPUT:
%   isco_file_paths: (cell array) Un cell array di percorsi ai file ISCO trovati,
%                    o un cell array vuoto se l'operazione è annullata o fallisce.
%--------------------------------------------------------------------------

isco_file_paths = {}; % Inizializza l'output come cell array

% 1. Estrai il nome dell'esperimento (es. 's2064') dal nome del file base
name_match = regexp(base_filename, 's\d+', 'match');
if isempty(name_match)
    warning('find_isco_file:NoExpName', 'Impossibile estrarre un nome esperimento (es. "sXXXX") da "%s".', base_filename);
else
    exp_name = name_match{1};

    % 2. Cerca la sottocartella dell'esperimento corrispondente
    list = dir(fullfile(root_path, [exp_name '*']));

    % Raffina la ricerca per evitare di trovare 's100' quando si cerca 's10'
    pattern = ['^' exp_name '(\D|$)'];
    valid_idx = ~cellfun(@isempty, regexp({list.name}, pattern, 'once'));
    list = list(valid_idx);

    if ~isempty(list)
        folder_path = fullfile(root_path, list(1).name);
        
        % 3. Cerca i file secondo le regole ISCO
        % Regola A: File senza estensione con suffisso IP o ISCO
        no_ext_files = dir(fullfile(folder_path, '*'));
        for i = 1:length(no_ext_files)
            [~, fname, ext] = fileparts(no_ext_files(i).name);
            if ~no_ext_files(i).isdir && isempty(ext) && (endsWith(fname, 'IP') || endsWith(fname, 'ISCO') || contains(fname, 'isco'))
                isco_file_paths{end+1} = fullfile(folder_path, no_ext_files(i).name);
            end
        end
        
        % % Regola B: File .csv che contengono 'isco' (case sensitive)
        % csv_files = dir(fullfile(folder_path, '*isco*'));
        % file_names = {csv_files.name};
        % matches = contains(file_names, 'isco');
        % csv_files=csv_files(matches);
        % 
        % for i = 1:length(csv_files)
        %     isco_file_paths{end+1} = fullfile(folder_path, csv_files(i).name);
        % end
    end
end

% 4. Se la ricerca automatica fallisce, passa alla selezione manuale
if isempty(isco_file_paths)
    disp('Ricerca automatica dei file ISCO fallita. Selezionare i file manualmente.');
    [FileISCO, Path] = uigetfile({'*IP;*ISCO;*isco*.csv', 'File Dati ISCO'; '*.*', 'Tutti i file'}, ...
        'Seleziona i file ISCO da caricare', root_path, 'MultiSelect', 'on');
    
    if ~isequal(FileISCO, 0)
        % uigetfile restituisce una stringa per un file, un cell array per più file
        if iscell(FileISCO)
            isco_file_paths = fullfile(Path, FileISCO);
        else
            isco_file_paths = {fullfile(Path, FileISCO)};
        end
    end
end

end