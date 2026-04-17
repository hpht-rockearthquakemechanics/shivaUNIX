function new_handles = load_gefran_data(handles, gefran_file_path)
% LOAD_GEFRAN_DATA - Carica e processa i dati da un file GEFRAN.
%
% SINTASSI:
%   new_handles = load_gefran_data(handles, gefran_file_path)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   gefran_file_path: (string) Il percorso completo del file GEFRAN da caricare.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata con i dati GEFRAN.
%
%--------------------------------------------------------------------------

disp('Loading and processing GEFRAN data...');
new_handles = handles;

% --- 1. Rimuovi i dati GEFRAN precedenti ---
gefran_fields = {'SpeedGEF', 'timeGEF', 'TorqueGEF', 'VGEF', 'TqGEF'};
for i = 1:length(gefran_fields)
    if isfield(new_handles, gefran_fields{i})
        new_handles = rmfield(new_handles, gefran_fields{i});
    end
end
new_handles.column = new_handles.column(~ismember(new_handles.column, gefran_fields));

% --- 2. Carica il file GEFRAN dal percorso fornito ---
disp([' -> Importing GEFRAN file: ', gefran_file_path]);

gefran1 = 1; k = 0;
while ~isstruct(gefran1)
    k = k + 1;
    gefran1 = importdata(gefran_file_path, '\t', k);
end

% --- 3. Processa i dati e aggiorna la struttura handles ---
new = struct();
I = find(strncmp(gefran1.textdata, 'Time	Speed', 9)); if ~isempty(I); new.timeGEF = gefran1.data(:, 1); new.VGEF = gefran1.data(:, 2); end
I = find(strncmp(gefran1.textdata, 'Act Torque', 10)); if ~isempty(I); new.TqGEF = gefran1.data(:, I(1) - 1); end
I = find(strncmp(gefran1.textdata, 'Speed', 5)); if ~isempty(I); new.VGEF = gefran1.data(:, I(1) - 1); end
I = find(strncmp(gefran1.textdata, 'time', 4)); if ~isempty(I); new.timeGEF = gefran1.data(:, I(1) - 1); end

new_fnames = fieldnames(new);
for i = 1:length(new_fnames)
    new_handles.(new_fnames{i}) = new.(new_fnames{i});
end

% Aggiorna la lista delle colonne
sz=size(new_handles.column);
sz2=size(new_fnames);

if sz(1)>1 %is a column
    if sz2(1)>1 % also a column
        new_handles.column=[new_handles.column; new_fnames];
    else % is a row, need to transpose
        new_handles.column=[new_handles.column; new_fnames'];
    end
else % is a row
    if sz2(1)>1 % is a column, need to transpose
        new_handles.column = [new_handles.column, new_fnames'];
    else % is a row
        new_handles.column = [new_handles.column, new_fnames];
    end
    % maybe transpose new_handles.column
end

disp(' -> GEFRAN data loaded successfully.');
end