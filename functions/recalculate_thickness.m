function new_handles = recalculate_thickness(handles, ztl, zts)
% RECALCULATE_THICKNESS - Calcola lo spessore del gouge layer.
%
% SINTASSI:
%   new_handles = calculate_thickness(handles, ztl, zts)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   ztl: (double) Valore di zero (in Volt) per il trasduttore LVDT lungo.
%   zts: (double) Spessore iniziale (in mm) per il calcolo con LVDT corto.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata con i campi
%                'thickness_low' e 'thickness_high'.
%
%--------------------------------------------------------------------------

new_handles = handles;
new = struct();

cal.lv(1) = 5.0634;
cal.lv(2) = 0.3;

% Calcolo con LVDT lungo
b = strfind(new_handles.column, 'LVDT'); 
n = find(~cellfun('isempty', b));
if ~isempty(n)
    disp('Recalculating thickness_low...')
    % Assumiamo che il primo LVDT trovato sia quello lungo
    new.thickness_low = (new_handles.(new_handles.column{n(1)}) - ztl) * cal.lv(1);
end

% Calcolo con LVDT corto
b = strfind(new_handles.column, 'short');
n = find(~cellfun('isempty', b));
if ~isempty(n)
    disp('Recalculating thickness_high...')
    new.thickness_high = zts - cal.lv(2) * (new_handles.(new_handles.column{n(1)}));
end

% Aggiornamento finale della struttura handles
new_fnames = fieldnames(new);
for i = 1:length(new_fnames)
    fname = new_fnames{i};
    % Rimuovi il vecchio campo se esiste per evitare conflitti
    K = ~strcmp(fname, new_handles.column);
    new_handles.column = new_handles.column(K);
    % Aggiungi il nuovo campo dati
    new_handles.(fname) = new.(fname);
end

new_handles.column = [new_handles.column, new_fnames'];
new_handles.new = [new_handles.new; new_fnames];
new_handles.Done = 1;

end