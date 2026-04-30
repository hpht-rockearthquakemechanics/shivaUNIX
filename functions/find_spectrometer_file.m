function spectrometer_file_path = find_spectrometer_file(base_filename, root_path)

spectrometer_file_path = {}; % Inizializza l'output come cell array

% 1. Estrai il nome dell'esperimento (es. 's2064') dal nome del file base
name_match = regexp(base_filename, 's\d+', 'match');
if isempty(name_match)
    warning('find_spectrometer_file:NoExpName', 'Impossibile estrarre un nome esperimento (es. "sXXXX") da "%s".', base_filename);
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
        
        asc_files = dir(fullfile(folder_path, '*.asc'));
        for i = 1:length(asc_files)
            [~, fname, ext] = fileparts(asc_files(i).name);
            if ~asc_files(i).isdir && strcmp(ext,'.asc')
                spectrometer_file_path{end+1} = fullfile(folder_path, asc_files(i).name);
            end
        end
        
    end
end

% 4. Se la ricerca automatica fallisce, passa alla selezione manuale
if isempty(spectrometer_file_path)
    disp('Ricerca automatica dei file SPECTROMETER fallita. Selezionare i file manualmente.');
    [FileMS, Path] = uigetfile({'*.asc', 'File Dati SPECTROMETER'; '*.*', 'Tutti i file'}, ...
        'Seleziona i file SPECTROMETER da caricare', root_path, 'MultiSelect', 'on');
    
    if ~isequal(FileMS, 0)
        % uigetfile restituisce una stringa per un file, un cell array per più file
        if iscell(FileMS)
            spectrometer_file_path = fullfile(Path, FileMS);
        else
            spectrometer_file_path = {fullfile(Path, FileMS)};
        end
    end
end

end