function new_handles = unwrap_encoder(handles)
% UNWRAP_ENCODER - Applica la funzione unwrap a una colonna Encoder.
%
% SINTASSI:
%   new_handles = unwrap_encoder(handles)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata con la colonna
%                dell'encoder "srotolata".
%--------------------------------------------------------------------------

disp('Unwrapping Encoder data...');
new_handles = handles;

params = struct();
new_handles.log = append_action_to_log(new_handles.log, 'unwrap_encoder', params);

b = strfind(new_handles.column, 'Encoder2');
n_idx = find(~cellfun('isempty', b), 1);

if ~isempty(n_idx)
    col_name = new_handles.column{n_idx};
    new_handles.(col_name) = unwrap(new_handles.(col_name));
    disp([' -> Column ''', col_name, ''' has been unwrapped.']);
end

new_handles.Done = 1;

end