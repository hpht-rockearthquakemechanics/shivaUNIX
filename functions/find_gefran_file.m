function gefran_file_path = find_gefran_file(base_filename, root_path)
% FIND_GEFRAN_FILE - Automatically finds the GEFRAN data file or prompts the user.
%
% This function attempts to automatically locate the corresponding GEFRAN
% data file (.txt or .osc) based on the main experiment filename (e.g., 's2064.mat').
% If the automatic search fails, it opens a file selection dialog.
%
% SINTASSI:
%   gefran_file_path = find_gefran_file(base_filename, root_path)
%
% INPUT:
%   base_filename: (string) The filename of the main experiment (e.g., 's2064.mat').
%   root_path:     (string) The root directory where GEFRAN data folders are stored.
%
% OUTPUT:
%   gefran_file_path: (string) The full path to the found GEFRAN file, or an
%                     empty string if the operation is cancelled or fails.
%--------------------------------------------------------------------------

gefran_file_path = ''; % Initialize output

% 1. Extract experiment name (e.g., 's2064') from the base filename
name_match = regexp(base_filename, 's\d+', 'match');
if isempty(name_match)
    warning('find_gefran_file:NoExpName', 'Could not extract an experiment name (e.g., "sXXXX") from "%s".', base_filename);
else
    exp_name = name_match{1};

    % 2. Search for the corresponding experiment subfolder
    search_pattern = fullfile(root_path, [exp_name '*']);
    list = dir(search_pattern);

    % Refine search to avoid matching 's100' when searching for 's10'
    pattern = ['^' exp_name '(\D|$)'];
    valid_idx = ~cellfun(@isempty, regexp({list.name}, pattern, 'once'));
    list = list(valid_idx);

    if ~isempty(list)
        % 3. Look for .txt or .osc file inside the found folder
        folder_path = fullfile(root_path, list(1).name);
        file_list = dir(fullfile(folder_path, '*.txt'));
        if isempty(file_list)
            file_list = dir(fullfile(folder_path, '*.osc'));
        end

        if ~isempty(file_list)
            gefran_file_path = fullfile(folder_path, file_list(1).name);
        end
    end
end

% 4. If automatic search failed, fall back to manual selection
if isempty(gefran_file_path)
    disp('Automatic file search failed. Please select the GEFRAN file manually.');
    [FileGEF, Path] = uigetfile(fullfile(root_path, '*.txt;*.osc'), 'Select the GEFRAN file to load');
    if ~isequal(FileGEF, 0)
        gefran_file_path = fullfile(Path, FileGEF);
    end
end

end