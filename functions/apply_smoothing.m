function new_handles = apply_smoothing(handles, column_index, window_size)
% APPLY_SMOOTHING - Applies a running mean to a data column.
%
% SINTASSI:
%   new_handles = apply_smoothing(handles, column_index, window_size)
%
% INPUT:
%   handles: (struct) The main data structure.
%   column_index: (int) Index of the column to be smoothed.
%   window_size: (int) The size of the moving average window.
%
% OUTPUT:
%   new_handles: (struct) The updated 'handles' structure.
%--------------------------------------------------------------------------

disp(['Applying smoothing to column ', num2str(column_index), '...']);
new_handles = handles;

params = struct('column_index',column_index,'window_size',window_size);
new_handles.log = append_action_to_log(new_handles.log, 'apply_smoothing', params);

col_name = new_handles.column{column_index};
backup_col_name = [col_name, 'o'];

% Backup original data
new_handles.(backup_col_name) = new_handles.(col_name);

% Apply smoothing using a moving average filter
if mod(window_size, 2) == 0
    window_size = window_size + 1; % Ensure window size is odd
end
new_handles.(col_name) = smooth(new_handles.(col_name), window_size);

% Add backup column to the list if it's not already there
if ~any(strcmp(new_handles.column, backup_col_name))
    new_handles.column{end+1} = backup_col_name;
end

disp([' -> Smoothing applied. Original data saved in ''', backup_col_name, '''.']);

end