function new_handles = decimate_data(handles, decimation_factor)
% DECIMATE_DATA - Downsample all data columns by a given factor.
%
% SINTASSI:
%   new_handles = decimate_data(handles, decimation_factor)
%
% INPUT:
%   handles: (struct) The main data structure.
%   decimation_factor: (int) The factor by which to downsample the data.
%
% OUTPUT:
%   new_handles: (struct) The updated 'handles' structure.
%--------------------------------------------------------------------------

disp(['Decimating data by a factor of ', num2str(decimation_factor), '...']);
new_handles = handles;

for n = 1:length(new_handles.column)
    col_name = new_handles.column{n};
    new_handles.(col_name) = downsample(new_handles.(col_name), decimation_factor);
end

new_handles.dec = 'ok';
disp(' -> Decimation complete.');

end