function new_handles = recalculate_stress(handles, rint, rext, calibration_index, is_GH, pf_index)
% RECALCULATE_STRESS - Ricalcola stress normale, di taglio e coefficiente di frizione.
%
% SINTASSI:
%   new_handles = recalculate_stress(handles, rint, rext, calibration_index, is_GH, pf_index)
% 
% INPUT:
%   handles: (struct) La struttura dati principale.
%   rint: (double) Raggio interno del campione.
%   rext: (double) Raggio esterno del campione.
%   calibration_index: (int) Indice della calibrazione selezionata.
%   is_GH: (logical) Flag che indica se il Gouge Holder è attivo.
%   pf_index: (int) Indice del menu a tendina per la pressione dei pori (PoreFluid).
%
% OUTPUT:
%   new_handles: (struct) La struttura 'handles' aggiornata.
%
%--------------------------------------------------------------------------

new_handles = handles;
params = struct('rint', rint, 'rext', rext, 'calibration_index', calibration_index, 'is_GH', is_GH, 'pf_index', pf_index);
new_handles.log = append_action_to_log(new_handles.log, 'recalculate_stress', params);

new = struct();
contents = calibration_index;

disp('Recalculating Stress and Friction...');

% This function now performs in-place updates to avoid changing the size of handles.column

% Costanti di calibrazione
cal_coeffs = [73.86, 1117.17, 730.94, 1118, 1179.2, 0, 0, 0, 0, 0, 0];
if contents > 1 && contents <= length(cal_coeffs) + 1
    cal.tHG = cal_coeffs(contents-1);
else
    cal.tHG = 0;
end
cal.tLG = 0.736e6; % Default value for LG torque
if contents == 5, cal.tHG = cal.tLG * 100; elseif contents == 2 || contents == 3 || contents == 4, cal.tLG = cal.tHG; end

cal.torqueHG(1:12) = cal.tHG * 3/2 / pi / (rext^3 - rint^3) * 1E-6;
cal.torqueLG(1:12) = (0.736e6) * 3/2 / pi / (rext^3 - rint^3) * 1E-6;

if contents >= 11, cal.ax = -7.93457 / pi / (rext^2 - rint^2) / 1000; %MPa
else, cal.ax = 2.5 / pi / (rext^2 - rint^2) / 1000; %MPa
end

% Calcola Normal Stress
axial_indices = find(contains(new_handles.column, 'Axial'));
if ~isempty(axial_indices)
    % Use the first column found that contains 'Axial' (e.g., 'Axial' or 'Axialload')
    axial_field_name = new_handles.column{axial_indices(1)};
    new.Normal = new_handles.(axial_field_name) * cal.ax;
end

% Correggi per elasticità delle molle (GH)
if is_GH
    cal.lv(1) = 5.0634;
    x = new_handles.LVDT - new_handles.LVDT(1);
    [~, Ia] = min(abs(x - 5.37));
    new.dspring = (x - x(Ia)) * cal.lv(1);
    new.dspring(1:Ia) = 0;
    
    if contents >= 11
        new.NormalGH = (-7.93457 * new_handles.Axial - (0.2666 + 0.0501 * new.dspring)) / pi / (rext^2 - rint^2) / 1000; %MPa
    else
        new.NormalGH = (2.5 * new_handles.Axial - (0.2666 + 0.0501 * new.dspring)) / pi / (rext^2 - rint^2) / 1000; %MPa
    end
end

% Calcola Shear Stress e Frizione
b = strfind(new_handles.column, 'Torque');
torque_indices = find(~cellfun('isempty', b));

for j = 1:length(torque_indices)
    idx = torque_indices(j);
    col_name = new_handles.column{idx};

    if contains(col_name, 'HG') || strcmp(col_name, 'Torque')
        cali = cal.torqueHG(j);
    elseif contains(col_name, 'LG')
        cali = cal.torqueLG(j);
    end

    new.(['shear' num2str(j)]) = new_handles.(col_name) * cali;
    mu_field = ['Mu' num2str(j)];
    shear_field = ['shear' num2str(j)];

    if pf_index >= 2 && isfield(new_handles, 'EffPressure')
        new.(mu_field) = new.(shear_field) ./ new_handles.EffPressure;
    else
        target_normal_field = if_then_else(is_GH && isfield(new, 'NormalGH'), 'NormalGH', 'Normal');
        if isfield(new, target_normal_field)
            new.(mu_field) = new.(shear_field) ./ new.(target_normal_field);
        end
    end
end

% Aggiorna handles
new_fnames = fieldnames(new);
if ~isempty(new_fnames)
    for i = 1:length(new_fnames)
        fname = new_fnames{i};
        new_handles.(fname) = new.(fname);
        % Add the new field to the column list if it doesn't already exist
        if ~any(strcmp(fname, new_handles.column))
            new_handles.column{end+1} = fname;
        end
    end
    new_handles.new = new_fnames;
end
new_handles.Done = 1;

end

function result = if_then_else(condition, true_val, false_val)
    if condition
        result = true_val;
    else
        result = false_val;
    end
end