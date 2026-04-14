function new_handles = apply_brutal_filter(handles, column_index, filter_param)
% APPLY_BRUTAL_FILTER - Applies a custom "brutal" filter to a data column.
%
% SINTASSI:
%   new_handles = apply_brutal_filter(handles, column_index, filter_param)
%
% INPUT:
%   handles: (struct) The main data structure.
%   column_index: (int) Index of the column to be filtered.
%   filter_param: (double) The parameter for the brutal filter.
%
% OUTPUT:
%   new_handles: (struct) The updated 'handles' structure.
%--------------------------------------------------------------------------

disp(['Applying brutal filter to column ', num2str(column_index), '...']);
new_handles = handles;

col_name = new_handles.column{column_index};
backup_col_name = [col_name, 'o'];

% Backup original data
new_handles.(backup_col_name) = new_handles.(col_name);

% Apply filter
new_handles.(col_name) = brutal_filter_fx(1024, 0.9, filter_param, new_handles.(col_name), new_handles.Stamp);

% Add backup column to the list if it's not already there
if ~any(strcmp(new_handles.column, backup_col_name))
    new_handles.column{end+1} = backup_col_name;
end

disp([' -> Filter applied. Original data saved in ''', backup_col_name, '''.']);

end