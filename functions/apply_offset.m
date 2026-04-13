function new_handles = apply_offset(handles, selected_columns_indices, offset_index)
% APPLY_OFFSET - Applica un offset a una o più colonne di dati.
%
% SINTASSI:
%   new_handles = apply_offset(handles, selected_columns_indices, offset_index)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   selected_columns_indices: (array) Indici delle colonne a cui applicare l'offset.
%   offset_index: (int) L'indice del punto da usare come offset (zero).
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata.
%--------------------------------------------------------------------------

disp('Applying offset to selected data...');
new_handles = handles;

for n = selected_columns_indices
    col_name = new_handles.column{n};
    offset_value = new_handles.(col_name)(offset_index);
    new_handles.(col_name) = new_handles.(col_name) - offset_value;
    disp([' -> Offset applied to ''', col_name, '''.']);
end

% Aggiorna i campi shearT o loadT se 'Axial' è tra le colonne selezionate
is_axial_selected = any(strcmp(new_handles.column(selected_columns_indices), 'Axial'));
if is_axial_selected
    new_handles.loadT = new_handles.RateZero(offset_index);
else
    new_handles.shearT = new_handles.RateZero(offset_index);
end

end