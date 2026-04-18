function new_handles = offset_encoder_zero(handles)
% OFFSET_ENCODER_ZERO - Azzera i dati dell'encoder fino al punto di trigger.
%
% SINTASSI:
%   new_handles = offset_encoder_zero(handles)
%
% INPUT:
%   handles: (struct) La struttura dati principale. Deve contenere il campo
%            'triggered' che indica l'indice di trigger.
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata.
%--------------------------------------------------------------------------

disp('Applying zero offset to encoders...');
new_handles = handles;

new_handles.log = append_action_to_log(new_handles.log, 'offset_encoder_zero', struct());

if ~isfield(new_handles, 'triggered') || new_handles.triggered == 0
    disp(' -> Warning: Trigger point not set. Cannot apply offset.');
    return;
end

% 'triggered' stores the value from RateZero, not the index.
% We need to find the index corresponding to this value.
trigger_val = new_handles.triggered;
trigger_idx = find(new_handles.RateZero == trigger_val, 1);

if isempty(trigger_idx)
    disp(' -> Error: Could not find trigger index.');
    return;
end

if isfield(new_handles, 'Encoder2'); new_handles.Encoder2(1:trigger_idx) = 0; end
if isfield(new_handles, 'Encoder'); new_handles.Encoder(1:trigger_idx) = 0; end

disp([' -> Encoders zeroed up to index ', num2str(trigger_idx), '.']);

end