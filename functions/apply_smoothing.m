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

new_handles.(new_col_name) = smooth(new_handles.(col_name), window_size);

% Aggiunge la nuova colonna alla lista se non esiste già
if ~any(strcmp(new_handles.column, new_col_name))
    new_handles.column{end+1} = new_col_name;
end

disp([' -> Smoothing applied. New column ''', new_col_name, ''' created.']);

end