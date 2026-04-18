function new_handles = apply_running_mean(handles, column_index, range_indices)
% APPLY_RUNNING_MEAN - Calcola e sottrae la media mobile da una colonna.
%
% SINTASSI:
%   new_handles = apply_running_mean(handles, column_index, range_indices)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   column_index: (int) Indice della colonna su cui operare.
%   range_indices: (array) Array di due elementi [start, end] che definisce
%                  l'intervallo per il calcolo della media.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata.
%--------------------------------------------------------------------------

disp('Applying running mean...');
new_handles = handles;

params = struct('column_index',column_index,'range_indices',range_indices);
new_handles.log = append_action_to_log(new_handles.log, 'apply_running_mean', params);

col_name = new_handles.column{column_index};

mean_value = mean(new_handles.(col_name)(range_indices(1):range_indices(2),:));
new_handles.(col_name) = new_handles.(col_name) - mean_value;

disp([' -> Running mean subtracted from ''', col_name, '''.']);

end