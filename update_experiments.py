import os
import yaml
import subprocess

exp_dir = r"//10.164.3.225/spagnuolo/Dati"

# Elenco delle cartelle da escludere a prescindere dal contenuto
folders_to_skip = ["dvc-storage"]
valid_folders = []

try:
    # 1. Itera su tutti gli elementi nella directory principale
    for d in os.listdir(exp_dir):
        folder_path = os.path.join(exp_dir, d)
        
        # 2. Verifica che sia una cartella e che non sia nella lista da saltare
        if os.path.isdir(folder_path) and d not in folders_to_skip:
            
            # 3. Guarda dentro la sottocartella per cercare un file .json
            try:
                # any() restituisce True non appena trova il PRIMO file che finisce con .json
                has_json = any(f.endswith('.json') for f in os.listdir(folder_path))
                
                if has_json:
                    valid_folders.append(d)
                    
            except (PermissionError, FileNotFoundError):
                # Ignora le sottocartelle in cui non abbiamo i permessi di lettura
                pass

except FileNotFoundError:
    valid_folders = []

# Salva la lista filtrata in params.yaml
with open("params.yaml", "w") as f:
    yaml.dump({"experiments": valid_folders}, f)

print("Lista esperimenti aggiornata. Avvio DVC...")
subprocess.run(["dvc", "repro"])