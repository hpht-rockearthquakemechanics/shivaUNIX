function new_handles = remove_outliers(handles, column_index, outlier_indices, button_type)
% REMOVE_OUTLIERS - Rimuove i punti anomali da una colonna di dati.
%
% SINTASSI:
%   new_handles = remove_outliers(handles, column_index, outlier_indices, button_type)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   column_index: (int) Indice della colonna da modificare.
%   outlier_indices: (array) Indici dei punti anomali da rimuovere.
%   button_type: (int) Tipo di pulsante del mouse premuto (2 per intervallo, 3 per punti singoli).
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata.
%--------------------------------------------------------------------------

disp('Removing outliers...');
new_handles = handles;

params = struct('column_index',column_index,'outlier_indices',outlier_indices,'button_type',button_type);
new_handles.log = append_action_to_log(new_handles.log, 'remove_outliers', params);

col_name = new_handles.column{column_index};

if button_type == 3 % Tasto destro: sostituzione punto per punto
    for i = 1:length(outlier_indices)
        idx = outlier_indices(i);
        if idx == 1 && length(new_handles.(col_name)) > 1
            new_handles.(col_name)(idx) = new_handles.(col_name)(idx + 1); % Edge case: primo punto
        elseif idx > 1
            new_handles.(col_name)(idx) = new_handles.(col_name)(idx - 1); % Sostituisci con il precedente
        end
    end
    disp([' -> ', num2str(length(outlier_indices)), ' individual outliers replaced in ''', col_name, '''.']);
elseif button_type == 2 % Tasto centrale: sostituzione di un intervallo
    start_idx = min(outlier_indices);
    end_idx = max(outlier_indices);
    if start_idx > 1
        new_handles.(col_name)(start_idx:end_idx) = new_handles.(col_name)(start_idx - 1);
        disp([' -> Range from index ', num2str(start_idx), ' to ', num2str(end_idx), ' replaced in ''', col_name, '''.']);
    end
end

end