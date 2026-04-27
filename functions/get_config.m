function config = get_config()
% GET_SHIVA_CONFIG - Restituisce una struttura con le impostazioni di configurazione dell'applicazione.
%
% Questa funzione centralizza tutti i parametri configurabili per l'applicazione SHIVA UNIX.
%
% Output:
%   config: (struct) Una struttura contenente varie impostazioni di configurazione.
%
% Esempio:
%   cfg = get_shiva_config();
%   data_path = cfg.data_root_path;

config = struct();

% --- Percorsi File ---
% Directory radice per i file di dati ASCII (es. dal sistema di acquisizione SHIVA)
config.ascii_data_root_path = '\\10.164.3.225\spagnuolo\SHIVA-ACQ';

% Directory radice per i file di dati MAT (es. sessioni salvate)
config.mat_data_root_path = '\\10.164.3.225\spagnuolo\Dati';

% Directory radice per i file di dati GEFRAN
config.gefran_data_root_path = config.ascii_data_root_path;

% Percorso del file delle proprietà termiche (assunto essere nella cartella functions o nel path)
config.thermal_properties_file = 'thermal.txt';

% Directory radice per i file di dati ISCO
config.isco_data_root_path = config.ascii_data_root_path;

end