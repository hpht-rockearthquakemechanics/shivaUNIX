function new_handles = cut_data_range(handles, range_indices)
% CUT_DATA_RANGE - Taglia tutti i vettori di dati in un intervallo specificato.
%
% SINTASSI:
%   new_handles = cut_data_range(handles, range_indices)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   range_indices: (array) Array di due elementi [start, end] che definisce
%                  l'intervallo di dati da mantenere.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata e tagliata.
%--------------------------------------------------------------------------

disp(['Cutting data from index ', num2str(range_indices(1)), ' to ', num2str(range_indices(2)), '...']);
new_handles = handles;

start_idx = range_indices(1);
end_idx = range_indices(2);

new_handles.cutted = [new_handles.RateZero(start_idx), new_handles.RateZero(end_idx)];

for n = 1:length(new_handles.column)
    col_name = new_handles.column{n};
    new_handles.(col_name) = new_handles.(col_name)(start_idx:end_idx, :);
end

disp(' -> Data cutting complete.');

end