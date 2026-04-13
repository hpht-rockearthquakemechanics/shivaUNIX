function new_handles = apply_trigger(handles, trigger_index)
% APPLY_TRIGGER - Imposta il tempo a zero in un punto specifico (trigger).
%
% SINTASSI:
%   new_handles = apply_trigger(handles, trigger_index)
%
% INPUT:
%   handles: (struct) La struttura dati principale.
%   trigger_index: (int) L'indice del punto da usare come trigger.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata.
%--------------------------------------------------------------------------

disp('Applying time trigger...');
new_handles = handles;

new_handles.triggered = new_handles.RateZero(trigger_index);
new_handles.Time = new_handles.Time - new_handles.Time(trigger_index);

disp([' -> Time zeroed at index ', num2str(trigger_index), '.']);

end