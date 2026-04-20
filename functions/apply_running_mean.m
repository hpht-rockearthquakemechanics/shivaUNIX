function new_handles = apply_running_mean(handles, params_struct)
% APPLY_RUNNING_MEAN - Calcola e sottrae la media mobile da una colonna.
%
% SINTASSI:
%   new_handles = apply_running_mean(handles, params_struct)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   params_struct: (struct) con i campi .column_index e .range_indices.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata.
%--------------------------------------------------------------------------

disp('Applying running mean...');
new_handles = handles;

column_index = params_struct.column_index;
range_indices = params_struct.range_indices;

new_handles.log = append_action_to_log(new_handles.log, 'apply_running_mean', params_struct);

col_name = new_handles.column{column_index};

mean_value = mean(new_handles.(col_name)(range_indices(1):range_indices(2),:));
new_handles.(col_name) = new_handles.(col_name) - mean_value;

disp([' -> Running mean subtracted from ''', col_name, '''.']);

end