function new_handles = reset_session(handles)
% RESET_SESSION - Pulisce la sessione corrente, rimuovendo dati e grafici.
%
% SINTASSI:
%   new_handles = reset_session(handles)
%
% INPUT:
%   handles: (struct) La struttura dati dell'applicazione.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' dopo la pulizia.
%
%--------------------------------------------------------------------------

disp('Resetting current session...');

% --- 1. Pulisci i grafici ---
if isfield(handles, 'axes1') && ishandle(handles.axes1), cla(handles.axes1, 'reset'); end
if isfield(handles, 'axes2') && ishandle(handles.axes2), cla(handles.axes2, 'reset'); end
if isfield(handles, 'axes3') && ishandle(handles.axes3), cla(handles.axes3, 'reset'); end

% --- 2. Rimuovi i campi dati ---
if isfield(handles, 'column')
    % Assicura che 'handles.column' sia sempre un vettore riga per una concatenazione sicura
    fields_to_remove = handles.column(:)';
    % Aggiungi altri campi noti che devono essere rimossi
    fields_to_remove = [fields_to_remove, {'column', 'new', 'X', 'TimeZero', 'GEF'}];
    fields_to_remove = unique(fields_to_remove, 'stable');
    
    for i = 1:length(fields_to_remove)
        % Cerca campi che iniziano con 'GEF' (es. 'timeGEF')
        if endsWith(fields_to_remove{i}, 'GEF')
            gefran_fields = fieldnames(handles);
            gefran_to_remove = gefran_fields(contains(gefran_fields, 'GEF'));
            handles = rmfield(handles, gefran_to_remove);
        elseif isfield(handles, fields_to_remove{i})
            handles = rmfield(handles, fields_to_remove{i});
        end
    end
end

new_handles = handles;
disp(' -> Session reset complete.');
end