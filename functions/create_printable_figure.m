function create_printable_figure(handles)
% CREATE_PRINTABLE_FIGURE - Crea una nuova figura per la stampa copiando gli assi principali.
%
% SINTASSI:
%   create_printable_figure(handles)
%
% INPUT:
%   handles: (struct) La struttura dati principale dell'applicazione,
%            contenente gli handle agli assi (axes1, axes2, axes3).
%
%--------------------------------------------------------------------------

disp('Creating a new figure for printing...');

hf = figure('Name', ['Print Preview - ', handles.filename], 'NumberTitle', 'off');

% Lista degli assi da copiare
axes_to_copy = {handles.axes1, handles.axes2, handles.axes3};

for i = 1:length(axes_to_copy)
    ax_original = axes_to_copy{i};
    ax_new = copyobj(ax_original, hf);
    
    % Migliora il posizionamento e le etichette per la stampa
    pos = get(ax_new, 'Position');
    pos(1) = pos(1) + 0.1; % Aggiunge un po' di margine a sinistra
    set(ax_new, 'Position', pos);
    
    % Usa la legenda come etichetta Y per chiarezza
    if ~isempty(ax_original.Legend)
        ylabel(ax_new, ax_original.Legend.String{1}, 'Interpreter', 'none');
    end
end

disp(' -> Printable figure created.');
end