function new_handles = recalculate_temperature(handles, AI_states)
% RECALCULATE_TEMPERATURE - Ricalcola la temperatura interna dai sensori TC.
%
% SINTASSI:
%   new_handles = recalculate_temperature(handles, AI_states)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   AI_states: (array) Array di stati per i canali di input analogici (AI).
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata con 'InternalTemperature'.
%
%--------------------------------------------------------------------------

new_handles = handles;

params = struct('AI_states',AI_states);
new_handles.log = append_action_to_log(new_handles.log, 'recalculate_temperature', params);

new = struct();

% Cerca i canali configurati come termocoppie (TC, stato 3)
for L = 1:18
    if AI_states(L) == 3 % 3 corrisponde a 'TC'
        ai_channel_name = ['AI', num2str(L)];
        b = strfind(new_handles.column, ai_channel_name);
        n = find(~cellfun('isempty', b), 1);
        
        if ~isempty(n)
            disp(['Recalculating temperature from thermocouple on channel ', ai_channel_name, '...']);
            temp_data = calibrate_temperature_fx(120, new_handles.(new_handles.column{n}), [], []);
            temp_data(isnan(temp_data)) = 0;
            new.InternalTemperature = temp_data;
            
            % Aggiorna handles e esci dopo aver trovato la prima termocoppia
            new_handles.InternalTemperature = new.InternalTemperature; % This line is redundant, new.InternalTemperature is assigned to new_handles.InternalTemperature below
            if ~any(strcmp('InternalTemperature', new_handles.column))
                new_handles.column{end+1} = 'InternalTemperature';
            end
            break; % Assumiamo una sola termocoppia per questo refresh
        end
    end
end

% Aggiornamento finale della struttura handles
new_fnames = fieldnames(new);
for i = 1:length(new_fnames)
    fname = new_fnames{i};
    new_handles.(fname) = new.(fname);
    if ~any(strcmp(fname, new_handles.column))
        new_handles.column{end+1} = fname;
    end
end

end