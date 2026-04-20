function new_handles = apply_trigger(handles, params_struct)
% APPLY_TRIGGER - Imposta il tempo a zero in un punto specifico (trigger).
%
% SINTASSI:
%   new_handles = apply_trigger(handles, params_struct)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   params_struct: (struct) Struttura con il campo:
%                  .trigger_index (int) L'indice del punto da usare come trigger.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata.
%--------------------------------------------------------------------------

disp('Applying time trigger...');
new_handles = handles;

trigger_index = params_struct.trigger_index;
new_handles.log = append_action_to_log(new_handles.log, 'apply_trigger', params_struct);

new_handles.triggered = new_handles.RateZero(trigger_index);
new_handles.Time = new_handles.Time - new_handles.Time(trigger_index);

disp([' -> Time zeroed at index ', num2str(trigger_index), '.']);

end