function new_handles = cut_data_by_timestep(handles, dt_value)
% CUT_DATA_BY_TIMESTEP - Trims the dataset to a specific time step.
%
% SINTASSI:
%   new_handles = cut_data_by_timestep(handles, dt_value)
%
% INPUT:
%   handles: (struct) The main data structure.
%   dt_value: (double) The desired time step value to keep.
%
% OUTPUT:
%   new_handles: (struct) The updated 'handles' structure.
%--------------------------------------------------------------------------

disp(['Cutting data to keep only time step = ', num2str(dt_value), '...']);
new_handles = handles;

indices_to_keep = find(new_handles.Stamp(:,1) == dt_value);

if length(indices_to_keep) <= 100
    warndlg('Attention: Number of remaining data points is less than 100.', 'Low Data Warning');
end

for n = 1:length(new_handles.column)
    col_name = new_handles.column{n};
    new_handles.(col_name) = new_handles.(col_name)(indices_to_keep, :);
end

disp(' -> Data cut complete.');

end