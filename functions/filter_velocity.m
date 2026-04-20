function new_handles = filter_velocity(handles, params_struct)
% FILTER_VELOCITY - Filters and combines encoder slip data to calculate velocity.
%
% SINTASSI:
%   new_handles = filter_velocity(handles, params_struct)
%
% INPUT:
%   handles: (struct) The main data structure.
%   params_struct: (struct) with field .transition_index (int).
%
% OUTPUT:
%   new_handles: (struct) The updated 'handles' structure with 'velF' and 'slipF'.
%--------------------------------------------------------------------------

disp('Filtering velocity and slip data...');
new_handles = handles;

transition_index = params_struct.transition_index;
new_handles.log = append_action_to_log(new_handles.log, 'filter_velocity', params_struct);

ya = new_handles.Slip_Enc_1(:,1);
yb = new_handles.Slip_Enc_2(:,1);
xt = new_handles.Time / 1000; % Time in seconds

% Filter both encoder signals
slip1 = filtravel_shiva(ya, xt, 50, 2); 
slip2 = filtravel_shiva(yb, xt, 5, 2); 

% Combine the two signals at the transition point
slip = slip1; 
slip(transition_index:end) = slip2(transition_index:end);

% Calculate velocity from the combined slip
vel = diff(slip) ./ diff(xt); 
vel(end+1) = vel(end); % Append last value to match size

new_handles.velF = vel;
new_handles.slipF = slip;

disp(' -> Velocity filtering complete. Fields ''velF'' and ''slipF'' created/updated.');

end